# Practice 12: Survive a Restart

## Level 1: Package verdicts
(Checked on pub.dev. Replace the ⟦…⟧ marks with what the page shows today.)

1. **shared_preferences**: verified publisher flutter.dev (the Flutter team), last release ⟦month year⟧, all six platforms, ⟦160⟧ pub points, BSD-3-Clause, depends only on its own platform-implementation packages, issues are open but commits are frequent, so it is safe for small settings.
2. **flutter_secure_storage**: verified publisher steenbakker.dev, last release ⟦month year⟧, all six platforms, ⟦160⟧ pub points, BSD-3-Clause, depends on its own per-platform packages, ⟦N⟧ open issues but recent commits, so it is the right choice for tokens (Keychain / Keystore).
3. **path_provider**: verified publisher flutter.dev, last release ⟦month year⟧, Android, iOS, Linux, macOS and Windows (not web), ⟦160⟧ pub points, BSD-3-Clause, depends only on its platform-implementation packages, safe for finding the Documents folder.
4. **image_picker**: verified publisher flutter.dev, last release ⟦month year⟧, all six platforms, ⟦160⟧ pub points, BSD-3-Clause, depends on platform-implementation packages, safe for gallery and camera.
5. **permission_handler**: verified publisher baseflow.com, last release ⟦month year⟧, platforms ⟦read the badges on the page: Android, iOS, Windows, web⟧, ⟦160⟧ pub points, MIT, depends on its own per-platform packages, ⟦N⟧ open issues, active maintainers, so it is acceptable but needs setup on both OSes.
6. **url_launcher**: verified publisher flutter.dev, last release ⟦month year⟧, all six platforms, ⟦160⟧ pub points, BSD-3-Clause, depends only on platform-implementation packages, safe for opening mailto:, tel: and https: links.

### The caret and pubspec.lock
- `flutter pub add` wrote carets, for example `http: ^1.2.0`. pub.lock resolved http to **⟦version from pubspec.lock⟧**.
- `^1.2.0` accepts every version from 1.2.0 up to but not including 2.0.0 (1.2.0, 1.2.2, 1.9.0 are accepted). It refuses 1.1.x (older than the minimum) and 2.0.0 or newer (a major version may break the API).
- `pubspec.lock` is committed for an app because it pins the exact versions that were tested, so every machine and every build gets the same dependencies. For a library it is not committed, because the library must work with a range of versions.
- `flutter pub outdated`: ⟦package name⟧ could be newer, but it was not upgraded because ⟦reason shown in the Resolvable column: another package limits it, or the new version is a major release that needs code changes⟧.
- Experiment: with `http: 1.2.0` (no caret) the lock pins exactly 1.2.0 and `pub outdated` shows newer versions as unavailable. The caret was put back.

## Level 2: Settings
- Dark mode and the city filter are in shared_preferences and are read in `main()` before `runApp`, so there is no flash of the wrong theme.
- `notifyListeners()` is called before the disk write, so the screen never waits for the disk.
- Every read is nullable and has a default with `??`.

## Level 3: Token
- `prefs.setString('token', ...)` would put the token in a plain file in the app's folder (an XML file or a datastore file on Android, a plist on iOS), with no encryption.
- It could be read from a backup, by someone with root or a jailbreak, or by someone with a cable (adb on a debug build).
- flutter_secure_storage uses the Keychain on iOS and the Keystore on Android, so the token is encrypted with a key the OS protects.
- Platform surprise on iOS: Keychain items can survive an uninstall, so a reinstalled app may find an old token.
- Platform surprise on Android: if the user removes or changes the lock screen, the Keystore keys can be invalidated and the stored data becomes unreadable, so the app must handle a failed read as "signed out".
- The token is never printed and is never in shared_preferences. The Authorization header is added by ApiClient only.

## Level 4: Offline list
- The cache file is `users.json` in `getApplicationDocumentsDirectory()`. `getTemporaryDirectory()` is temporary: the OS may clear it, and "Clear cache" really deleted the list in the experiment.
- `getAll()` saves on success, returns the saved list on `NoConnectionException`, and rethrows when there is nothing saved. The banner shows only when `fromCache` is true.

## Level 5: Photo and permissions
- Android sequence: Don't allow, Don't allow, and on the third tap there is no system dialog (the status is permanentlyDenied), so my own dialog with "Open settings" appears.
- iOS sequence: the system asks only once. One "Don't Allow" is already permanentlyDenied.
- The fourth Photos state is called **limited** (the user shared only some of the photos).
- `launchUrl` without a scheme (`kbtu.edu.kz`) returns false and nothing opens. With `https://` the browser opens. The app checks the returned bool and shows "No app can open this".
- `<queries>` for https, mailto and tel are declared for Android 11+.