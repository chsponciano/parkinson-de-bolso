
import 'package:intl/intl.dart';

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

  String getMonth(int month) {
    return this.months[month].substring(0, 3).toUpperCase();
  }

  int millisecondsToMonth(int millisecondsSinceEpoch) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    return dateTime.month - 1;
  }

  String getMonthYear(int millisecondsSinceEpoch) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    String year = dateTime.year.toString().substring(2);
    String month = this.months[dateTime.month - 1].substring(0, 3).toUpperCase();
    return '$month/$year';
  }
}