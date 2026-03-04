# 🔨 flutter_forge

A production-ready Flutter template. Clone, configure, and start building — everything is already wired.

---

## ⚡ Quick Start

```bash
git clone https://github.com/sushantkhadka23/flutter_forge.git
cd flutter_forge
make setup
```

`make setup` runs clean → splash → icons → code generation in one command.

---

## 🏗 Architecture

Clean Architecture with 3 layers per feature:

```
features/
└── auth/
    ├── data/          # models, datasources, repository impl
    ├── domain/        # entities, repository contracts, usecases
    └── presentation/  # cubit, pages, widgets
```

**Rules:**
- `domain` never imports Flutter or data packages
- `data` implements `domain` contracts
- `presentation` talks to `domain` only — never `data` directly
- Cubits use repositories directly for simple features, usecases for complex ones

---

## 📦 Key Packages

| Purpose | Package |
|---|---|
| DI | `get_it` + `injectable` |
| Routing | `auto_route` |
| State | `flutter_bloc` (Cubit) |
| Network | `dio` |
| Data classes | `freezed` + `json_serializable` |
| FP | `fpdart` |
| Local storage | `hive_ce` + `flutter_secure_storage` |
| Localization | `flutter_intl` |
| Assets | `flutter_gen` |
| Responsive | `flutter_screenutil` |
| Fonts | `google_fonts` (DM Sans) |
| Env | `envied` |

---

## 🗂 Folder Structure

```
lib/
├── core/
│   ├── app/          # AppCubit, AppThemeCubit, AppLocaleCubit , Global App Provider
│   ├── di/             # get_it + injectable setup
│   ├── env/            # envied config (dev/prod)
│   ├── error/          # AppException
│   ├── network/        # Dio client, interceptors, ApiException
│   ├── router/         # auto_route config + guards
│   ├── storage/        # LocalStorage (Hive), SecureStorage
│   ├── theme/          # AppTheme, AppColors, AppTextStyles, AppSizes
│   ├── typedefs/       # AsyncAppResponse, ApiResponse, UnitResponse etc.
│   ├── utils/          # extensions
│   └── widgets/        # shared widgets
├── features/
│   ├── onboarding/
│   ├── auth/
│   └── home/
├── localization/
│   └── arb/            # intl_en.arb, intl_ne.arb
└── main.dart
```

---

## 🎨 Theming

Light and dark themes both supported, driven by `AppThemeCubit`.

```dart
// Toggle from anywhere
context.read<AppThemeCubit>().setMode(ThemeMode.dark);

// Use the ThemeSelector widget
ThemeSelector()
```

Colors, text styles, and sizes all live in `core/theme/`:

```dart
AppColors.primary       // brand red
AppTextStyles.bodyLarge // DM Sans, responsive via .sp
AppSizes.pagePadding    // responsive via .w / .h / .r
```

---

## 🌍 Localization

Powered by `flutter_intl`. Supported languages: **English** and **नेपाली**.

**Adding a new language:**
1. Add arb file: `lib/localization/arb/intl_fr.arb`
2. Add to `AppLocale` enum:
```dart
fr('Français', '🇫🇷', 'FR'),
```
That's it — no other changes needed.

**Usage anywhere (no context needed):**
```dart
import 'package:flutter_forge/localization/localization.dart';

Text(localization.homeTitle)
```

**Switch language:**
```dart
context.read<AppLocaleCubit>().setLocale(AppLocale.ne);

// Or use the widget
LanguageSelector()
```

---

## 💉 Dependency Injection

Uses `get_it` + `injectable`. Annotate and generate:

```dart
@lazySingleton
class AuthRepository { ... }

@injectable
class LoginCubit { ... }
```

Then run:
```bash
make gen
```

Access anywhere:
```dart
getIt<AuthRepository>()
```

---

## 🛣 Routing

Auto Route with typed routes and guards.

```dart
// Navigate
context.router.push(const HomeRoute());
context.router.replace(const LoginRoute());

// With params
context.router.push(ProfileRoute(userId: '123'));
```

**Adding a route:**
1. Annotate page with `@RoutePage()`
2. Add to `AppRouter.routes`
3. Run `make gen`

---

## 🌐 Network

Dio client with 4 interceptors wired by default:

| Interceptor | Purpose |
|---|---|
| `AuthInterceptor` | Auto-attaches Bearer token |
| `RefreshTokenInterceptor` | Auto-refreshes on 401 |
| `ErrorInterceptor` | Maps Dio errors → `ApiException` |
| `LoggingInterceptor` | Logs requests/responses |

**Typedefs for clean return types:**

```dart
// datasource
ApiResponse<UserModel>       // Future<Either<ApiException, T>>

// repository / usecase
AsyncAppResponse<UserEntity> // Future<Either<AppException, T>>
UnitResponse                 // Future<Either<AppException, Unit>>
SyncResponse<bool>           // Either<AppException, T>
```

---

## 🔐 Environment

Uses `envied` for compile-time, obfuscated env vars.

```
.env   → BASE_URL=http://localhost:8080/api
```

> ⚠️ Never commit `.env.*` files — they are gitignored.

Run `make gen` after editing env files.

---

## 🖼 Splash Screen

Config lives in `flutter_native_splash.yaml`.

```bash
make splash
```

Replace `assets/icons/splash_logo.png` with your own before running.

---

## 🔴 Launcher Icons

Config lives in `flutter_launcher_icons.yaml`.

```bash
make icons
```

Replace these files with your own before running:
```
assets/icons/app_icon.png
assets/icons/app_icon_foreground.png  # Android adaptive
```

---

## 🛠 Makefile Commands

```bash
make gen          # run build_runner (code generation)
make watch        # watch mode for code generation
make splash       # generate native splash
make icons        # generate launcher icons
make clean        # flutter clean + pub get
make format       # dart format
make lint         # flutter analyze
make test         # flutter test
make setup        # clean + splash + icons + gen (fresh clone)
```

---

## 🧩 Shared Widgets

All in `core/widgets/` — import via barrel:

```dart
import 'package:flutter_forge/core/widgets/widgets.dart';
```

| Widget | Usage |
|---|---|
| `CustomScaffold` | Base scaffold with appbar config |
| `CustomAppBar` | Typed appbar with back button |
| `CustomButton` | Filled button — `.text` `.icon` `.iconText` |
| `CustomOutlinedButton` | Outlined button — same factories |
| `CustomTextFormField` | Form field — `.email` `.password` `.phone` `.multiline` |
| `ThemeSelector` | Light / Dark / System pill selector |
| `LanguageSelector` | EN / NP pill selector |

**Context extensions — no boilerplate:**
```dart
context.showSuccessSnackbar('Saved!')
context.showErrorSnackbar('Failed')
context.showConfirmDialog(title: 'Delete?', message: '...')
context.showPromptDialog(title: 'Enter name')
context.showCustomBottomSheet(child: MyWidget())
context.showDraggableBottomSheet(builder: (c) => MyList(c))
```

---

## 📋 Starting a New Project From This Template

1. Clone the repo
2. Replace `flutter_forge` with your app name in:
   - `pubspec.yaml`
   - `AndroidManifest.xml`
   - `Info.plist`
   - Bundle ID in Xcode + `build.gradle`
3. Update `.env` with real URLs
4. Drop your assets into `assets/icons/`
5. Run `make setup`
6. Start adding features under `lib/features/`