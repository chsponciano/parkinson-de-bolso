
import 'package:intl/intl.dart';

enum DateTimeFormatUtil {
  BR_DATE  
}
mixin DateTimeUtil {
  final DateFormat format = DateFormat('dd/MM/yyyy');
  final List<String> months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novemebro',
    'Dezembro'
  ]; 

  DateTime strToDate(String value, DateTimeFormatUtil format) {
    if (format == DateTimeFormatUtil.BR_DATE) {
      var dateStr = value.split('/');
      return DateTime(int.parse(dateStr[2]), int.parse(dateStr[1]), int.parse(dateStr[0]));
    }

    return DateTime.now();
  }

  String getMonth(int month) {
    if (month < 0) {
      month = months.length + month;
    }
    return this.months[month].substring(0, 3).toUpperCase();
  }

  int millisecondsToMonth(int millisecondsSinceEpoch) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    return dateTime.month - 1;
  }

  String getMonthYear(int millisecondsSinceEpoch, bool isFullYear) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    String year = (isFullYear) ? dateTime.year.toString() : dateTime.year.toString().substring(2);
    String month = this.months[dateTime.month - 1].substring(0, 3).toUpperCase();
    return '$month/$year';
  }

  String getDayMonthYear(int millisecondsSinceEpoch, bool isFullYear) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    String day = dateTime.day.toString();
    String year = (isFullYear) ? dateTime.year.toString() : dateTime.year.toString().substring(2);
    String month = this.months[dateTime.month - 1].substring(0, 3).toUpperCase();
    return '$day/$month/$year';
  }

  int getCurrentAge(DateTime other) {
    return DateTime.now().difference(other).inDays ~/ 365;
  }
}