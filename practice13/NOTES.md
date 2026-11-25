# NOTES — Practice 13: Where Things Go

## Level 2: why the model must never say `new`

In the old version of `UsersModel` (it created its own `HttpUserRepository`
inside), the first line I could not write was the **arrange** step: there was
no way to give the model a repository that fails, because `UsersModel()` built
the real one itself, so the test "NoConnection sets error" would need a real
network cut. With `UsersModel(this._repo)` the arrange step is one line:
`UsersModel(FakeUserRepository(fail: true))`.

## Level 4: a widget vs. a `_buildHeader()` method

A widget class can be `const` (Flutter skips rebuilding it when nothing changed),
has its own rebuild scope, shows up by name in DevTools / Track Widget Rebuilds,
and can be tested on its own. A method on the parent cannot do any of these —
it is rebuilt together with the parent every time.

## Level 5: the planted bug (`lat` is a number, not a String)

Planted JSON for user 1: `"lat": -37.3159` instead of `"lat": "-37.3159"`.

### Full trace

    PASTE your full trace here (indent every line by 4 spaces)

### Annotation

1. **The message:** `type 'double' is not a subtype of type 'String' in type
   cast` — the code expected a String and got a double.
2. **My first frame:** `#0 Geo.fromJson (package:practice13/features/users/user.dart:LL:CC)`
   — line and column of the cast `json['lat'] as String`
   (PASTE the line:column from your trace; in my file it is line 5).
3. **The path:** `Geo.fromJson` → `Address.fromJson` → `User.fromJson` →
   `HttpUserRepository.getAll` → `<asynchronous suspension>` → `UsersModel.load`.
   The `<asynchronous suspension>` marks an `await` between two async calls.
4. **The data that went in:** field `address.geo.lat` of the user with `id: 1`
   (Leanne Graham).

### Why #0 was the right place to throw and the wrong place to fix

`Geo.fromJson` is the first code that sees the wrong type, so failing loudly
there is honest. But it is the wrong place to fix: it knows nothing about the
server or the screen, and making it "tolerant" would hide the fact that the
server broke the contract. The repository is the right place — it knows it is
talking to the server, so it maps the `TypeError` to `BadResponseException`,
and the screen shows a normal error view instead of crashing.

### Fix

`HttpUserRepository._parse` catches `TypeError` and throws
`BadResponseException('users: unexpected field type (...)')`. The test
`lat as a number -> BadResponseException` was red first and is green now.