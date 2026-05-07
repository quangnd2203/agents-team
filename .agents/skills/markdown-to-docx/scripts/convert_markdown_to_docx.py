#!/usr/bin/env python3
"""Convert a Markdown file to DOCX through Pandoc with predictable validation."""

from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
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
    return parser.parse_args()


def fail(message: str) -> int:
    print(f"error: {message}", file=sys.stderr)
    return 1


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


def build_command(args: argparse.Namespace, pandoc: str) -> list[str]:
    command = [pandoc, str(args.input_md), "-o", str(args.output_docx)]
    if args.reference_docx:
        command.append(f"--reference-doc={args.reference_docx}")
    if args.standalone:
        command.append("--standalone")
    if args.toc:
        command.append("--toc")
    if args.number_sections:
        command.append("--number-sections")
    for metadata in args.metadata:
        command.extend(["--metadata", metadata])
    if args.resource_path:
        command.append(
            "--resource-path=" + ":".join(str(path) for path in args.resource_path)
        )
    return command


def main() -> int:
    args = parse_args()

    validation_error = validate_paths(args)
    if validation_error:
        return validation_error

    pandoc = shutil.which("pandoc")
    if not pandoc:
        return fail(
            "pandoc was not found in PATH. Install pandoc, then rerun this script "
            "(for example: brew install pandoc)."
        )

    args.output_docx.parent.mkdir(parents=True, exist_ok=True)
    command = build_command(args, pandoc)
    result = subprocess.run(command, check=False)
    if result.returncode != 0:
        return result.returncode

    if not args.output_docx.exists():
        return fail(f"pandoc completed but output was not created: {args.output_docx}")

    print(f"created: {args.output_docx}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
