import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/event_item.dart';
import '../widgets/empty_state.dart';
import '../widgets/event_collection.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({
    super.key,
    required this.items,
    required this.onOpen,
    required this.onFavourite,
  });

  final List<EventItem> items;
  final ValueChanged<EventItem> onOpen;
  final ValueChanged<String> onFavourite;

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  final _search = TextEditingController();
  String _query = '';
  EventCategory? _category; // null = "All"
  bool _showPast = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<EventItem> get _visible {
    final q = _query.trim().toLowerCase();
    final result = widget.items
        .where(
          (e) =>
      (_showPast || !e.isPast) &&
          (_category == null || e.category == _category) &&
          (q.isEmpty || e.title.toLowerCase().contains(q)),
    )
        .toList();
    result.sort(compareEvents);
    return result;
  }

  void _clearSearch() {
    _search.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: TextField(
            controller: _search,
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: 'Search events',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                tooltip: 'Clear',
                onPressed: _clearSearch,
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _category == null,
                onSelected: (_) => setState(() => _category = null),
              ),
              for (final c in EventCategory.values)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(c.label),
                    selected: _category == c,
                    onSelected: (_) => setState(() => _category = c),
                  ),
                ),
              const SizedBox(width: 16),
              FilterChip(
                label: const Text('Past'),
                selected: _showPast,
                onSelected: (value) => setState(() => _showPast = value),
              ),
            ],
          ),
        ),
        Expanded(
          child: EventCollection(
            items: _visible,
            onOpen: widget.onOpen,
            onFavourite: widget.onFavourite,
            empty: EmptyState(
              icon: Icons.search_off,
              message: 'No events found',
              actionLabel: _query.isEmpty ? null : 'Clear search',
              onAction: _query.isEmpty ? null : _clearSearch,
            ),
          ),
        ),
      ],
    );
  }
}
