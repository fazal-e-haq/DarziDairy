/// Formatter for deadlines, booking dates, and Roznamcha entries
class DateFormatter {
  DateFormatter._();

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  /// Returns readable short date format, e.g. "12 Oct 2026"
  static String formatShortDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} ${_months[date.month - 1]} ${date.year}';
  }

  /// Alias for formatShortDate
  static String formatDate(DateTime date) => formatShortDate(date);

  /// Returns relative deadline text, e.g., "Today", "Tomorrow", "In 3 days", or "Overdue by 2 days"
  static String formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(deadline.year, deadline.month, deadline.day);
    final diff = target.difference(today).inDays;

    if (diff == 0) return 'Due Today';
    if (diff == 1) return 'Due Tomorrow';
    if (diff > 1) return 'Due in $diff days';
    if (diff == -1) return 'Overdue by 1 day';
    return 'Overdue by ${diff.abs()} days';
  }
}
