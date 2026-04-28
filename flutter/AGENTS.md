# Mobile (Flutter) — Modular Architecture Guide

File này là "source of truth" BẮT BUỘC TUÂN THỦ cho tất cả AI Agents khi thao tác code trong `mobile/`.

---

## 1 Tổng quan cấu trúc

```text
lib/
├── main.dart          ← entrypoint tối thiểu
├── app/               ← Flutter bootstrap layer (bridge only)
├── presentation/      ← Features UI, global state, shared widgets
├── modules/           ← Feature modules (gom entity + dto + usecase + services + repository + mapper)
│   ├── core/          ← Framework setup (Dio api-client, storage, router helpers, secure storage...)
│   ├── auth/
│   ├── task/
│   └── ...
└── shared/            ← Constants, utils, theme, extensions, mock data
```

### Nguyên tắc

- **1 module = 1 feature**, chứa đầy đủ: `entity/`, `dto/`, `usecase/`, `services/`, `repository/`, `mapper/`.
- **1 file = 1 type/class/extension chính** khi còn giữ được tính đọc hiểu.
- **Dùng `GetIt` làm composition root duy nhất cho dependency management**. Không rải `registerSingleton`, `registerFactory` lung tung ngoài bootstrap layer.
- **Presentation chỉ được giao tiếp qua `usecase/` và dùng types từ `entity/`** — CẤM chạm `dto/`, `services/`, `repository/`.
- **Modules ưu tiên pure Dart**. `entity/`, `usecase/`, `mapper/` không import Flutter UI packages nếu không có lý do đặc biệt.

### Path import

- Ưu tiên import từ package path của app, ví dụ:
  - `package:task_flow_mobile/modules/...`
  - `package:task_flow_mobile/presentation/...`
  - `package:task_flow_mobile/shared/...`
- Nếu import relative leo quá 2 cấp (`../../../`), BẮT BUỘC chuyển sang package import.

---

## 2 App Layer (`/app`)

`/app` là **Flutter bootstrap layer** — KHÔNG chứa business logic hay feature UI lớn.

```text
app/
├── bootstrap.dart     ← init app-wide: binding, env, logger, async setup
├── app.dart           ← root widget, MaterialApp.router
├── router.dart        ← go_router hoặc router config
├── di.dart            ← GetIt registrations / composition root
├── localization.dart  ← supported locales, delegates, fallback rules
├── env.dart           ← app env / flavor wiring
└── guards/            ← route guards thật sự global nếu cần
```

### CẤM

- Viết use case, repository, business flow trong `app/`
- Nhét màn hình feature dài dòng vào `app.dart`
- Để `app/` gọi trực tiếp `repository/` hoặc `services/`

### Pattern chuẩn cho `main.dart`

```dart
import 'package:task_flow_mobile/app/bootstrap.dart';

Future<void> main() async {
  await bootstrap();
}
```

### Trách nhiệm đúng của `app/`

- Gọi `WidgetsFlutterBinding.ensureInitialized()`
- Khởi tạo `GetIt` registrations ở `di.dart` hoặc bootstrap layer
- Compose root `MaterialApp` hoặc `MaterialApp.router`
- Gắn router, theme, localization
- Chỉ bridge sang `presentation/`

---

## 3 Presentation Layer

### Pattern: MVP + Bloc/Cubit

