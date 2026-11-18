# Practice 11: A Real Server - NOTES

API used: https://jsonplaceholder.typicode.com

## Level 1: Postman results

| Request | Status | What came back |
|---|---|---|
| GET /users | 200 | a JSON **list** of 10 users |
| GET /users/1 | 200 | one JSON **object** (Content-Type: application/json; charset=utf-8) |
| GET /users/999 | 404 | empty object `{}` |
| POST /users (JSON body, Content-Type: application/json) | 201 Created | the server returns what I sent and adds `"id": 11` |
| GET /users?id=3 | 200 | a **list with one user**, not an object |

Notes:
- `GET /users/999` has an empty body `{}`, so the status must be checked before the body is decoded (otherwise `fromJson` fails on `id` and the real cause is hidden).
- A query like `?id=3` is passed with `Uri.https(host, '/users', {'id': '3'})`.

## User (top-level fields)

| field | JSON type | Dart type | nullable? |
|---|---|---|---|
| id | number | int | no |
| name | string | String | no |
| username | string | String | no |
| email | string | String | no |
| phone | string | String | no (raw string kept, getter `phoneDigits` keeps only digits and +) |
| website | string | String? | yes (the only field treated as optional) |
| address | object | Address | no |
| company | object | Company (record `({String name, String catchPhrase})`) | no |

## Address (nested once)

| field | JSON type | Dart type | nullable? |
|---|---|---|---|
| street | string | String | no |
| suite | string | String | no |
| city | string | String | no |
| zipcode | string | String | no |
| geo | object | Geo | no |

## Geo (nested twice: address.geo)

| field | JSON type | Dart type | nullable? |
|---|---|---|---|
| lat | **string** ("-37.3159") | double (`double.parse`) | no |
| lng | **string** ("81.1496") | double (`double.parse`) | no |

## Company

| field | JSON type | Dart type | nullable? |
|---|---|---|---|
| name | string | String | no |
| catchPhrase | string | String | no |
| bs | string | not used in the app | - |

## Status -> exception mapping (Level 3)

| Situation | Exception |
|---|---|
| SocketException, TimeoutException (10 s) | NoConnectionException |
| 401 | UnauthorizedException |
| 404 | NotFoundException |
| 5xx | ServerException(status) |
| body is not valid JSON, or a cast fails in fromJson | BadResponseException |

## Level 5: two kinds of "no network"

| Test | Time until the Offline view appeared |
|---|--------------------------------------|
| Airplane mode | 2 seconds                            |
| Wi-Fi without internet (hotspot, internet off) | 10 seconds                           |

- Airplane mode is fast because the OS knows there is no route, so `SocketException` is immediate.
- A Wi-Fi that leads nowhere: packets leave and never return, so only the 10-second `.timeout` ends the wait.
- Both tests show the same Offline screen with a Retry button.

## DevTools -> Network

- `screenshot_timeout.png`: the `/users` row with no status and about 10 000 ms.
- `screenshot_200.png`: a `GET /users` row with status 200 and the response body opened.
- POST from the form: one request, status 201 (Save is disabled while the request is in flight).

## Checks

- `flutter run` shows 10 users from jsonplaceholder.typicode.com
- `flutter analyze`: No issues found!
- `dart format .` has been run
- `grep -rn "package:http" lib/` lists only `api_client.dart` and `user_repository.dart`