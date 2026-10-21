import 'package:flutter/material.dart';

import '../models/event_item.dart';
import '../widgets/empty_state.dart';
import '../widgets/event_collection.dart';

class FavouritesTab extends StatelessWidget {
  const FavouritesTab({
    super.key,
    required this.items,
    required this.onOpen,
    required this.onFavourite,
  });

  final List<EventItem> items;
  final ValueChanged<EventItem> onOpen;
  final ValueChanged<String> onFavourite;

  @override
  Widget build(BuildContext context) {
    final favourites = items.where((e) => e.favourite).toList()
      ..sort(compareEvents);
    return EventCollection(
      items: favourites,
      onOpen: onOpen,
      onFavourite: onFavourite,
      empty: const EmptyState(
        icon: Icons.favorite_border,
        message: 'No favourites yet. Tap the heart on an event.',
      ),
    );
  }
}