```text
presentation/
├── app_state/                       ← App-wide Cubit theo concern, không gom flat
│   ├── locale/
│   │   ├── locale_cubit.dart
│   │   └── locale_state.dart
│   ├── theme/
│   │   ├── theme_cubit.dart
│   │   └── theme_state.dart
│   └── session/
│       ├── session_cubit.dart
│       └── session_state.dart
│
├── features/
│   ├── auth/
│   │   ├── login/
│   │   │   ├── login_page.dart
│   │   │   ├── login_message_keys.dart
│   │   │   ├── login_texts.dart
│   │   │   ├── state/
│   │   │   │   ├── login_cubit.dart
│   │   │   │   └── login_state.dart
│   │   │   └── widgets/
│   │   │       └── login_form.dart
│   │   ├── signup/
│   │   │   ├── signup_page.dart
│   │   │   ├── state/
│   │   │   └── widgets/
│   │   ├── state/                   ← Shared state chỉ dùng chung giữa các flow auth
│   │   └── widgets/                 ← Shared widgets chỉ dùng chung trong cụm auth
│   │
│   ├── tasks/
│   │   ├── list/
│   │   │   ├── tasks_page.dart
│   │   │   ├── tasks_message_keys.dart
│   │   │   ├── tasks_texts.dart
│   │   │   ├── widgets/
│   │   │   └── state/
│   │   ├── detail/
│   │   └── edit/
│   │
│   └── settings/
│
└── widgets/                         ← Shared widgets không thuộc riêng feature nào
    ├── app_scaffold.dart
    ├── loading_view.dart
    └── error_view.dart
```

| Layer | Trách nhiệm | Return |
|---|---|---|
| **Cubit** (Presenter) | Orchestrate: gọi use case → emit state | Stream state + methods |
| **State** (Model) | Immutable UI state cho từng screen/flow | Plain data |
| **Widget/Page** (View) | `BlocBuilder` / `BlocListener`, render UI, forward user interaction | UI |

### Nguyên tắc

#### Feature cluster → flow/screen con

- `presentation/features/<feature>/` là **cụm feature** như `auth`, `tasks`, `settings`.
- Mỗi màn hình hoặc flow phải có thư mục con riêng dưới cụm feature, ví dụ:
  - `presentation/features/auth/login/`
  - `presentation/features/auth/signup/`
  - `presentation/features/tasks/list/`
  - `presentation/features/tasks/detail/`
- Page chính của flow đặt ngay trong thư mục flow nếu chỉ có 1 page, ví dụ `auth/login/login_page.dart`. Không tạo `pages/` chỉ để chứa 1 file.
- `state/` của Cubit/State phải nằm trong chính thư mục flow đang sở hữu state đó, ví dụ `auth/login/state/login_cubit.dart`.
- `widgets/` trong flow chỉ chứa widget dùng riêng cho flow đó, ví dụ `auth/login/widgets/login_form.dart`.
- `features/<feature>/widgets/` chỉ dành cho widget dùng chung giữa nhiều flow trong cùng cụm feature, ví dụ widget dùng chung cho cả `auth/login` và `auth/signup`.
- `features/<feature>/state/` chỉ dành cho state UI/flow thật sự dùng chung giữa nhiều flow trong cùng cụm feature. Ví dụ `auth/state/auth_flow_cubit.dart` nếu cả `login` và `signup` cùng dùng chung dữ liệu tạm như email prefill hoặc bước xác thực.
- User-facing text map, message keys, form labels và view constants thuộc riêng flow nào thì đặt trong thư mục flow đó. Chỉ đưa lên cấp cụm feature khi thật sự dùng chung giữa nhiều flow.
- Không tổ chức feature phẳng kiểu `features/<feature>/pages`, `features/<feature>/state`, `features/<feature>/widgets` nếu các file đó thực chất thuộc một màn hình/flow cụ thể.

#### Cách suy ra structure cho flow mới

