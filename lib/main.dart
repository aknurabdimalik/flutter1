// ignore_for_file: avoid_print
import 'week02/data.dart';
import 'week02/models.dart';
import 'week02/catalogue.dart';
import 'week02/shelf_state.dart';

void main() {
  final library = Library();
  for (final raw in rawBooks) {
    library.add(Book.fromJson(raw));
  }
  library.open();

  print('--- Level 4: queries ---');
  print('All titles: ${library.allTitles}');
  print('Books after 2010: ${library.booksAfter2010.map((b) => b.title).toList()}');
  print('Average pages: ${library.averagePages.toStringAsFixed(1)}');
  print('Books per author: ${library.booksPerAuthor}');
  print('Distinct authors: ${library.distinctAuthorNames}');
  print('All genres: ${library.allGenres.map((g) => g.label).toList()}');

  print('\n--- Display list ---');
  library.displayList.forEach(print);

  print('\n--- Level 5: records & sealed classes ---');
  final books = library.items.whereType<Book>().toList();
  final stats = statsOf(books);
  print('Stats -> count: ${stats.count}, avgPages: ${stats.avgPages.toStringAsFixed(1)}');

  final states = <ShelfState>[Empty(), Ready(books), Broken('shelf collapsed')];
  for (final s in states) {
    print(describe(s));
  }

  print('\nOpened at: ${library.openedAt}');
  print(library.buildReport());
}