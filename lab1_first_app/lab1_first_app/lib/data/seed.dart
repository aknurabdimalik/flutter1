import '../models/category.dart';
import '../models/event_item.dart';

const _people = [
  'Aruzhan', 'Dana', 'Timur', 'Madina', 'Alikhan', 'Aigerim', 'Nursultan',
  'Zhanna', 'Erlan', 'Saltanat', 'Bauyrzhan', 'Karina', 'Daniyar', 'Aliya',
  'Yerzhan', 'Samal', 'Arman', 'Gulnara', 'Dias', 'Laura', 'Ruslan', 'Assel',
  'Miras', 'Togzhan', 'Kanat',
];

List<String> _names(int n) => _people.take(n).toList();

/// A moment [days] from today (negative = in the past) at [hour]:00.
DateTime _at(int days, int hour) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day + days, hour);
}

/// Twelve seed events, dates relative to today.
List<EventItem> seedEvents() => [
  EventItem(
    id: 'e1',
    title: 'Flutter Hackathon',
    category: EventCategory.tech,
    starts: _at(3, 10),
    location: 'Room 301',
    capacity: 40,
    description: 'Build a small app in one day. Laptops required.',
    attendees: _names(12),
  ),
  // mandatory: 60-character title
  EventItem(
    id: 'e2',
    title: 'Annual Interuniversity Mobile Development Championships 2026',
    category: EventCategory.tech,
    starts: _at(12, 9),
    location: 'Main Conference Hall',
    capacity: 200,
    description: 'Teams from all universities compete.',
    attendees: _names(8),
  ),
  EventItem(
    id: 'e3',
    title: 'Morning Run in the Park',
    category: EventCategory.sport,
    starts: _at(1, 7),
    location: 'Central Park',
    capacity: 15,
    description: 'Easy 5 km, all levels.',
    attendees: _names(12), // 3 left -> badge "3 left"
  ),
  // mandatory: an item at its limit
  EventItem(
    id: 'e4',
    title: 'Jazz Night',
    category: EventCategory.music,
    starts: _at(5, 19),
    location: 'Main Hall',
    capacity: 5,
    description: 'Live quartet.',
    attendees: _names(5),
  ),
  // mandatory: mode on (online) and no optional text
  EventItem(
    id: 'e5',
    title: 'Online Career Talk',
    category: EventCategory.career,
    starts: _at(2, 16),
    location: 'https://meet.example.com/career',
    capacity: 100,
    online: true,
    attendees: _names(30),
  ),
  // mandatory: a past item
  EventItem(
    id: 'e6',
    title: 'Photography Workshop',
    category: EventCategory.art,
    starts: _at(-4, 14),
    location: 'Studio 2',
    capacity: 20,
    description: 'Light and composition basics.',
    attendees: _names(9),
  ),
  EventItem(
    id: 'e7',
    title: 'Chess Tournament',
    category: EventCategory.sport,
    starts: _at(7, 12),
    location: 'Library, 2nd floor',
    capacity: 16,
    description: 'Swiss system, 5 rounds.',
    attendees: _names(8),
  ),
  EventItem(
    id: 'e8',
    title: 'Startup Pitch Day',
    category: EventCategory.career,
    starts: _at(10, 11),
    location: 'Business Hub',
    capacity: 30,
    attendees: _names(6),
  ),
  EventItem(
    id: 'e9',
    title: 'Open Mic',
    category: EventCategory.music,
    starts: _at(4, 18),
    location: 'Cafe Aroma',
    capacity: 25,
    description: 'Bring an instrument or just your voice.',
    attendees: _names(21), // 4 left
  ),
  EventItem(
    id: 'e10',
    title: 'Poster Design Meetup',
    category: EventCategory.art,
    starts: _at(6, 15),
    location: 'https://meet.example.com/posters',
    capacity: 50,
    online: true,
    description: 'Critique session for your posters.',
    attendees: _names(10),
  ),
  EventItem(
    id: 'e11',
    title: 'Football Friendly',
    category: EventCategory.sport,
    starts: _at(-10, 17),
    location: 'University Stadium',
    capacity: 22,
    attendees: _names(18),
  ),
  EventItem(
    id: 'e12',
    title: 'AI Study Group',
    category: EventCategory.tech,
    starts: _at(8, 17),
    location: 'Lab 12',
    capacity: 12,
    attendees: _names(4),
  ),
];