- Tạo **feature cluster** khi nhóm màn hình cùng một domain sản phẩm hoặc cùng một module nghiệp vụ, ví dụ `auth`, `tasks`, `settings`, `profile`.
- Tạo **flow folder** khi có một route, màn hình, wizard, form, tab độc lập hoặc lifecycle riêng, ví dụ `login`, `signup`, `list`, `detail`, `edit`, `change_password`.
- Nếu một feature hiện chỉ có 1 flow, vẫn tạo flow folder ngay từ đầu để tránh phải move khi thêm flow thứ 2.
- Đưa file lên cấp `features/<feature>/widgets/`, `features/<feature>/state/`, hoặc text shared của feature chỉ khi file đó được ít nhất 2 flow trong cùng feature dùng thật.
- Đưa file lên `presentation/widgets/` hoặc `presentation/app_state/` chỉ khi nó được nhiều feature dùng, hoặc lifecycle của nó nằm ngoài một feature.
- Nếu chưa chắc file có dùng chung hay không, đặt nó ở flow cụ thể trước. Chỉ promote lên shared khi reuse thật sự xuất hiện.

#### Naming và placement

- Page chính: `features/<feature>/<flow>/<flow>_page.dart`, ví dụ `auth/login/login_page.dart`, `tasks/detail/detail_page.dart`.
- Cubit/State của flow: `features/<feature>/<flow>/state/<flow>_cubit.dart` và `<flow>_state.dart`.
- Widget riêng của flow: `features/<feature>/<flow>/widgets/<purpose>_*.dart`, ví dụ `login_form.dart`, `task_list_item.dart`.
- Text/message keys riêng của flow: đặt cạnh page trong flow folder, ví dụ `login_texts.dart`, `login_message_keys.dart`.
- Shared widget/state/text ở cấp feature phải có tên theo concern chung, ví dụ `auth_form_field.dart`, `auth_flow_cubit.dart`, `task_filters_cubit.dart`; không dùng tên của một màn cụ thể cho file shared.
- Test mirror theo structure của `lib/presentation`, ví dụ `test/presentation/features/tasks/detail/detail_page_test.dart` và `test/presentation/features/tasks/detail/state/detail_cubit_test.dart`.

#### Ví dụ suy luận nhanh

- Thêm màn đổi mật khẩu sau đăng nhập: domain là auth, flow riêng là `change_password` → đặt ở `presentation/features/auth/change_password/change_password_page.dart`, state ở `change_password/state/`, widget riêng ở `change_password/widgets/`.
- Thêm màn chi tiết task: domain là tasks, route/lifecycle riêng là `detail` → đặt ở `presentation/features/tasks/detail/detail_page.dart`, state ở `detail/state/`. Nếu dùng lại chip priority với list và detail thì promote chip lên `tasks/widgets/`.
- Thêm bộ lọc task dùng chung cho list và calendar: domain là tasks, state dùng chung nhiều flow trong tasks → đặt `task_filters_cubit.dart` ở `presentation/features/tasks/state/`. Nếu filter chỉ dùng màn list thì để trong `tasks/list/state/`.

#### Shared state placement

- State chỉ dùng bởi một màn hình/flow: đặt trong `presentation/features/<feature>/<flow>/state/`.
- State UI/flow dùng chung nhiều flow trong cùng một feature cluster: đặt trong `presentation/features/<feature>/state/`.
- State dùng chung nhiều feature, cần sống qua navigation, hoặc là concern toàn app như session, current user, authentication status, locale, theme: đặt trong `presentation/app_state/<concern>/`.
- Auth/session toàn app KHÔNG đặt trong `presentation/features/auth/state/`. Nó phải nằm ở `presentation/app_state/session/` vì được router guard, app shell và nhiều feature khác tiêu thụ.
- Feature-level shared state phải đặt tên theo concern chung, không đặt theo một màn cụ thể. Ví dụ dùng `auth_flow_cubit.dart`, `task_filters_cubit.dart`; không đặt `login_cubit.dart` ở `auth/state/`.
- Không promote state lên `features/<feature>/state/` hoặc `presentation/app_state/` chỉ để tránh truyền callback/argument. Chỉ promote khi có ownership và lifecycle thật sự rộng hơn một flow.

#### App-wide state (`presentation/app_state`)

