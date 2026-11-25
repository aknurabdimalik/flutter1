# practice13 — Where Things Go

Users app (JSONPlaceholder) organised feature-first:
`lib/core/` (api, storage) and `lib/features/<name>/`; `test/` mirrors `lib/`.

Dependencies point down: screens -> models -> repositories -> ApiClient / disk.
`tool/check_layers.sh` checks it with grep.

## Run

    flutter pub get
    flutter run
    flutter test

Demo mode (no network): in `lib/main.dart` swap the commented line with
`FakeUserRepository()`.

## Quality checklist

### flutter analyze

    PASTE the output here

### dart format .

    PASTE the output here

### flutter test

    PASTE the output here

### tool/check_layers.sh

    (nothing)