#!/usr/bin/env python3
"""Convert a Markdown file to DOCX through Pandoc with predictable validation."""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Convert Markdown to DOCX using pandoc."
    )
    parser.add_argument("input_md", type=Path, help="Input Markdown file.")
    parser.add_argument("output_docx", type=Path, help="Output DOCX file.")
    parser.add_argument(
        "--reference-docx",
        type=Path,
        help="Optional DOCX template/style reference passed to pandoc.",
    )
    parser.add_argument(
        "--standalone",
        action="store_true",
        help="Pass --standalone to pandoc.",
    )
    parser.add_argument(
        "--from",
        dest="input_format",
        default="gfm",
        help="Pandoc input format. Defaults to gfm for fenced code, tables, and task lists.",
    )
    parser.add_argument(
        "--highlight-style",
        default="tango",
        help="Pandoc syntax highlighting style for fenced code blocks.",
    )
    parser.add_argument(
        "--no-highlight",
        action="store_true",
        help="Disable Pandoc syntax highlighting.",
    )
    parser.add_argument(
        "--toc",
        action="store_true",
        help="Ask pandoc to include a table of contents.",
    )
    parser.add_argument(
        "--number-sections",
        action="store_true",
        help="Ask pandoc to number section headings.",
    )
    parser.add_argument(
        "--metadata",
        action="append",
        default=[],
        metavar="KEY=VALUE",
        help="Metadata field to pass to pandoc. Can be repeated.",
    )
    parser.add_argument(
        "--resource-path",
        action="append",
        default=[],
        type=Path,
        help="Resource search path for images and linked assets. Can be repeated.",
    )
    parser.add_argument(
        "--no-install",
        action="store_true",
        help="Do not try to install pandoc automatically when it is missing.",
    )
    parser.add_argument(
        "--no-render-mermaid",
        action="store_true",
        help="Leave mermaid code fences as code instead of rendering flow charts.",
    )
    parser.add_argument(
        "--mermaid-theme",
        default="default",
        help="Mermaid theme to use when rendering flow charts.",
    )
    parser.add_argument(
        "--mermaid-background-color",
        default="white",
        help="Background color for rendered Mermaid flow chart images.",
    )
    return parser.parse_args()


def fail(message: str) -> int:
    print(f"error: {message}", file=sys.stderr)
    return 1


def sudo_prefix() -> list[str] | None:
    if os.name == "nt":
        return []
    if hasattr(os, "geteuid") and os.geteuid() == 0:
        return []
    sudo = shutil.which("sudo")
    if sudo:
        return [sudo]
    return None


def run_command(command: list[str]) -> bool:
    print("running: " + " ".join(command), file=sys.stderr)
    result = subprocess.run(command, check=False)
    return result.returncode == 0


def install_with_supported_package_manager() -> bool:
    brew = shutil.which("brew")
    if brew:
        return run_command([brew, "install", "pandoc"])

    prefix = sudo_prefix()
    if prefix is not None and shutil.which("apt-get"):
        return run_command(prefix + ["apt-get", "update"]) and run_command(
            prefix + ["apt-get", "install", "-y", "pandoc"]
        )

    if prefix is not None and shutil.which("dnf"):
        return run_command(prefix + ["dnf", "install", "-y", "pandoc"])

    if prefix is not None and shutil.which("yum"):
        return run_command(prefix + ["yum", "install", "-y", "pandoc"])

    if prefix is not None and shutil.which("pacman"):
        return run_command(prefix + ["pacman", "-S", "--noconfirm", "pandoc"])

    choco = shutil.which("choco")
    if choco:
        return run_command([choco, "install", "pandoc", "-y"])

    scoop = shutil.which("scoop")
    if scoop:
        return run_command([scoop, "install", "pandoc"])

    return False


def ensure_pandoc(auto_install: bool) -> str | None:
    pandoc = shutil.which("pandoc")
    if pandoc or not auto_install:
        return pandoc

    print("pandoc was not found in PATH; attempting automatic install.", file=sys.stderr)
    if not install_with_supported_package_manager():
        return None
    return shutil.which("pandoc")


def ensure_mermaid_cli(auto_install: bool) -> list[str] | None:
    mmdc = shutil.which("mmdc")
    if mmdc:
        return [mmdc]

    npx = shutil.which("npx")
    if npx and auto_install:
        return [npx, "-y", "@mermaid-js/mermaid-cli"]

    npm = shutil.which("npm")
    if npm and auto_install:
        if run_command([npm, "install", "-g", "@mermaid-js/mermaid-cli"]):
            mmdc = shutil.which("mmdc")
            if mmdc:
                return [mmdc]

    return None


def validate_paths(args: argparse.Namespace) -> int:
    if not args.input_md.exists():
        return fail(f"input Markdown file does not exist: {args.input_md}")
    if not args.input_md.is_file():
        return fail(f"input Markdown path is not a file: {args.input_md}")
    if args.output_docx.suffix.lower() != ".docx":
        return fail(f"output path must end with .docx: {args.output_docx}")
    if args.reference_docx:
        if not args.reference_docx.exists():
            return fail(f"reference DOCX does not exist: {args.reference_docx}")
        if not args.reference_docx.is_file():
            return fail(f"reference DOCX path is not a file: {args.reference_docx}")
        if args.reference_docx.suffix.lower() != ".docx":
            return fail(f"reference document must end with .docx: {args.reference_docx}")
    for metadata in args.metadata:
        if "=" not in metadata or metadata.startswith("="):
            return fail(f"metadata must use KEY=VALUE format: {metadata}")
    for resource_path in args.resource_path:
        if not resource_path.exists():
            return fail(f"resource path does not exist: {resource_path}")
        if not resource_path.is_dir():
            return fail(f"resource path is not a directory: {resource_path}")
    return 0