- Dùng `presentation/app_state/<concern>/` cho state có lifecycle cùng app shell, được nhiều feature tiêu thụ, hoặc ảnh hưởng routing/bootstrap/global UI.
- Mỗi concern app-wide có folder riêng, ví dụ `session/`, `theme/`, `locale/`, `connectivity/`; không gom nhiều concern vào một Cubit lớn.
- App-wide state được phép gọi use case cần thiết, nhưng vẫn phải giữ presentation boundary: chỉ import `modules/*/usecase/` và `modules/*/entity/`.
- Không đưa state lên `app_state` nếu nó chỉ phục vụ một route, một form, một tab, một wizard cục bộ, hoặc chỉ được các flow trong cùng một feature dùng.
- Nếu state chỉ dùng chung trong một feature cluster, ưu tiên `presentation/features/<feature>/state/`. Chỉ promote lên `app_state` khi feature khác hoặc router/app shell thật sự cần đọc hoặc điều khiển state đó.
- `app_state` không thay thế feature state. Feature flow vẫn giữ state UI cụ thể của nó trong `features/<feature>/<flow>/state/` và chỉ đọc app-wide state khi cần context toàn app.

Ví dụ:

- Nên ở `presentation/app_state/session/`: `SessionCubit` giữ current user, authenticated status, restore session, logout; router guard, app shell, tasks và settings đều cần đọc.
- Chỉ nên ở `presentation/features/tasks/state/`: `TaskFiltersCubit` nếu cả `tasks/list` và `tasks/calendar` cùng dùng bộ lọc, nhưng auth/settings không cần biết.
- Chỉ nên ở `presentation/features/auth/login/state/`: `LoginCubit` giữ email/password draft, submit loading và login error của riêng màn login.

#### Import rule — Presentation CHỈ được import 2 thứ từ modules

```text
presentation → modules/*/usecase/   ✅
presentation → modules/*/entity/    ✅
presentation → modules/*/dto/       ❌
presentation → modules/*/services/  ❌
presentation → modules/*/repository/ ❌
```

#### Widget chỉ render UI + forward interaction

- Widget/Page đọc state qua `BlocBuilder`, `BlocSelector`, `BlocListener`
- Widget/Page không tự gọi HTTP, storage, SQL, secure storage
- `setState()` chỉ dùng cho UI-local ephemeral state rất nhỏ:
  - text field obscure toggle
  - tab index tạm
  - animation / expansion local

#### Cubit là nơi gọi use case

```dart
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._loginUseCase) : super(const LoginState());

  final LoginUseCase _loginUseCase;

  Future<void> submit() async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    final result = await _loginUseCase.execute(
      email: state.email,
      password: state.password,
    );

    emit(state.copyWith(
      isSubmitting: false,
      isSuccess: true,
      user: result.user,
    ));
  }
}
```

#### Global Cubit vs Local Cubit

| | Global Cubit | Local Cubit |
|---|---|---|
| Vị trí | `presentation/app_state/<concern>/` | `presentation/features/<feature>/<flow>/state/` |
| Scope | Nhiều features dùng chung | Chỉ một màn hình/flow |
| Nội dung | auth session, current user, locale, theme, app-wide flags | screen state, form state, filter, wizard, detail state |
| Lifecycle | sống ở app scope | tạo ở page/route boundary và huỷ khi màn dispose |

### Rule cho Cubit

- **Ưu tiên `Cubit`** cho flow đơn giản và vừa phải.
- Chỉ nâng lên `Bloc` khi flow có nhiều event cạnh tranh, cần event history rõ, hoặc orchestration phức tạp.
- Cubit chỉ gọi `usecase/`, không gọi trực tiếp `repository/`, `services/`, `dto/`.
- Cubit luôn đi cùng `state` trong cùng folder; không tách `cubit` ra một thư mục flat rồi để `state` ở chỗ khác.
- Global Cubit chỉ dùng cho state thật sự cross-feature hoặc cần sống qua navigation.
- Local Cubit phải được tạo bằng `BlocProvider(create: ...)` tại route/page boundary. Khi pop màn, Cubit local phải được giải phóng theo lifecycle của widget tree.
- Không promote Cubit lên global chỉ để tránh truyền state.

