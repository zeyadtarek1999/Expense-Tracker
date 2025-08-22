class TimeFormatter {
  const TimeFormatter._();

   static String formatDateShort(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    final yy = (d.year % 100).toString().padLeft(2, '0');
    return '$mm/$dd/$yy';
  }

   static String formatToday12h(DateTime t) {
    final hour12 = (t.hour == 0 || t.hour == 12) ? 12 : t.hour % 12;
    final minutes = t.minute.toString().padLeft(2, '0');
    final ampm = t.hour >= 12 ? 'PM' : 'AM';
    return 'Today $hour12:$minutes $ampm';
  }
}