def fence_start(line: str) -> tuple[str, str] | None:
    stripped = line.strip()
    if not stripped.startswith(("```", "~~~")):
        return None

    marker_char = stripped[0]
    marker_length = 0
    for char in stripped:
        if char != marker_char:
            break
        marker_length += 1

    if marker_length < 3:
        return None

    return marker_char * marker_length, stripped[marker_length:].strip()


def is_fence_end(line: str, marker: str) -> bool:
    stripped = line.strip()
    return stripped.startswith(marker[0] * len(marker))


def render_mermaid_blocks(args: argparse.Namespace, temp_dir: Path) -> Path | None:
    lines = args.input_md.read_text(encoding="utf-8").splitlines(keepends=True)
    output_lines: list[str] = []
    rendered_any = False
    index = 0
    i = 0

    while i < len(lines):
        start = fence_start(lines[i])
        if not start:
            output_lines.append(lines[i])
            i += 1
            continue

        marker, info = start
        language = info.split(maxsplit=1)[0].lower() if info else ""
        if language != "mermaid":
            output_lines.append(lines[i])
            i += 1
            continue

        i += 1
        block_lines: list[str] = []
        while i < len(lines) and not is_fence_end(lines[i], marker):
            block_lines.append(lines[i])
            i += 1

        if i >= len(lines):
            output_lines.append(marker + "mermaid\n")
            output_lines.extend(block_lines)
            break

        i += 1
        mermaid_cli = ensure_mermaid_cli(auto_install=not args.no_install)
        if not mermaid_cli:
            raise RuntimeError(
                "Mermaid flow chart rendering needs `mmdc`, `npx`, or `npm`. "
                "Install Node.js/npm or rerun with --no-render-mermaid."
            )

        index += 1
        rendered_any = True
        source_path = temp_dir / f"flowchart-{index}.mmd"
        image_path = temp_dir / f"flowchart-{index}.png"
        source_path.write_text("".join(block_lines), encoding="utf-8")

        command = mermaid_cli + [
            "-i",
            str(source_path),
            "-o",
            str(image_path),
            "-t",
            args.mermaid_theme,
            "-b",
            args.mermaid_background_color,
        ]
        if not run_command(command):
            raise RuntimeError(f"failed to render Mermaid flow chart: {source_path}")

        output_lines.append(f"![Flow chart {index}]({image_path.resolve().as_posix()})\n")

    if not rendered_any:
        return None

    prepared_path = temp_dir / args.input_md.name
    prepared_path.write_text("".join(output_lines), encoding="utf-8")
    return prepared_path


def build_command(
    args: argparse.Namespace,
    pandoc: str,
    input_md: Path,
    temp_dir: Path | None,
) -> list[str]:
    command = [pandoc, str(input_md), "-f", args.input_format, "-o", str(args.output_docx)]
    if args.reference_docx:
        command.append(f"--reference-doc={args.reference_docx}")
    if args.standalone:
        command.append("--standalone")
    if args.no_highlight:
        command.append("--no-highlight")
    elif args.highlight_style:
        command.append(f"--syntax-highlighting={args.highlight_style}")
    if args.toc:
        command.append("--toc")
    if args.number_sections:
        command.append("--number-sections")
    for metadata in args.metadata:
        command.extend(["--metadata", metadata])
    resource_paths = [args.input_md.parent, Path.cwd()]
    if temp_dir:
        resource_paths.append(temp_dir)
    resource_paths.extend(args.resource_path)
    command.append(
        "--resource-path="
        + os.pathsep.join(str(path.resolve()) for path in resource_paths)
    )
    return command


def main() -> int:
    args = parse_args()

    validation_error = validate_paths(args)
    if validation_error:
        return validation_error

    pandoc = ensure_pandoc(auto_install=not args.no_install)
    if not pandoc:
        return fail(
            "pandoc was not found and automatic installation did not complete. "
            "Install pandoc manually or make sure a supported package manager is "
            "available (brew, apt-get, dnf, yum, pacman, choco, or scoop)."
        )

    with tempfile.TemporaryDirectory(prefix="markdown-to-docx-") as raw_temp_dir:
        temp_dir = Path(raw_temp_dir)
        input_md = args.input_md

        if not args.no_render_mermaid:
            try:
                rendered_md = render_mermaid_blocks(args, temp_dir)
            except RuntimeError as error:
                return fail(str(error))
            if rendered_md:
                input_md = rendered_md

        args.output_docx.parent.mkdir(parents=True, exist_ok=True)
        command = build_command(args, pandoc, input_md, temp_dir)
        result = subprocess.run(command, check=False)
        if result.returncode != 0:
            return result.returncode

    if not args.output_docx.exists():
        return fail(f"pandoc completed but output was not created: {args.output_docx}")

    print(f"created: {args.output_docx}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