### Flow

```text
User interaction
  → Widget/Page gọi method trên Cubit
  → Cubit gọi Use Case (@modules/*/usecase/)
  → Cubit emit state mới
  → Chỉ widget nào listen/build theo state đó mới rebuild
```

> Presentation **không biết và không quan tâm** use case bên trong gọi repository, service hay storage gì. Đó là việc của `modules/`.

---

## 4 Modules Layer (`/modules`)

Mỗi module = 1 feature, chứa các thư mục con tuỳ nhu cầu:

```text
modules/auth/
├── entity/
│   ├── auth_session.dart
│   └── auth_error_code.dart
│
├── dto/
│   ├── login_request_dto.dart
│   ├── login_response_dto.dart
│   └── user_profile_response_dto.dart
│
├── usecase/
│   ├── login_usecase.dart
│   ├── logout_usecase.dart
│   └── restore_session_usecase.dart
│
├── services/
│   └── auth_service.dart
│
├── repository/
│   └── auth_repository.dart
│
├── mapper/
│   ├── auth_session_mapper.dart
│   └── user_profile_mapper.dart
│
└── tests/
    ├── login_usecase_test.dart
    └── ...
```

### Vai trò từng thư mục

| Thư mục | Chứa gì | Import được |
|---|---|---|
| `entity/` | Domain models, enums, value objects | Không import Flutter UI |
| `dto/` | API/storage request-response contracts | `entity/` nếu cần |
| `usecase/` | Orchestrate repository/service/mapper | Mọi thứ trong cùng module |
| `services/` | Business-support, storage, 3rd party integration | `entity/`, `dto/`, `modules/core/` |
| `repository/` | HTTP calls, persistence access | `entity/`, `dto/`, `modules/core/` |
| `mapper/` | Chuyển DTO ↔ Entity | `entity/`, `dto/` |

### Quy tắc

- **Use case là entry point duy nhất** từ presentation vào module.
- **Use case import trực tiếp concrete class** nếu scope còn nhỏ và rõ. Dependency được wiring từ `GetIt` ở bootstrap/provider boundary, không resolve bừa trong business flow.
- **Cross-module CẤM mặc định** — `modules/auth/` không được import logic từ `modules/tasks/`.
- **Mapper có thư mục riêng** — mỗi file map 1 DTO ↔ Entity hoặc 1 chiều transform chính.
- **Repository không return DTO lên presentation** — phải map ra entity hoặc result model phù hợp trước khi ra ngoài module.
- **Repository gọi HTTP qua `Dio` client ở `modules/core/api/`** — không tự new client khác trong từng feature.

---

## 5 Module `core/` — Framework setup

```text
modules/core/
├── api/
│   ├── dio_api_client.dart
│   ├── api_exception.dart
│   └── interceptors/
├── storage/
│   ├── secure_storage_service.dart
│   └── local_storage_service.dart
├── routing/
│   └── route_names.dart
├── logger/
│   └── app_logger.dart
└── tests/
```

> `core/` là cross-cutting — nhiều module cùng dùng. Không phải feature module.

### Quy tắc cho `core/`

- Chỉ chứa hạ tầng dùng chung thật sự
- Không nhét business logic của feature vào `core/`
- Nếu thứ gì chỉ phục vụ 1 feature, để lại trong feature đó
- HTTP client mặc định là `Dio`; không tự introduce client khác nếu chưa có quyết định kiến trúc mới

---

## 6 Shared (`/shared`)

```text
shared/
├── constants/
├── utils/
├── theme/
├── extensions/
└── mockdata/
```

Chứa **non-UI-business-flow** và **shared primitives**:

- constants dùng chung
- pure utils
- theme tokens / spacing / typography / color scheme
- extensions
- mock data

