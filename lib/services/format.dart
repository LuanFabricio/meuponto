String minutesHourFormat(int totalMinutes) {
  String format = "";

  int hour = (totalMinutes / 60).floor();
  int minutes = totalMinutes % 60;

  format += hour.toString().padLeft(2, '0');
  format += ':';
  format += minutes.toString().padLeft(2, '0');

  return format;
}
