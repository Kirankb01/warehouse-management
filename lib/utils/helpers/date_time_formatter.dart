String formatDate(DateTime dateTime) {
  return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}';
}

String formatTime(DateTime dateTime) {
  return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
}

String formatDateTime(DateTime dateTime) {
  return 'Date: ${formatDate(dateTime)}  •  Time: ${formatTime(dateTime)}';
}