Mọi layer đều có thể import `shared/`, nhưng không biến `shared/` thành bãi rác.

---

## 7 Dependency Rules tổng hợp

### Trong cùng module

```text
usecase/ → services/, repository/, dto/, entity/, mapper/  ✅
services/, repository/ → dto/, entity/, modules/core/      ✅
mapper/ → dto/, entity/                                     ✅
entity/ → không import Flutter UI / feature logic           ✅
```

### Cross-module

```text
modules/X → modules/X       ✅
modules/X → modules/core    ✅
modules/X → shared/         ✅
modules/X → modules/Y       ❓ (tự hỏi 3 câu dưới trước khi import)
```

#### Cross-module: tự hỏi 3 câu trước khi import

> Trả lời **3 câu** — nếu cả 3 đều YES thì mới cân nhắc, còn lại mặc định CẤM.

**Câu 1 — Chiều phụ thuộc có tự nhiên không?**  
Module X có thực sự sử dụng khái niệm của module Y, hay chỉ đang tiện tay dùng?

**Câu 2 — Có tạo circular không?**  
Nếu X import Y, liệu Y hoặc dependency chain của Y có import ngược lại X không?

**Câu 3 — Chỉ import type/model, không import logic?**  
Nếu cần chia sẻ logic, hãy đi qua use case hoặc trích phần dùng chung lên layer phù hợp; đừng gọi service/repository của feature khác trực tiếp.

### Từ bên ngoài vào modules

```text
presentation → modules/*/usecase/    ✅
presentation → modules/*/entity/     ✅
presentation → modules/*/dto/        ❌
presentation → modules/*/services/   ❌
presentation → modules/*/repository/ ❌
app/         → presentation          ✅
app/         → modules/*/usecase/    ❌ (trừ bootstrap thật sự đặc biệt và có chủ đích)
```

---

## 8 Routing, DI, i18n

### Routing

- Dùng `go_router`.
- Route config tập trung ở `lib/app/router.dart`.
- Route chỉ bridge sang page trong `presentation/`.
- Auth guard, onboarding redirect, deep link mapping đặt ở router layer.
- Không nhét business logic hoặc HTTP calls vào `redirect`.

### Dependency Injection

- Dùng `GetIt` làm composition root.
- Đăng ký dependency tập trung ở `lib/app/di.dart` hoặc `bootstrap.dart`.
- Cubit nhận dependency qua constructor injection.
- Không gọi `GetIt.I<T>()` sâu trong `usecase/`, `repository/`, `services/` nếu có thể truyền qua constructor.
- Không dùng `providers.dart` generic cho DI. Nếu cần gom `BlocProvider` app-scope, đặt tên rõ vai trò như `app_blocs.dart`.
- Trong test, phải reset hoặc setup lại `GetIt` container rõ ràng.

### Localization / Translation

- App dùng translation đa ngữ theo **key-value**.
- Không hardcode user-facing text trong widget, cubit, use case, trừ debug text/dev-only.
- Key phải có namespace theo feature, ví dụ:
  - `auth.login.title`
  - `auth.login.error.invalid_credentials`
  - `task.list.empty`
- Localization bootstrap, delegates, supported locales nằm ở `app/l10n/` hoặc layer tương đương.
- Missing translation phải lộ rõ trong dev/test hoặc có fallback có kiểm soát.

---

## 9 Tech Stack & Tooling (BẮT BUỘC)

- **Flutter SDK:** dùng **Flutter stable mới nhất qua FVM**.
- **SDK management:** dùng `fvm`, không chạy `flutter`/`dart` trực tiếp nếu repo đã có FVM config.
- **State management:** `Bloc/Cubit`, ưu tiên `Cubit`.
- **Dependency management:** `GetIt`.
- **HTTP client:** `Dio`.
- **Navigation:** `go_router` là lựa chọn mặc định cho app routing.
- **Theming:** `ThemeData` + design tokens trong `shared/theme/`.
- **Testing:** `flutter_test`, `bloc_test`, `integration_test`.

