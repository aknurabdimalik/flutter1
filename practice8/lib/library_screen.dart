import 'package:flutter/material.dart';

import 'add_book_screen.dart';
import 'detail_screen.dart';
import 'models/book.dart';
import 'widgets/book_tile.dart';

enum Filter { all, unread, read }

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final List<Book> _books = [...seed];
  Filter _filter = Filter.all;

  List<Book> get _visible => switch (_filter) {
    Filter.all => _books,
    Filter.unread => unread(_books),
    Filter.read => _books.where((b) => b.read).toList(),
  };

  Future<void> _open(Book book) async {
    final action = await Navigator.of(context).push<BookAction>(
      MaterialPageRoute(builder: (_) => DetailScreen(book: book)),
    );
    if (!mounted) return;
    switch (action) {
      case null:
        break;
      case BookAction.toggleRead:
        setState(() => book.read = !book.read);
      case BookAction.delete:
        setState(() => _books.remove(book));
    }
  }

  Future<void> _add() async {
    final book = await Navigator.of(context)
        .push<Book>(MaterialPageRoute(builder: (_) => const AddBookScreen()));
    if (!mounted) return;
    if (book == null) return;
    setState(() => _books.add(book));
  }

  Widget _stat(String number, String label) {
    final text = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        children: [
          Text(number, style: text.headlineSmall),
          Text(label, style: text.bodySmall),
        ],
      ),
    );
  }

  Widget _header() => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _stat('${_books.length}', 'Books'),
          _stat('${totalPages(_books)}', 'Pages'),
          _stat('${unread(_books).length}', 'Unread'),
        ],
      ),
    ),
  );

  Widget _chip(Filter f, String label) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ChoiceChip(
      label: Text(label),
      selected: _filter == f,
      onSelected: (_) => setState(() => _filter = f),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Reading list (${_visible.length})')),
    floatingActionButton: FloatingActionButton(
      onPressed: _add,
      child: const Icon(Icons.add),
    ),
    body: Column(
      children: [
        _header(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _chip(Filter.all, 'All'),
              _chip(Filter.unread, 'Unread'),
              _chip(Filter.read, 'Read'),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _visible.length,
            itemBuilder: (context, i) {
              final book = _visible[i];
              return BookTile(
                book: book,
                onTap: () => _open(book),
                onToggle: () => setState(() => book.read = !book.read),
              );
            },
          ),
        ),
      ],
    ),
  );
}
