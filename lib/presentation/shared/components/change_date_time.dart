import 'package:intl/intl.dart';

String changeToDMY(String date) {
  if (date == '') {
    return '';
  }
  final parsedDate = DateTime.parse(date);

  final String year = parsedDate.year.toString().replaceRange(0, 2, '');

  final DateFormat formatter = DateFormat('d MMM, ');
  return formatter.format(parsedDate) + year;
}

String changeToSimpleDMY(String date, {bool toIST = false}) {
  if (date == '') {
    return '';
  }
  final parsedDate =
      DateTime.parse(date).add(Duration(minutes: toIST == true ? 330 : 0));

  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(parsedDate);
}

String changeToSimpleDMYHm(String date, {bool toIST = false}) {
  if (date == '') {
    return '';
  }
  final parsedDate =
      DateTime.parse(date).add(Duration(minutes: toIST == true ? 330 : 0));

  final DateFormat formatter = DateFormat('HH:mm a');
  return formatter.format(parsedDate);
}

String changeToDMYHyphen(String date) {
  if (date == '') {
    return '';
  }
  final parsedDate = DateTime.parse(date);

  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(parsedDate);
}

String changeToDMYHmsHyphen(String date) {
  if (date == '') {
    return '';
  }
  final parsedDate = DateTime.parse(date);

  final DateFormat formatter = DateFormat('dd/MM/yy HH:mm a');
  return formatter.format(parsedDate);
}

String changeToDM(String date) {
  if (date == '') {
    return '';
  }
  final parsedDate = DateTime.parse(date);
  final DateFormat formatter = DateFormat('dd MMM');
  return formatter.format(parsedDate);
}

String changeToHM(String time) {
  if (time == '') {
    return '';
  }
  final parsedTime = DateFormat('HH:mm').parse(time);
  return DateFormat('h:mm a').format(parsedTime);
}

String changeToHMS(String time) {
  if (time == '') {
    return '';
  }
  final parsedTime = DateFormat('HH:mm:ss').parse(time);
  return DateFormat('h:mm a').format(parsedTime);
}

String convertTo24HourFormat(String inputTimeString) {
  final inputFormat = DateFormat('h:mm a');
  final outputFormat = DateFormat('HH:mm:ss');
  final dateTime = inputFormat.parse(inputTimeString);
  final convertedTime = outputFormat.format(dateTime);
  return convertedTime;
}

String formatDateTime(DateTime dateTime) {
  // Converting UTc to IST time zone
  final DateTime newDateTime =
      dateTime.add(const Duration(hours: 5, minutes: 30));
  final DateTime now = DateTime.now();
  final DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
  final String amPmIndicator = newDateTime.hour < 12 ? 'AM' : 'PM';

  if (newDateTime.year == now.year &&
      newDateTime.month == now.month &&
      newDateTime.day == now.day) {
    // Today
    return 'Today\n${DateFormat.Hm().format(newDateTime)} $amPmIndicator';
  } else if (newDateTime.year == yesterday.year &&
      newDateTime.month == yesterday.month &&
      newDateTime.day == yesterday.day) {
    // Yesterday
    return 'Yesterday\n${DateFormat.Hm().format(newDateTime)} $amPmIndicator';
  } else {
    // Other days
    return changeToSimpleDMYHm(newDateTime.toString());
  }
}

String changeToHMByDate(String date) {
  if (date == '') {
    return '';
  }
  final parsedDate = DateTime.parse(date);
  // final parsedTime = DateFormat('HH:mm').parse(time);
  return DateFormat('h:mm a').format(parsedDate);
}

String convertDay(String inputDate) {
  try {
    // Split the input date string into day, month, and year parts
    final List<String> parts = inputDate.split('/');

    if (parts.length != 3) {
      return 'Invalid date format';
    }

    // Define a list of month abbreviations

    final int day = int.parse(parts[0]);
    final int monthIndex = int.parse(parts[1]) - 1; // Adjust month index

    // Check if the day is within a valid range
    if (day < 1 || day > 31 || monthIndex < 0 || monthIndex >= 12) {
      return 'Invalid date';
    }

    final String formattedDate = '$day${_getDaySuffix(day)}';

    return formattedDate;
  } catch (e) {
    return 'Invalid date format';
  }
}

