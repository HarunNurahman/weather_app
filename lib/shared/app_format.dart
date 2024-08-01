import 'package:intl/intl.dart';

class AppFormat {
// DateTime formatting function
  static String dateFormat(String stringDate) {
    DateTime dateTime = DateTime.parse(stringDate);

    return DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(dateTime);
  }

  static String dateTime(String stringTime) {
    DateTime time = DateTime.parse(stringTime);
    return DateFormat('HH:mm', 'id_ID').format(time);
  }
}
