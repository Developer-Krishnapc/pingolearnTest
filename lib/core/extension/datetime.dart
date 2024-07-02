import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String toMMY() {
    final parsed = DateFormat('MMMM y').format(this);
    return '${parsed.substring(0, 3)} $year';
  }

  String toDDMMYY() {
    final parsed = DateFormat('d/MM/y').format(this);
    return parsed;
  }

  String toYYMMDD() {
    final parsed = DateFormat('yyyy-MM-dd').format(this);
    return parsed;
  }

  String monthStr([int? sub]) {
    final parsedTime = DateFormat('EEEEE').format(this);
    return parsedTime.substring(0, sub ?? parsedTime.length);
  }

  String toHHMM() {
    final parsedTime = DateFormat('HH:mm a').format(this);
    return parsedTime;
  }

  String toBackendDateFormat() {
    return DateFormat('yyyy-MM-ddT12:mm:ss').format(this);
  }
}
