import 'package:intl/intl.dart';

class AppFormat {
// DateTime formatting function
  static String dateFormat(String stringDate) {
    DateTime dateTime = DateTime.parse(stringDate);

    return DateFormat('EEEE, dd MMMM yyyy', 'en_US').format(dateTime);
  }

  static String dateTime(String stringTime) {
    DateTime time = DateTime.parse(stringTime);
    return DateFormat('HH:mm', 'id_ID').format(time);
  }

  static String getTime(var timeStamp) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    String value = DateFormat('Hm').format(time);

    return value;
  }

  static String getDay(var day) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(day * 1000);
    final x = DateFormat('EEEE').format(time);
    return x;
  }
}
