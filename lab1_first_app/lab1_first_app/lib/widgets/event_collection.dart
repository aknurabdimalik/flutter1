import 'package:flutter/material.dart';

import '../models/event_item.dart';
import 'event_card.dart';

class EventCollection extends StatelessWidget {
  const EventCollection({
    super.key,
    required this.items,
    required this.empty,
    required this.onOpen,
    required this.onFavourite,
  });

  final List<EventItem> items;
  final Widget empty;
  final ValueChanged<EventItem> onOpen;
  final ValueChanged<String> onFavourite;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return empty;

    Widget cardAt(int index) {
      final item = items[index];
      return EventCard(
        item: item,
        onTap: () => onOpen(item),
        onFavourite: () => onFavourite(item.id),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 360,
              mainAxisExtent: 136,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) => cardAt(index),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) => cardAt(index),
        );
      },
    );
  }
}
