import 'category.dart';
import 'countdown.dart';

class EventItem {
  const EventItem({
    required this.id,
    required this.title,
    required this.category,
    required this.starts,
    required this.location,
    required this.capacity,
    this.online = false,
    this.description,
    this.favourite = false,
    List<String> attendees = const [],
  }) : _attendees = attendees;

  EventItem.empty()
      : this(
    id: '',
    title: '',
    category: EventCategory.tech,
    starts: DateTime.now().add(const Duration(days: 1)),
    location: '',
    capacity: 10,
  );

  static const Duration _eventLength = Duration(hours: 2);

  final String id;
  final String title;
  final EventCategory category;
  final DateTime starts;
  final String location;
  final int capacity;
  final bool online;
  final String? description;
  final bool favourite;
  final List<String> _attendees;

  List<String> get attendees => List.unmodifiable(_attendees);

  int get count => _attendees.length;
  int get free => capacity - count;
  bool get isFull => count >= capacity;
  bool get isPast => starts.isBefore(DateTime.now());
  bool contains(String name) => _attendees.contains(name);

  ({int taken, int free}) get places => (taken: count, free: free);

  Countdown countdownAt(DateTime now) {
    if (starts.isAfter(now)) return Upcoming(starts.difference(now));
    final since = now.difference(starts);
    return since < _eventLength ? Started(since) : const Ended();
  }

  EventItem copyWith({
    String? id,
    String? title,
    EventCategory? category,
    DateTime? starts,
    String? location,
    int? capacity,
    bool? online,
    String? description,
    bool clearDescription = false,
    bool? favourite,
    List<String>? attendees,
  }) {
    return EventItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      starts: starts ?? this.starts,
      location: location ?? this.location,
      capacity: capacity ?? this.capacity,
      online: online ?? this.online,
      description: clearDescription ? null : (description ?? this.description),
      favourite: favourite ?? this.favourite,
      attendees: List.of(attendees ?? _attendees),
    );
  }
}

int compareEvents(EventItem a, EventItem b) {
  if (a.isPast != b.isPast) return a.isPast ? 1 : -1;
  return a.starts.compareTo(b.starts);
}
