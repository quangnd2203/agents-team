# Web (Next.js) — Modular Architecture Guide

File này là "source of truth" BẮT BUỘC TUÂN THỦ cho tất cả AI Agents khi thao tác code trong `web/`.

---

## 1 Tổng quan cấu trúc

```text
web/
├── app/               ← Next.js App Router route layer (bridge only)
├── presentation/      ← Features UI, zustand state + actions hooks, shared components
├── modules/           ← Feature modules (gom entity + dto + usecase + services + repository + mapper)
│   ├── core/          ← Framework setup (api-client, storage, auth helpers, server/client adapters...)
│   ├── auth/
│   ├── task/
│   └── ...
├── shared/            ← Constants, utils, Tailwind theme helpers, extensions, mock data
├── public/            ← Static assets
└── middleware.ts      ← Next middleware nếu thật sự cần global routing/auth edge checks
```

### Nguyên tắc

- **1 module = 1 feature**, chứa đầy đủ: `entity/`, `dto/`, `usecase/`, `services/`, `repository/`, `mapper/`.
- **1 file = 1 type/component/store/helper chính** khi còn giữ được tính đọc hiểu.
- **Dùng `zustand` làm state management chính cho web**, thay cho Bloc/Cubit của mobile. Store phải đặt đúng scope, chỉ giữ state/selectors/setters tối thiểu và không biến thành global dump.
- **Presentation chỉ được giao tiếp qua `usecase/` và dùng types từ `entity/`** — CẤM chạm `dto/`, `services/`, `repository/`.
- **Modules ưu tiên framework-agnostic TypeScript**. `entity/`, `usecase/`, `mapper/` không import React, Next.js UI APIs, DOM APIs nếu không có lý do đặc biệt.

### Path import

- Ưu tiên import từ alias path của app, ví dụ:
  - `@/modules/...`
  - `@/presentation/...`
  - `@/shared/...`
- Nếu import relative leo quá 2 cấp (`../../../`), BẮT BUỘC chuyển sang alias import.

---

## 2 App Layer (`/app`)

`/app` là **Next.js App Router route layer** — KHÔNG chứa business logic hay feature UI lớn.

```text
app/
├── layout.tsx         ← root layout, html/body, providers shell
├── page.tsx           ← route entry, bridge sang presentation
├── global.css         ← Tailwind CSS + design tokens bắt buộc dùng chung
├── providers.tsx      ← client providers thật sự global nếu cần
├── loading.tsx        ← route loading boundary
├── error.tsx          ← route error boundary
├── not-found.tsx      ← not found boundary
├── route segments/    ← route folders: login/, tasks/, settings/, ...
└── api/               ← route handlers nếu web app sở hữu API endpoint cục bộ
```

### CẤM

- Viết use case, repository, business flow trong `app/`
- Nhét feature UI dài dòng vào `app/page.tsx` hoặc route segment page
- Để `app/` gọi trực tiếp `repository/` hoặc `services/`
- Đặt state store, form orchestration, API client riêng trong route files
- Hardcode design token trong route files thay vì dùng Tailwind token từ `global.css`

### Pattern chuẩn cho route `page.tsx`

```tsx
import { LoginPage } from '@/presentation/features/auth/login/login_page';

export default function Page() {
  return <LoginPage />;
}
```

### Trách nhiệm đúng của `app/`

- Chia route bằng Next.js App Router (`app/` route segments)
- Compose root layout, metadata, global providers, error/loading boundaries
- Import `global.css` để nạp Tailwind CSS và design tokens
- Bridge từ route sang `presentation/`
- Chứa route handlers chỉ khi endpoint đó thật sự thuộc web app boundary
- Đặt middleware global khi cần auth/redirect edge-level, không nhét business logic sâu

---

## 3 Presentation Layer

### Pattern: View + zustand Store + Actions Hook

