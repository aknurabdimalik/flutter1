import 'models.dart';
sealed class ShelfState {}

class Empty extends ShelfState {}

class Ready extends ShelfState {
  final List<Book> books;
  Ready(this.books);
}

class Broken extends ShelfState {
  final String message;
  Broken(this.message);
}

String describe(ShelfState state) => switch (state) {
  Empty() => 'Shelf is empty',
  Ready(books: final b) when b.isEmpty => 'Shelf is ready but has no books',
  Ready(books: final b) => 'Shelf is ready with ${b.length} book(s)',
  Broken(message: final m) => 'Shelf is broken: $m',
};

({int count, double avgPages}) statsOf(List<Book> books) {
  if (books.isEmpty) return (count: 0, avgPages: 0.0);
  final total = books.fold(0, (sum, b) => sum + b.pages);
  return (count: books.length, avgPages: total / books.length);
}