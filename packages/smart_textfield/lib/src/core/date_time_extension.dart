extension DateTimeExtension on DateTime {
  DateTime get withoutTime => DateTime(year, month, day);
}
