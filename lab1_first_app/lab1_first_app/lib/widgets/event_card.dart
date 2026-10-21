import 'package:flutter/material.dart';

import '../models/event_item.dart';
import '../utils/format.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onFavourite,
  });

  final EventItem item;
  final VoidCallback onTap;
  final VoidCallback onFavourite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    final badge = item.isFull
        ? 'FULL'
        : (item.free <= 5 ? '${item.free} left' : null);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: scheme.surfaceContainerHighest,
                    child: Icon(
                      item.category.icon,
                      color: item.category.color(scheme),
                    ),
                  ),
                  if (badge != null)
                    Positioned(
                      right: -8,
                      bottom: -6,
                      child: _Badge(label: badge, full: item.isFull),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.isPast
                          ? '${formatDate(item.starts)} (past)'
                          : formatDate(item.starts),
                      style: text.bodySmall,
                    ),
                    Text(
                      item.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Favourite',
                onPressed: onFavourite,
                color: item.favourite ? scheme.error : null,
                icon: Icon(
                  item.favourite ? Icons.favorite : Icons.favorite_border,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.full});

  final String label;
  final bool full;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: full ? scheme.error : scheme.tertiary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: full ? scheme.onError : scheme.onTertiary,
        ),
      ),
    );
  }
}
