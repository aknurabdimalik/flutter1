import 'models.dart';
class Library {
  final List<LibraryItem> items = [];

  void add(LibraryItem item) => items.add(item);

  Book? findByTitle(String title) {
    for (final item in items) {
      if (item is Book && item.title == title) {
        return item;
      }
    }
    return null;
  }

  String countryOf(String title) =>
      findByTitle(title)?.author.country ?? 'unknown';

  late final DateTime openedAt;

  void open() {
    openedAt = DateTime.now();
  }

  String? _cachedReport;

  String buildReport() {
    _cachedReport ??= _generateReport();
    return _cachedReport ?? '';
  }

  String _generateReport() =>
      'Report generated at ${DateTime.now()} for ${items.length} items';
  List<Book> get _books => items.whereType<Book>().toList();

  List<String> get allTitles => _books.map((b) => b.title).toList();

  List<Book> get booksAfter2010 => _books.where((b) => b.year > 2010).toList();
  double get averagePages => _books.isEmpty
      ? 0
      : _books.fold(0, (sum, b) => sum + b.pages) / _books.length;

  Map<String, int> get booksPerAuthor => {
    for (final b in _books)
      b.author.name: _books.where((x) => x.author.name == b.author.name).length
  };

  Set<String> get distinctAuthorNames => _books.map((b) => b.author.name).toSet();

  Set<Genre> get allGenres => _books.map((b) => b.genre).toSet();

  List<String> get displayList => [
    'CATALOGUE',
    for (final b in _books) '${b.title} (${b.year})',
    ...distinctAuthorNames,
    if (_books.any((b) => b.pages == 0)) '(incomplete data)',
  ];
}