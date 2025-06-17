bool matchesDateFilter(DateTime dateTime, String selectedFilter) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final targetDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (selectedFilter == 'Today') {
    return targetDate == today;
  } else if (selectedFilter == 'Last Week') {
    final lastWeek = now.subtract(const Duration(days: 7));
    return targetDate.isAfter(lastWeek);
  } else if (selectedFilter == 'Last Month') {
    final lastMonth = now.subtract(const Duration(days: 30));
    return targetDate.isAfter(lastMonth);
  }
  return true;
}
