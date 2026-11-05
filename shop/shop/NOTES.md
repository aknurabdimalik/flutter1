# Notes - Practice 9: Put It High, Subscribe Low

## Level 1: what lifting state up costs

To show the total price in the badge I had to pass a second parameter, `total`,
from the owner all the way down.

- Constructors touched: 2 (`BooksScreen`, `CartBadge`)
- Call sites touched: 2 (in `Shell` and in `BooksScreen`)
- Files touched: 3 (`main.dart`, `books_screen.dart`, `cart_badge.dart`)

`BooksScreen` does not use `total` itself, it only passes it through.

Rebuild count: one tap on "Add" printed 7 lines in the console
(1 x `BooksScreen build` + 6 x `row ...`).
`setState` in `Shell` marks everything under it dirty, so the whole screen
and every row were rebuilt.

## Level 3: two provider errors

**The loud one** - `context.watch<Cart>().add(book)` inside `onPressed`.
The app throws:

> Tried to listen to a value exposed with provider, from outside of the widget tree.
This is likely caused by an event handler (like a button's onPressed) that called
Provider.of without passing `listen: false`.
To fix, write: Provider.of<Cart>(context, listen: false);

**The silent one** — `context.read<Cart>().count` inside `build` of the badge.
There is no error: the code compiles and runs, but the badge is frozen at 0
forever, because nobody said "I depend on the cart".

Rule: `watch` is a verb of `build`, `read` is a verb of `onPressed`.

## Level 4: rebuild counts for the badge

Pressed "+" three times on a cart row:

- with `context.watch<Cart>()` in the badge: 3 rebuilds (`badge build` printed 3 times)
- with `context.select<Cart, int>((c) => c.count)`: 0 rebuilds
  (1 rebuild when a book is removed, because the count changed)

The model and the taps are the same, only one line in one widget is different.

## Where does it live?

- **The cart** - provided. Two screens need it and it must outlive both of them,
  so it lives in `ChangeNotifierProvider` above `MaterialApp`.
- **The search text** in the Books AppBar - ephemeral. Only the Books screen
  uses it, so a field in its `State` is enough.
- **Whether the Cart screen's total is expanded or collapsed** - ephemeral.
  Only one widget on one screen cares about it.
- **The theme mode** (if there were a dark-mode switch) - provided (lifted above
  `MaterialApp`). `MaterialApp` itself reads it and every screen is affected.