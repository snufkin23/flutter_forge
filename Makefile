# —————————————————————————————————————————
#  flutter_forge — Makefile
# —————————————————————————————————————————

# Code generation + localization
gen:
	dart run build_runner build --delete-conflicting-outputs
	dart run intl_utils:generate

watch:
	dart run build_runner watch --delete-conflicting-outputs

# Splash & Icons
splash:
	dart run flutter_native_splash:create

icons:
	dart run flutter_launcher_icons

# Flutter project
clean:
	flutter clean && flutter pub get

format:
	dart format lib --line-length 80

lint:
	flutter analyze

test:
	flutter test

# Run app
run:
	flutter run

# Build APK & iOS
build-apk:
	flutter build apk

build-ios:
	flutter build ios

# Full setup from scratch (after fresh clone)
setup: clean splash icons gen

# —————————————————————————————————————————
.PHONY: gen watch splash icons clean format lint test run build-apk build-ios setup