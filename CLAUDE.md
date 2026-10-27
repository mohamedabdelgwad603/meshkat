# Claude's Project Rules

These rules apply to every task in this project. Follow them without exception.

---

## 1. Feature Architecture (Clean Architecture)

Every feature **must** reside in `lib/features/[feature]/` with this exact structure:

```
lib/features/[feature]/
  data/
    datasources/       ← Remote/Local fetching via ApiConsumer
    models/            ← fromJson + factory Model.dummy() for Skeletonizer
    repo_imp/          ← Concrete implementation of domain repos
    requests_params/   ← Dedicated classes for API bodies/queries (with toJson)
  domain/
    repo/              ← Abstract interfaces only
  presentation/
    cubit/
    screens/
    widgets/
```

> ❌ Never put business logic in the presentation layer.  
> ❌ Never skip the domain layer — data must implement a domain interface.

---

## 2. Data Layer Workflow

Follow these steps in order when adding any new API-backed feature:

1. **Endpoint** — add the new endpoint constant to `lib/core/api/end_points.dart`
2. **Params** — create a params class in `data/requests_params/` with a `toJson()` method
3. **Model** — create the model in `data/models/` with `fromJson` factory and a `Model.dummy()` factory for Skeletonizer
4. **Data Source** — implement fetching in `data/datasources/` using `apiConsumer.get/post/put/delete`
5. **Repository** — implement the domain interface in `data/repo_imp/`, return `Future<Either<Failure, T>>` (dartz), and wrap calls with `safeExecute(request: () => ...)`

```dart
// ✅ correct repository pattern
Future<Either<Failure, MyModel>> fetchSomething(MyParams params) =>
    safeExecute(request: () => _dataSource.fetchSomething(params));
```

---

## 3. Cubit Standards

- States follow the pattern: `Initial`, `Loading`, `Success(data)`, `Error(message)`
- For paginated lists: add a `LoadingMore` state and track `currentPage` in the cubit
- Always expose a static accessor: `static FeatureCubit get(context) => BlocProvider.of(context);`
- Always guard emits with `if (isClosed) return;` before every `emit` call

```dart
// ✅ correct
Future<void> loadData() async {
  emit(MyLoading());
  final result = await _repo.fetchSomething();
  if (isClosed) return;
  result.fold(
    (failure) => emit(MyError(failure.message)),
    (data)    => emit(MySuccess(data)),
  );
}
```

---

## 4. Dependency Injection

Every feature **must** have its own DI registration file.

### Step 1 — Create a feature DI file
`lib/core/services/dependancy_injection_methods/[feature]_di.dart`
```dart
void setupFeatureDi() {
  getIt.registerLazySingleton<FeatureDataSource>(() => FeatureDataSourceImp(getIt()));
  getIt.registerLazySingleton<FeatureRepo>(() => FeatureRepoImp(getIt()));
  getIt.registerFactory(() => FeatureCubit(getIt()));
}
```

### Step 2 — Call it in `init_di.dart`
```dart
void initDi() {
  // ...existing registrations...
  setupFeatureDi();
}
```

> ❌ Never register dependencies directly in `init_di.dart` — keep each feature isolated in its own DI file.

---

## 5. Text & Localization

**Every visible string must go through this 3-step flow:**

### Step 1 — Register the key in `TextManager`
`lib/core/utills/text_manager.dart`
```dart
static const String myKey = 'myKey';
```

### Step 2 — Add translations in both locale files
`assets/translations/en.json`
```json
{ "myKey": "My English Text" }
```
`assets/translations/ar.json`
```json
{ "myKey": "النص بالعربي" }
```

### Step 3 — Display with `CustomText` (no `.tr()` needed)
`lib/core/utills/widgets/custom_text.dart` handles `.tr()` internally.
```dart
CustomText(
  text: TextManager.myKey,   // ✅ pass the key, NOT key.tr()
  style: getSemiBoldStyle(context: context),
)
```

> ❌ Never hardcode a string directly in the UI.  
> ❌ Never call `.tr()` when using `CustomText`.  
> ❌ Never use the raw `Text()` widget for user-visible strings — use `CustomText`.

---

## 6. Text Styles

Always use the style helpers from `lib/config/themes/text_styles.dart`.  
Never write a `TextStyle(...)` manually.

| Helper | Weight | When to use |
|---|---|---|
| `getRegularStyle(context: context)` | 400 | body copy, descriptions |
| `getMediumStyle(context: context)` | 500 | labels, secondary info |
| `getSemiBoldStyle(context: context)` | 600 | subtitles, card titles |
| `getBoldStyle(context: context)` | 700 | screen titles, headlines |