### FVM rules

- Dự án mobile quản lý Flutter SDK bằng FVM.
- Luôn pin **exact Flutter version** cho repo trong `.fvmrc` hoặc `.fvm/fvm_config.json` theo format repo đang dùng.
- Không dùng `flutter` hoặc `dart` global khi làm việc trong `mobile/`.
- Tất cả lệnh Flutter/Dart phải chạy qua `fvm`.
- Khi setup mới hoặc chủ động pin stable version:
  - `fvm use stable`
- Sau khi pin version:
  - commit file config FVM như `.fvmrc` hoặc `.fvm/fvm_config.json`
- Không commit Flutter SDK/cache local như `.fvm/flutter_sdk`, `.fvm/versions/` hoặc cache tương đương.
- Command chuẩn:
  - `fvm flutter pub get`
  - `fvm dart format --set-exit-if-changed .`
  - `fvm flutter analyze`
  - `fvm flutter test`
  - `fvm flutter run`

### Flutter upgrade rules

- Chỉ upgrade Flutter khi có yêu cầu rõ hoặc task riêng.
- Khi upgrade:
  - chạy `fvm releases` để chọn stable version phù hợp
  - chạy `fvm use <version>`
  - cập nhật file pin version
  - chạy `fvm flutter pub get`
  - chạy `fvm dart format --set-exit-if-changed .`
  - chạy `fvm flutter analyze`
  - chạy `fvm flutter test`
  - ghi rõ version cũ, version mới và breaking changes/risk nếu có

### UI invariants (always-on)

- Trước khi sửa UI, PHẢI đọc theme/token hiện có trong `shared/theme/` hoặc app theme layer.
- Không hardcode màu, spacing, typography nếu repo đã có token.
- Reusable widget phải nằm ở `presentation/widgets/` hoặc `presentation/features/<feature>/widgets/` đúng scope.
- Không nhét business logic vào `build()`.
- Không dùng `BuildContext` như service locator để đi xuyên nhiều layer.

---

## 10 Code Smells & Refactoring Signals

- **Widget file > 300 dòng:** tách widget con hoặc state/controller.
- **1 screen chứa quá nhiều nhánh async:** tách cubit/use case nhỏ hơn.
- **Presentation gọi HTTP/storage trực tiếp:** vi phạm kiến trúc → chuyển xuống module/use case.
- **Module import logic của module khác:** xem lại boundary.
- **Mapper quá nhiều nhánh hoặc transform lặp lại:** tách helper/map function nhỏ hơn.
- **State class phình to, chứa quá nhiều concern:** chia state theo flow hoặc screen.
- **Global Cubit giữ state chỉ dùng cho 1 màn:** hạ xuống Local Cubit.
- **Business logic nằm trong `BlocBuilder` / `BlocListener`:** kéo về Cubit hoặc use case.

---

## 11 Quality Gates (trước khi merge)

- `fvm flutter pub get` pass
- `fvm dart format --set-exit-if-changed .` pass
- `fvm flutter analyze` pass
- `fvm flutter test` pass
- Không vi phạm dependency rules
- Không import sai boundary giữa `presentation`, `modules`, `shared`
- Không introduce breaking change mà không nêu rõ migration impact

---

## 12 Testing Strategy

- **Use case / mapper / pure utils:** unit test
- **Cubit:** test bằng `bloc_test`
- **Widget có branching UI rõ ràng:** widget test
- **Flow quan trọng như auth / onboarding / navigation guard:** integration test khi flow đã ổn định
- **Widget test có Cubit / router / i18n:** phải setup đủ `BlocProvider`, `go_router`, localization delegates và `GetIt` test container

Không đợi tới cuối mới thêm test nếu thay đổi logic hoặc contract quan trọng.
