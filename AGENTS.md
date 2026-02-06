# AGENTS.md

## Project

Build a **Flutter Android app** using **Material UI (Material 3)** with clean architecture, strong typing, and reliable tests. This repo is Flutter-first; Android native code is only for platform integration.

## Tech Stack

* **Flutter (Dart)** targeting **Android**
* **Material 3** (`ThemeData(useMaterial3: true)`)
* State management: **Riverpod** (preferred) or **Bloc** (if already present)
* Networking: `dio` (preferred) or `http`
* Persistence: `shared_preferences` for simple settings; `sqflite` or `drift` for structured data
* Routing: `go_router`
* Linting: `flutter_lints` + custom rules (see `analysis_options.yaml`)

## How the agent should work

When you (the agent) receive a task:

1. **Clarify by reading code**, not by asking questions, unless the requirement is ambiguous.
2. Propose a **small plan** (1–5 steps) in the PR description or as comments.
3. Make **incremental changes** with frequent `flutter test`.
4. Prefer **simple, maintainable** solutions over clever ones.
5. Avoid introducing new dependencies unless clearly beneficial.

## Repository Commands

Use these commands to develop and validate changes:

### Setup

* `flutter doctor`
* `flutter pub get`

### Run (Android)

* `flutter run -d android`

### Format & Analyze

* `dart format .`
* `flutter analyze`

### Tests

* `flutter test`
* `flutter test --coverage`

### Build (Android)

* `flutter build apk`
* `flutter build appbundle`

## Architecture Guidelines

Prefer **feature-first** structure:

```
lib/
  app/
    app.dart
    router.dart
    theme.dart
  core/
    error/
    network/
    utils/
    widgets/
  features/
    <feature_name>/
      data/
        datasources/
        models/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        pages/
        widgets/
        state/
```

### Rules

* `presentation` depends on `domain`, not on `data` directly.
* `data` implements repositories declared in `domain`.
* Keep UI logic out of widgets; use controllers/state notifiers.
* Use dependency injection via Riverpod providers (or existing DI pattern).

## Material 3 UI Standards

* Use `ThemeData(useMaterial3: true)` and define:

  * `colorScheme` (seed-based if no brand palette is provided)
  * typography via `TextTheme`
  * consistent shapes (`RoundedRectangleBorder`, 12–16 radius)
* Use Material components first:

  * `Scaffold`, `AppBar`, `NavigationBar`, `NavigationDrawer`
  * `FilledButton`, `OutlinedButton`, `TextButton`
  * `Card`, `ListTile`, `Chip`, `SnackBar`
* Ensure accessibility:

  * Respect `textScaleFactor`
  * Tap targets ≥ 48dp
  * Sufficient contrast (don’t hardcode low-contrast colors)

## Coding Standards (Dart/Flutter)

* Keep files focused; prefer < 300 lines per file.
* Prefer immutable models (`const`, `final`) and `copyWith`.
* Avoid `dynamic`. Use sealed classes / unions where appropriate.
* Error handling:

  * Don’t swallow exceptions.
  * Convert low-level exceptions to domain failures where possible.
* Logging:

  * No verbose logs in release; gate debug logs behind asserts or a logger level.

## State Management (Riverpod preferred)

* Use `ConsumerWidget` / `ConsumerStatefulWidget` only when needed.
* Prefer `AsyncValue` patterns for loading/error states.
* Keep providers scoped by feature.
* Avoid circular dependencies in providers.

## Routing

* Use `go_router` with typed parameters where possible.
* Deep links should map cleanly to pages.
* Navigation should not be performed inside build methods; trigger via callbacks/effects.

## Testing Strategy

### Unit tests

* Domain use cases
* Repository logic (mock data sources)
* Pure Dart utilities

### Widget tests

* Key screens and critical UI states (loading, empty, error)
* Navigation flows (when feasible)

### Golden tests (optional)

* Only for stable UI components; keep them minimal.

Testing rules:

* Tests must be deterministic (no real network, no real time).
* Use mocks/fakes; prefer `fake_async` for timers.

## Android-Specific Notes

* Keep platform code minimal and documented.
* For permissions, use a Flutter plugin (e.g., `permission_handler`) and document rationale.
* For notifications, prefer a plugin and include setup steps in `README`.

## Documentation Updates

When you add or change:

* Features → update `README` and/or feature docs
* Environment variables → document in `README` + sample `.env.example`
* Routes → update a route list in docs or `router.dart` comments
* Design decisions → add a short note in `/docs/decisions/`

## Pull Request Checklist (agent must ensure)

* [ ] `dart format .` clean
* [ ] `flutter analyze` passes
* [ ] `flutter test` passes
* [ ] No new lints introduced
* [ ] UI follows Material 3 + responsive layout
* [ ] Handles loading/error/empty states
* [ ] Updates docs if behavior changed

## What NOT to do

* Don’t add heavy dependencies for trivial features.
* Don’t hardcode strings; use localization if present (or create a simple localization setup if requested).
* Don’t mix data fetching directly in widgets.
* Don’t commit secrets, tokens, keystore files, or private keys.

## Default App Conventions

* Use `const` constructors wherever possible.
* Use `Theme.of(context)` and `ColorScheme` instead of raw colors.
* Use spacing constants (e.g., 8/12/16/24) consistently.
* Provide meaningful `Key`s for critical widgets to enable testing.