```text
presentation/
├── app_state/                       ← App-wide zustand state/actions theo concern, không gom flat
│   ├── locale/
│   │   ├── locale.store.ts
│   │   └── useLocaleActions.ts
│   ├── theme/
│   │   ├── theme.store.ts
│   │   └── useThemeActions.ts
│   └── session/
│       ├── session.store.ts
│       └── useSessionActions.ts
│
├── features/
│   ├── auth/
│   │   ├── login/
│   │   │   ├── login_page.tsx
│   │   │   ├── login_message_keys.ts
│   │   │   ├── login_texts.ts
│   │   │   ├── state/
│   │   │   │   ├── login.store.ts
│   │   │   │   └── useLoginActions.ts
│   │   │   └── components/
│   │   │       └── login_form.tsx
│   │   ├── signup/
│   │   │   ├── signup_page.tsx
│   │   │   ├── state/
│   │   │   └── components/
│   │   ├── state/                   ← Shared state chỉ dùng chung giữa các flow auth
│   │   └── components/              ← Shared components chỉ dùng chung trong cụm auth
│   │
│   ├── tasks/
│   │   ├── list/
│   │   │   ├── tasks_page.tsx
│   │   │   ├── tasks_message_keys.ts
│   │   │   ├── tasks_texts.ts
│   │   │   ├── components/
│   │   │   └── state/
│   │   ├── detail/
│   │   └── edit/
│   │
│   └── settings/
│
└── components/                      ← Shared components không thuộc riêng feature nào
    ├── app_shell.tsx
    ├── loading_view.tsx
    └── error_view.tsx
```

| Layer | Trách nhiệm | Return |
|---|---|---|
| **zustand Store** (State holder) | Define state shape, selectors cơ bản, setters tối thiểu nếu cần | Hook selectors + minimal setters |
| **Actions Hook** (Presenter) | Chứa hàm/action tương tác xuống dưới (`usecase/service`) hoặc thay đổi state | Hook trả về actions |
| **Types** (Model) | Mặc định đặt cùng `*.store.ts` hoặc `use*Actions.ts`; chỉ tách file riêng khi type lớn hoặc reuse nhiều nơi | Plain TypeScript data |
| **Component/Page** (View) | Render UI, đọc selector, forward user interaction | React UI |

### Nguyên tắc

#### Feature cluster → flow/screen con

- `presentation/features/<feature>/` là **cụm feature** như `auth`, `tasks`, `settings`.
- Mỗi màn hình hoặc flow phải có thư mục con riêng dưới cụm feature, ví dụ:
  - `presentation/features/auth/login/`
  - `presentation/features/auth/signup/`
  - `presentation/features/tasks/list/`
  - `presentation/features/tasks/detail/`
- Page chính của flow đặt ngay trong thư mục flow nếu chỉ có 1 page, ví dụ `auth/login/login_page.tsx`. Không tạo `pages/` chỉ để chứa 1 file.
- `state/` của zustand store/actions phải nằm trong chính thư mục flow đang sở hữu state đó, ví dụ `auth/login/state/login.store.ts` và `auth/login/state/useLoginActions.ts`.
- `components/` trong flow chỉ chứa component dùng riêng cho flow đó, ví dụ `auth/login/components/login_form.tsx`.
- `features/<feature>/components/` chỉ dành cho component dùng chung giữa nhiều flow trong cùng cụm feature, ví dụ component dùng chung cho cả `auth/login` và `auth/signup`.
- `features/<feature>/state/` chỉ dành cho state UI/flow thật sự dùng chung giữa nhiều flow trong cùng cụm feature. Ví dụ `auth/state/authFlow.store.ts` + `auth/state/useAuthFlowActions.ts` nếu cả `login` và `signup` cùng dùng chung dữ liệu tạm như email prefill hoặc bước xác thực.
- User-facing text map, message keys, form labels và view constants thuộc riêng flow nào thì đặt trong thư mục flow đó. Chỉ đưa lên cấp cụm feature khi thật sự dùng chung giữa nhiều flow.
- Không tổ chức feature phẳng kiểu `features/<feature>/pages`, `features/<feature>/state`, `features/<feature>/components` nếu các file đó thực chất thuộc một màn hình/flow cụ thể.

#### Cách suy ra structure cho flow mới

