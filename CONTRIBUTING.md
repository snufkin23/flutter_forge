# Contributing to flutter_forge

---

## Branches

```
master        ← production, protected
develop       ← active development
feature/xxx   ← new features
fix/xxx       ← bug fixes
chore/xxx     ← maintenance, deps, config
```

**Always branch off `develop`, never directly off `master`.**

```bash
# Start a new feature
git checkout develop
git pull origin develop
git checkout -b feature/auth-screen

# Start a bug fix
git checkout -b fix/login-crash
```

---

## Commit Messages

Follow **Conventional Commits** — this powers the auto-generated changelog.

```
type: short description
```

| Type | When to use |
|---|---|
| `feat` | new feature |
| `fix` | bug fix |
| `refactor` | code change, no new feature or fix |
| `chore` | deps, config, tooling |
| `ci` | github actions, workflows |
| `docs` | readme, comments, documentation |
| `test` | adding or updating tests |

**Examples:**
```bash
git commit -m "feat: add biometric login"
git commit -m "fix: crash on Android 12 back gesture"
git commit -m "refactor: simplify auth cubit state"
git commit -m "chore: update dio to 5.4.3"
git commit -m "docs: add setup steps to README"
```

**Rules:**
- lowercase only
- no period at the end
- keep it under 72 characters
- be specific — `fix: crash` is bad, `fix: null check on login response` is good

---

## Pull Requests

```
feature/xxx  →  develop   (normal flow)
develop      →  master    (release only)
```

Before opening a PR:
```bash
# Make sure lint and tests pass locally
flutter analyze
flutter test
dart format lib/
```

PR title should match commit format:
```
feat: add biometric login
fix: null check on login response
```

---

## Code Generation

After changing annotated files run:
```bash
make gen
# or
dart run build_runner build --delete-conflicting-outputs
```

Files ending in `.g.dart`, `.freezed.dart`, `.gr.dart` are generated — never edit them manually.

---

## Environment

Never commit `.env` — it is gitignored.

```bash
# Copy and fill in your values
cp .env.example .env
```