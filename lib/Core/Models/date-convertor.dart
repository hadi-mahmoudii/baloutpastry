// ignore: import_of_legacy_library_into_null_safe
// import 'package:persian_date/persian_date.dart';
// import 'package:shamsi_date/shamsi_date.dart';

import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class DateConvertor {
  String dateConvert(String date) {
    DateTime dat = DateTime.parse(date);
    DateTime curDat = dat.toLocal();
    Jalali? pdate = Jalali.fromDateTime(curDat);
    // String dateValue =
    //     // '${pdate.year} ${pdate.weekdayname} ، ${pdate.day} ${pdate.monthname}';
    //     '${pdate.weekDay} ${pdate.day} ${pdate.month} ${pdate.year} ';

    return pdate.formatFullDate();
  }

  static dateToJalali(
    String date,
  ) {
    int year = int.parse(date.split('/')[0]);
    int month = int.parse(date.split('/')[1]);
    int day = int.parse(date.split('/')[2]);
    DateTime dat = DateTime(year, month, day);
    Jalali g = Jalali.fromDateTime(dat);
    // print(g.month);
    // Gregorian.fromJalali(
    //   Jalali(
    //     int.parse(date.split('/')[0]),
    //     int.parse(date.split('/')[1]),
    //     int.parse(date.split('/')[2]),
    //   ),
    // );

    return g.year.toString() +
        '/' +
        g.month.toString() +
        '/' +
        g.day.toString();
  }

  static int compareDateFromNow(String date) {
    DateTime dat = DateTime.parse(date);
    DateTime curDat = dat.toLocal();
    return curDat.compareTo(DateTime.now());
  }

  String jalaliToMiladi(String data) {
    String result = '';
    // print(data);
    Jalali perDate = Jalali(int.parse(data.split('/')[0]),
        int.parse(data.split('/')[1]), int.parse(data.split('/')[2]));
    Gregorian milDate = perDate.toGregorian();
    result = milDate.year.toString() +
        '/' +
        milDate.month.toString() +
        '/' +
        milDate.day.toString();

    return result;
  }
}