- Tạo **feature cluster** khi nhóm màn hình cùng một domain sản phẩm hoặc cùng một module nghiệp vụ, ví dụ `auth`, `tasks`, `settings`, `profile`.
- Tạo **flow folder** khi có một route, màn hình, wizard, form, tab độc lập hoặc lifecycle riêng, ví dụ `login`, `signup`, `list`, `detail`, `edit`, `change_password`.
- Nếu một feature hiện chỉ có 1 flow, vẫn tạo flow folder ngay từ đầu để tránh phải move khi thêm flow thứ 2.
- Đưa file lên cấp `features/<feature>/components/`, `features/<feature>/state/`, hoặc text shared của feature chỉ khi file đó được ít nhất 2 flow trong cùng feature dùng thật.
- Đưa file lên `presentation/components/` hoặc `presentation/app_state/` chỉ khi nó được nhiều feature dùng, hoặc lifecycle của nó nằm ngoài một feature.
- Nếu chưa chắc file có dùng chung hay không, đặt nó ở flow cụ thể trước. Chỉ promote lên shared khi reuse thật sự xuất hiện.

#### Naming và placement

- Page chính: `features/<feature>/<flow>/<flow>_page.tsx`, ví dụ `auth/login/login_page.tsx`, `tasks/detail/detail_page.tsx`.
- Store/actions của flow: `features/<feature>/<flow>/state/<flow>.store.ts` và `use<Flow>Actions.ts`.
- `*.store.ts` chỉ define state shape, selectors cơ bản và setters tối thiểu nếu cần.
- `use*Actions.ts` là nơi chứa các hàm/action tương tác xuống dưới (`usecase/service`) hoặc thay đổi state.
- Type mặc định đặt ngay trong `*.store.ts` hoặc `use*Actions.ts` gần nơi sử dụng.
- Chỉ tách file type riêng khi type lớn, khó đọc nếu inline, hoặc được tái sử dụng nhiều nơi. Khi tách, đặt cùng `state/` và đặt tên theo concern như `login_types.ts` hoặc `task_filter_types.ts`.
- Component riêng của flow: `features/<feature>/<flow>/components/<purpose>_*.tsx`, ví dụ `login_form.tsx`, `task_list_item.tsx`.
- Text/message keys riêng của flow: đặt cạnh page trong flow folder, ví dụ `login_texts.ts`, `login_message_keys.ts`.
- Shared component/state/text ở cấp feature phải có tên theo concern chung, ví dụ `auth_form_field.tsx`, `authFlow.store.ts`, `taskFilters.store.ts`; không dùng tên của một màn cụ thể cho file shared.
- Test mirror theo structure của `presentation`, ví dụ `test/presentation/features/tasks/detail/detail_page.test.tsx`, `test/presentation/features/tasks/detail/state/detail.store.test.ts` và `test/presentation/features/tasks/detail/state/useDetailActions.test.ts`.

#### Ví dụ suy luận nhanh

- Thêm màn đổi mật khẩu sau đăng nhập: domain là auth, flow riêng là `change_password` → đặt ở `presentation/features/auth/change_password/change_password_page.tsx`, state ở `change_password/state/`, component riêng ở `change_password/components/`.
- Thêm màn chi tiết task: domain là tasks, route/lifecycle riêng là `detail` → đặt ở `presentation/features/tasks/detail/detail_page.tsx`, state ở `detail/state/`. Nếu dùng lại chip priority với list và detail thì promote chip lên `tasks/components/`.
- Thêm bộ lọc task dùng chung cho list và calendar: domain là tasks, state dùng chung nhiều flow trong tasks → đặt `taskFilters.store.ts` và `useTaskFiltersActions.ts` ở `presentation/features/tasks/state/`. Nếu filter chỉ dùng màn list thì để trong `tasks/list/state/`.

#### Shared state placement

- State chỉ dùng bởi một màn hình/flow: đặt trong `presentation/features/<feature>/<flow>/state/`.
- State UI/flow dùng chung nhiều flow trong cùng một feature cluster: đặt trong `presentation/features/<feature>/state/`.
- State dùng chung nhiều feature, cần sống qua navigation, hoặc là concern toàn app như session, current user, authentication status, locale, theme: đặt trong `presentation/app_state/<concern>/`.
- Auth/session toàn app KHÔNG đặt trong `presentation/features/auth/state/`. Nó phải nằm ở `presentation/app_state/session/` vì middleware/layout/app shell và nhiều feature khác tiêu thụ.
- Feature-level shared state phải đặt tên theo concern chung, không đặt theo một màn cụ thể. Ví dụ dùng `authFlow.store.ts`, `taskFilters.store.ts`; không đặt `login.store.ts` ở `auth/state/`.
- Không promote state lên `features/<feature>/state/` hoặc `presentation/app_state/` chỉ để tránh truyền props/callback. Chỉ promote khi có ownership và lifecycle thật sự rộng hơn một flow.