String dateConvert(String inputDate) {
  try {
    // Split the input date string into day, month, and year parts
    final List<String> parts = inputDate.split('/');

    if (parts.length != 3) {
      return 'Invalid date format';
    }

    // Define a list of month abbreviations
    final List<String> monthAbbreviations = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    final int day = int.parse(parts[0]);
    final int monthIndex = int.parse(parts[1]) - 1; // Adjust month index
    final int year = int.parse(parts[2]);

    // Check if the day is within a valid range
    if (day < 1 || day > 31 || monthIndex < 0 || monthIndex >= 12) {
      return 'Invalid date';
    }

    final String monthAbbreviation = monthAbbreviations[monthIndex];
    final String formattedDate =
        "$day${_getDaySuffix(day)} $monthAbbreviation' $year";

    return formattedDate;
  } catch (e) {
    return 'Invalid date format';
  }
}

String dateConvertProfile(String inputDate) {
  try {
    // Split the input date string into day, month, and year parts
    final List<String> parts = inputDate.split('/');

    if (parts.length != 3) {
      return 'Invalid date format';
    }

    // Define a list of month abbreviations
    final List<String> monthAbbreviations = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final int day = int.parse(parts[0]);
    final int monthIndex = int.parse(parts[1]) - 1; // Adjust month index
    final int year = int.parse(parts[2].split('')[2] + parts[2].split('')[3]);

    // Check if the day is within a valid range
    if (day < 1 || day > 31 || monthIndex < 0 || monthIndex >= 12) {
      return 'Invalid date';
    }

    final String monthAbbreviation = monthAbbreviations[monthIndex];
    final String formattedDate =
        "$day${_getDaySuffix(day)} $monthAbbreviation' $year";

    return formattedDate;
  } catch (e) {
    return 'Invalid date format';
  }
}

String dateConvertDash(String inputDate) {
  try {
    // Split the input date string into day, month, and year parts
    final List<String> parts = inputDate.split('/');

    if (parts.length != 3) {
      return 'Invalid date format';
    }

    // Define a list of month abbreviations
    final List<String> monthAbbreviations = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final List<String> weekday = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];

    final int day = int.parse(parts[0]);
    final int monthIndex = int.parse(parts[1]) - 1; // Adjust month index
    final int year = int.parse(parts[2]);

    // Check if the day is within a valid range
    if (day < 1 || day > 31 || monthIndex < 0 || monthIndex >= 12) {
      return 'Invalid date';
    }

    final String monthAbbreviation = monthAbbreviations[monthIndex];
    // final String weekdays =
    //     weekday[DateTime(year, monthIndex + 1, day).weekday];
    // log('${DateTime(year, monthIndex, day)}');
    final String weekdays =
        DateFormat('EEEE').format(DateFormat('dd/MM/yyyy').parse(inputDate));
    final String formattedDate =
        // ignore: prefer_single_quotes
        "$day${_getDaySuffix(day)} $monthAbbreviation $year, $weekdays";

    return formattedDate;
  } catch (e) {
    return 'Invalid date format';
  }
}

String convertMonthYear(String inputDate) {
  try {
    // Split the input date string into day, month, and year parts
    final List<String> parts = inputDate.split('/');

    if (parts.length != 3) {
      return 'Invalid date format';
    }

    // Define a list of month abbreviations
    final List<String> monthAbbreviations = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    final int day = int.parse(parts[0]);
    final int monthIndex = int.parse(parts[1]) - 1; // Adjust month index
    final int year = int.parse(parts[2]);

    // Check if the day is within a valid range
    if (day < 1 || day > 31 || monthIndex < 0 || monthIndex >= 12) {
      return 'Invalid date';
    }

    final String monthAbbreviation = monthAbbreviations[monthIndex];
    final String formattedDate = "$monthAbbreviation' ${year % 100}";

    return formattedDate;
  } catch (e) {
    return 'Invalid date format';
  }
}

String _getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}
