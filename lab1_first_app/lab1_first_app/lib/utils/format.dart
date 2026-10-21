import '../models/countdown.dart';

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _two(int n) => n.toString().padLeft(2, '0');

String formatClock(int hour, int minute) => '${_two(hour)}:${_two(minute)}';

String formatDay(DateTime d) => '${d.day} ${_months[d.month - 1]}';

String formatDate(DateTime d) =>
    '${formatDay(d)}, ${formatClock(d.hour, d.minute)}';

String _span(Duration d) {
  if (d.inDays > 0) return '${d.inDays} d ${d.inHours % 24} h';
  if (d.inHours > 0) return '${d.inHours} h ${d.inMinutes % 60} min';
  return '${d.inMinutes} min';
}

String describeCountdown(Countdown c) => switch (c) {
  Upcoming(:final left) => 'In ${_span(left)}',
  Started(:final since) => 'Started ${_span(since)} ago',
  Ended() => 'Ended',
};