Optional named params: `fontSize`, `color`, `height`, `decoration`.

```dart
// ✅ correct
style: getBoldStyle(context: context, fontSize: 20, color: Colors.white)

// ❌ wrong
style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
```

---

## 7. Colors

Always access colors through `ColorsManager`.  
Never hardcode a `Color(0xFF...)` value — pick the closest semantic name from `ColorManager`.

```dart
// ✅ correct
color: ColorsManager.primary
color: ColorsManager.grey
color: ColorsManager.surface

// ❌ wrong
color: Color(0xFF6200EE)
color: Colors.grey
```

Available names (see `lib/config/themes/color_manager.dart`):  
`primary`, `primaryLight`, `primaryMiddle`, `secondry`, `red`, `redLight`,  
`grey`, `greyLight`, `greyBackground`, `black`, `white`, `surface`, `onSurface`,  
`transparent`, `blue`, `green`, `yellow`, `purple`, `lightBlue`, `darkLight`.

---

## 8. Dimensions & Spacing

- All sizes → ScreenUtil suffixes: `.w` `.h` `.sp` `.r`
- Gaps → `verticalSpace(n)` / `horizontalSpace(n)` from `lib/core/utills/functions/spacing.dart`

```dart
// ✅
SizedBox(width: 16.w)
verticalSpace(24.h)
BorderRadius.circular(12.r)

// ❌
SizedBox(width: 16)
SizedBox(height: 24)
```

---

## 9. Screen Modularization

Every screen **must** be split into focused sub-widgets. Never build a screen as a single monolithic `build()` method.

- Sub-widgets live in `lib/features/[feature]/presentation/widgets/`
- Each sub-widget goes in its own file named after what it represents (e.g. `login_form.dart`, `auth_layout.dart`)
- The screen file itself should only wire the BlocProvider + layout together — no inline widget trees

```
presentation/
  screens/
    my_screen.dart        ← BlocProvider + top-level layout only
  widgets/
    my_screen_header.dart
    my_screen_body.dart
    my_screen_footer.dart
```

---

## 10. Code Comments

Every method and widget **must** have a single-line English comment above it explaining what it does.

```dart
// ✅ correct

// Fetches the user's current GPS position and emits a loaded state with nearby drivers.
Future<void> init() async { ... }

// Displays the floating app bar with the current location pill and user avatar.
class HomeAppBar extends StatelessWidget { ... }

// Builds a set of map markers from the loaded state using cached icon descriptors.
Set<Marker> _buildMarkersFromState(HomeLoaded state) { ... }
```

Rules:
- One line only — no multi-line block comments.
- Write **what** it does, not how.
- Use plain English — no jargon, no references to ticket numbers or callers.
- Private helpers (`_foo`) need comments just as much as public ones.

> ❌ No comment at all on a method or widget.  
> ❌ Multi-line `/** ... */` or `/* ... */` comment blocks.  
> ❌ Comments in any language other than English.

---

## 11. Routing

Every new screen **must** be registered in `lib/config/routes/route_manager.dart` before it can be used.

### Step 1 — Add the route name in `PageName`
`lib/config/routes/page_name.dart`
```dart
static const String myScreen = '/myScreen';
```

### Step 2 — Add the case in `RouteManager.onGenerateRoute`
`lib/config/routes/route_manager.dart`
```dart
case PageName.myScreen:
  return _getPageTransition(const MyScreen());
```

> ❌ Never navigate with a raw string path — always use `PageName.myScreen`.  
> ❌ Never push a screen that has no registered route.

---

## 12. Navigation

Always navigate through the `BuildContext` extension methods defined in  
`lib/core/utills/extentions/build_context_extention.dart`.  
**Never** call `Navigator.of(context)` directly.

| Action | Use |
|---|---|
| Push a new screen | `context.pushNamed(PageName.x, arguments: args)` |
| Replace current screen | `context.pushReplacementNamed(PageName.x, arguments: args)` |
| Clear stack and push | `context.pushNamedAndRemoveUntil(PageName.x, predicate: (r) => false)` |
| Pop current screen | `context.pop()` |

```dart
// ✅ correct
context.pushNamed(PageName.searchDriver, arguments: args);
context.pushNamedAndRemoveUntil(PageName.home, predicate: (_) => false);

// ❌ wrong
Navigator.of(context).pushNamed(PageName.searchDriver, arguments: args);
Navigator.of(context, rootNavigator: true).pushNamed(...);
```

> ❌ Never use `Navigator.of(context)` — use the context extension instead.
