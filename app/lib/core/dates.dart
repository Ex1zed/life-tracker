/// Local calendar date as "YYYY-MM-DD", the format stored in daily_checkins.date.
String toDateKey(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

const _weekdays = [
  'Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота',
  'Воскресенье',
];
const _weekdaysShort = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

/// Month names in the genitive case: "21 ноября", not "21 ноябрь".
const _months = [
  'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа',
  'сентября', 'октября', 'ноября', 'декабря',
];

/// "Суббота, 21 ноября". DateTime.weekday is 1 (Monday) .. 7 (Sunday).
String formatLongDate(DateTime date) =>
    '${_weekdays[date.weekday - 1]}, ${date.day} ${_months[date.month - 1]}';

/// "Пн" .. "Вс".
String shortWeekday(DateTime date) => _weekdaysShort[date.weekday - 1];

/// Monday of the week that contains [date], at local midnight.
/// day - n instead of subtract(Duration): no surprises around DST changes,
/// and day 0 or below rolls back into the previous month by itself.
DateTime startOfWeek(DateTime date) =>
    DateTime(date.year, date.month, date.day - (date.weekday - 1));