#### App-wide state (`presentation/app_state`)

- Dùng `presentation/app_state/<concern>/` cho state có lifecycle cùng app shell, được nhiều feature tiêu thụ, hoặc ảnh hưởng routing/bootstrap/global UI.
- Mỗi concern app-wide có folder riêng, ví dụ `session/`, `theme/`, `locale/`, `connectivity/`; không gom nhiều concern vào một zustand store lớn.
- App-wide actions được phép gọi use case cần thiết, nhưng vẫn phải giữ presentation boundary: ưu tiên import `modules/*/usecase/` và `modules/*/entity/`; service chỉ dùng khi đó là adapter được architecture cho phép rõ ràng.
- Không đưa state lên `app_state` nếu nó chỉ phục vụ một route, một form, một tab, một wizard cục bộ, hoặc chỉ được các flow trong cùng một feature dùng.
- Nếu state chỉ dùng chung trong một feature cluster, ưu tiên `presentation/features/<feature>/state/`. Chỉ promote lên `app_state` khi feature khác hoặc app shell/middleware thật sự cần đọc hoặc điều khiển state đó.
- `app_state` không thay thế feature state. Feature flow vẫn giữ state UI cụ thể của nó trong `features/<feature>/<flow>/state/` và chỉ đọc app-wide state khi cần context toàn app.

Ví dụ:

- Nên ở `presentation/app_state/session/`: `session.store.ts` giữ current user/authenticated status, `useSessionActions.ts` chứa restore session/logout; app shell, tasks và settings đều cần đọc.
- Chỉ nên ở `presentation/features/tasks/state/`: `taskFilters.store.ts` + `useTaskFiltersActions.ts` nếu cả `tasks/list` và `tasks/calendar` cùng dùng bộ lọc, nhưng auth/settings không cần biết.
- Chỉ nên ở `presentation/features/auth/login/state/`: `login.store.ts` giữ email/password draft, submit loading và login error; `useLoginActions.ts` chứa submit/reset của riêng màn login.

#### Import rule — Presentation CHỈ được import 2 thứ từ modules

```text
presentation → modules/*/usecase/    ✅
presentation → modules/*/entity/     ✅
presentation → modules/*/dto/        ❌
presentation → modules/*/services/   ❌
presentation → modules/*/repository/ ❌
```

#### Component chỉ render UI + forward interaction

- Component/Page đọc state qua zustand selector hoặc props đã được chuẩn hoá
- Component/Page không tự gọi HTTP, storage, SQL, cookie/session low-level
- `useState()` chỉ dùng cho UI-local ephemeral state rất nhỏ:
  - password visibility toggle
  - tab index tạm
  - animation / expansion local
- Component cần hook/browser API phải có `'use client'` ở boundary nhỏ nhất có thể

#### zustand store giữ state; actions hook gọi use case/service khi cần

```ts
// state/login.store.ts
import { create } from 'zustand';
import type { AuthSession } from '@/modules/auth/entity/auth_session';

type LoginState = {
  email: string;
  password: string;
  isSubmitting: boolean;
  session: AuthSession | null;
  errorMessage: string | null;
  setSubmitting: (isSubmitting: boolean) => void;
  setErrorMessage: (errorMessage: string | null) => void;
  setSession: (session: AuthSession | null) => void;
};

export const useLoginStore = create<LoginState>((set) => ({
  email: '',
  password: '',
  isSubmitting: false,
  session: null,
  errorMessage: null,
  setSubmitting: (isSubmitting) => set({ isSubmitting }),
  setErrorMessage: (errorMessage) => set({ errorMessage }),
  setSession: (session) => set({ session }),
}));

export const selectLoginCredentials = (state: LoginState) => ({
  email: state.email,
  password: state.password,
});
```

```ts
// state/useLoginActions.ts
import { loginUseCase } from '@/modules/auth/usecase/login_usecase';
import { useLoginStore } from './login.store';

export function useLoginActions() {
  return {
    async submit() {
      const {
        email,
        password,
        setSubmitting,
        setErrorMessage,
        setSession,
      } = useLoginStore.getState();

      setSubmitting(true);
      setErrorMessage(null);

      const result = await loginUseCase.execute({ email, password });

      setSubmitting(false);
      setSession(result.session);
    },
    resetError() {
      useLoginStore.getState().setErrorMessage(null);
    },
  };
}
```

#### Global Store vs Local Store

| | Global Store | Local/Feature Store |
|---|---|---|
| Vị trí | `presentation/app_state/<concern>/` | `presentation/features/<feature>/<flow>/state/` |
| Scope | Nhiều features dùng chung | Chỉ một màn hình/flow |
| Nội dung | auth session, current user, locale, theme, app-wide flags + app-wide actions hook | screen state, form state, filter, wizard, detail state + flow actions hook |
| Lifecycle | sống ở app/browser session scope | gắn với route/feature usage, reset rõ khi rời flow nếu cần |

### Rule cho zustand

- **Dùng `zustand` làm state management mặc định cho web**, thay cho Bloc/Cubit của mobile.
- `*.store.ts` chỉ define state shape, selectors cơ bản và setters tối thiểu nếu cần; không gọi `usecase/`, `repository/`, `services/`, `dto/`.
- `use*Actions.ts` là nơi chứa action gọi `usecase/` hoặc service adapter được phép; không gọi trực tiếp `repository/`, không import `dto/`.
- Store/actions luôn đi cùng trong cùng folder; nếu có type file riêng thì type file cũng đặt cùng folder ownership, không tách ra một thư mục flat.
- Global store chỉ dùng cho state thật sự cross-feature hoặc cần sống qua navigation.
- Local/feature actions phải có reset/hydration rõ nếu dữ liệu không nên giữ sau khi rời flow.
- Dùng selector hẹp để tránh component rerender lan rộng.
- Không persist zustand store nếu chưa có yêu cầu rõ về UX/session; nếu persist, phải nêu storage key, migration và dữ liệu nhạy cảm.
- Không promote store lên global chỉ để tránh truyền props.

### Flow

```text
User interaction
  → Component/Page gọi action từ use*Actions.ts hoặc handler
  → Actions hook gọi Use Case (@/modules/*/usecase/) hoặc service adapter được phép
  → Actions hook dùng setters tối thiểu để update store state
  → Chỉ component subscribe selector liên quan mới rerender
```

> Presentation **không biết và không quan tâm** use case bên trong gọi repository, service, fetch client hay storage gì. Đó là việc của `modules/`.

---

## 4 Modules Layer (`/modules`)

Mỗi module = 1 feature, chứa các thư mục con tuỳ nhu cầu:

```text
modules/auth/
├── entity/
│   ├── auth_session.ts
│   └── auth_error_code.ts
│
├── dto/
│   ├── login_request_dto.ts
│   ├── login_response_dto.ts
│   └── user_profile_response_dto.ts
│
├── usecase/
│   ├── login_usecase.ts
│   ├── logout_usecase.ts
│   └── restore_session_usecase.ts
│
├── services/
│   └── auth_service.ts
│
├── repository/
│   └── auth_repository.ts
│
├── mapper/
│   ├── auth_session_mapper.ts
│   └── user_profile_mapper.ts
│
└── tests/
    ├── login_usecase.test.ts
    └── ...
```

### Vai trò từng thư mục

| Thư mục | Chứa gì | Import được |
|---|---|---|
| `entity/` | Domain models, enums, value objects | Không import React/Next UI |
| `dto/` | API/storage request-response contracts | `entity/` nếu cần |
| `usecase/` | Orchestrate repository/service/mapper | Mọi thứ trong cùng module |
| `services/` | Business-support, storage, 3rd party integration | `entity/`, `dto/`, `modules/core/` |
| `repository/` | HTTP calls, persistence access | `entity/`, `dto/`, `modules/core/` |
| `mapper/` | Chuyển DTO ↔ Entity | `entity/`, `dto/` |

### Quy tắc

- **Use case là entry point duy nhất** từ presentation vào module.
- **Use case import trực tiếp concrete class/function** nếu scope còn nhỏ và rõ. Dependency được wiring ở composition/provider boundary, không resolve bừa trong business flow.
- **Cross-module CẤM mặc định** — `modules/auth/` không được import logic từ `modules/tasks/`.
- **Mapper có thư mục riêng** — mỗi file map 1 DTO ↔ Entity hoặc 1 chiều transform chính.
- **Repository không return DTO lên presentation** — phải map ra entity hoặc result model phù hợp trước khi ra ngoài module.
- **Repository gọi HTTP qua API client ở `modules/core/api/`** — không tự new client khác trong từng feature.
- Code trong `modules/` phải rõ server/client compatibility. File dùng cookie server, headers, filesystem hoặc secret chỉ được gọi từ server boundary.

---

## 5 Module `core/` — Framework setup

```text
modules/core/
├── api/
│   ├── http_client.ts
│   ├── api_error.ts
│   └── interceptors/
├── storage/
│   ├── browser_storage_service.ts
│   └── server_cookie_service.ts
├── routing/
│   └── route_names.ts
├── logger/
│   └── app_logger.ts
└── tests/
```

> `core/` là cross-cutting — nhiều module cùng dùng. Không phải feature module.

### Quy tắc cho `core/`

- Chỉ chứa hạ tầng dùng chung thật sự
- Không nhét business logic của feature vào `core/`
- Nếu thứ gì chỉ phục vụ 1 feature, để lại trong feature đó
- HTTP client mặc định dùng wrapper thống nhất trong `modules/core/api/`; không tự introduce client khác nếu chưa có quyết định kiến trúc mới
- Tách rõ adapter browser/server khi dùng `window`, `localStorage`, cookies, headers hoặc secrets

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
- Tailwind helper, className helper, theme primitives
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
entity/ → không import React / Next UI / feature logic      ✅
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
app/         → modules/*/usecase/    ❌ (trừ server loader/route handler thật sự đặc biệt và có chủ đích)
```

---

## 8 Routing, DI, i18n

### Routing

- Dùng **Next.js App Router** trong `app/`.
- Route config được thể hiện bằng folder route segments trong `app/`.
- Route file (`page.tsx`, `layout.tsx`) chỉ bridge sang page/layout trong `presentation/`.
- Auth guard, onboarding redirect, deep link mapping đặt ở middleware, layout server boundary hoặc helper routing có chủ đích.
- Không nhét business logic hoặc HTTP calls tuỳ tiện vào route segment, `redirect`, `middleware`.
- Route handler trong `app/api/**/route.ts` chỉ dùng khi web app thật sự sở hữu endpoint đó; vẫn phải đi qua use case/module boundary.

### Dependency Injection

- Không dùng service locator global kiểu tuỳ tiện trong React tree.
- Dependency wiring tập trung ở composition/provider boundary rõ ràng như `app/providers.tsx`, `presentation/app_state/*`, hoặc factory trong `modules/core/`.
- `use*Actions.ts` nhận/call dependency qua import/factory rõ ràng; `*.store.ts` không resolve dependency hoặc gọi xuống use case/service.
- Không gọi repository/service trực tiếp từ component chỉ để "tiện".
- Không dùng `providers.tsx` generic để nhét mọi thứ. Nếu cần gom provider app-scope, đặt tên rõ vai trò và giữ mỏng.
- Trong test, phải reset zustand store, mock API client và setup provider/router/i18n rõ ràng.

### Localization / Translation

- App dùng translation đa ngữ theo **key-value**.
- Không hardcode user-facing text trong component, actions hook, store, use case, trừ debug text/dev-only.
- Key phải có namespace theo feature, ví dụ:
  - `auth.login.title`
  - `auth.login.error.invalid_credentials`
  - `task.list.empty`
- Localization bootstrap, dictionaries, locale routing/fallback nằm ở `app/` hoặc layer tương đương có chủ đích.
- Missing translation phải lộ rõ trong dev/test hoặc có fallback có kiểm soát.

---

## 9 Tech Stack & Tooling (BẮT BUỘC)

- **Framework:** Next.js App Router.
- **Runtime:** Node.js version theo file pin của repo (`.nvmrc`, `.node-version`, Volta hoặc package manager config nếu có).
- **Package manager:** dùng package manager đã được lock trong repo; không tự đổi npm/yarn/pnpm/bun.
- **State management:** `zustand` là mặc định, thay cho Bloc/Cubit của mobile.
- **Styling:** Tailwind CSS.
- **Design tokens:** định nghĩa trong `global.css` và consume qua Tailwind utility/CSS variables; không hardcode token rải rác.
- **HTTP client:** dùng API client wrapper trong `modules/core/api/`.
- **Navigation:** Next.js App Router (`app/` route segments, `next/link`, `next/navigation`).
- **Theming:** Tailwind CSS + design tokens trong `global.css` và helper theme trong `shared/theme/` nếu cần.
- **Testing:** unit test, React Testing Library, Playwright/e2e nếu repo đã có hoặc task yêu cầu.

### Node/package manager rules

- Dự án web phải dùng đúng Node/package manager đã pin trong repo.
- Không tự upgrade Next.js, React, Tailwind, TypeScript hoặc package manager nếu không có yêu cầu rõ.
- Không commit cache/build output như `.next/`, `node_modules/`, coverage artifacts, package manager cache.
- Command chuẩn cần ưu tiên theo script trong `package.json`:
  - `<pm> install` hoặc `<pm> install --frozen-lockfile` theo package manager
  - `<pm> lint`
  - `<pm> typecheck`
  - `<pm> test`
  - `<pm> build`
  - `<pm> dev`

### Next.js upgrade rules

- Chỉ upgrade Next.js/React/Tailwind khi có yêu cầu rõ hoặc task riêng.
- Khi upgrade:
  - đọc changelog/release notes chính thức của version target
  - cập nhật package + lockfile bằng đúng package manager của repo
  - chạy lint, typecheck, test, build
  - kiểm tra App Router, Server/Client Component boundary, middleware, route handlers
  - ghi rõ version cũ, version mới và breaking changes/risk nếu có

### UI invariants (always-on)

- Trước khi sửa UI, PHẢI đọc `global.css`, Tailwind config và theme/token hiện có.
- Không hardcode màu, spacing, typography nếu repo đã có token trong `global.css`.
- Reusable component phải nằm ở `presentation/components/` hoặc `presentation/features/<feature>/components/` đúng scope.
- Không nhét business logic vào render function/component body.
- Không dùng React context, hook hoặc `window` như service locator để đi xuyên nhiều layer.
- Chỉ thêm `'use client'` ở component nhỏ nhất thật sự cần browser state/effect/event handler.

---

## 10 Code Smells & Refactoring Signals

- **Component file > 300 dòng:** tách component con hoặc state/actions hook.
- **1 screen chứa quá nhiều nhánh async:** tách `use*Actions.ts` hoặc use case nhỏ hơn.
- **Presentation gọi HTTP/storage trực tiếp:** vi phạm kiến trúc → chuyển xuống module/use case.
- **Module import logic của module khác:** xem lại boundary.
- **Mapper quá nhiều nhánh hoặc transform lặp lại:** tách helper/map function nhỏ hơn.
- **Store state phình to, chứa quá nhiều concern:** chia state theo flow hoặc screen.
- **Global store giữ state chỉ dùng cho 1 màn:** hạ xuống Local/Feature Store.
- **Business logic nằm trong component render hoặc effect phức tạp:** kéo về `use*Actions.ts` hoặc use case.
- **`'use client'` lan rộng lên route/layout không cần thiết:** tách client island nhỏ hơn.
- **Tailwind class hardcode token lạ ngoài `global.css`:** đưa token về `global.css` hoặc dùng token có sẵn.

---

## 11 Quality Gates (trước khi merge)

- Dependency install pass bằng package manager của repo
- Format/lint pass theo script repo
- Typecheck pass
- Unit/component test pass nếu repo có test setup hoặc thay đổi logic
- Build Next.js pass khi thay đổi route, server/client boundary, config hoặc dependency
- Không vi phạm dependency rules
- Không import sai boundary giữa `presentation`, `modules`, `shared`, `app`
- Không hardcode design token ngoài `global.css`/theme layer
- Không introduce breaking change mà không nêu rõ migration impact

---

## 12 Testing Strategy

- **Use case / mapper / pure utils:** unit test
- **zustand store:** unit test state shape, selectors, setters tối thiểu, reset và persistence nếu có
- **use*Actions hook:** unit test action flow, use case/service mock, state transition qua store setters
- **Component có branching UI rõ ràng:** React Testing Library component test
- **Flow quan trọng như auth / onboarding / navigation guard:** Playwright/e2e hoặc integration test khi flow đã ổn định
- **Component test có store / router / i18n:** phải setup đủ zustand initial state, Next router mock, localization provider/dictionary và API client mock

Không đợi tới cuối mới thêm test nếu thay đổi logic hoặc contract quan trọng.
