import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

class DateUtil {
  static int weekOfYear(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  static DateTime getDateFromString(String date, String pattern) {
    DateFormat format = DateFormat(pattern);
    try {
      return format.parse(date);
    } catch (e) {
      return null;
    }
  }

  static String getFormattedDate(DateTime date, String pattern) {
    DateFormat format = DateFormat(pattern);
    final value = format.format(date);
    return value;
  }

  static String getAppFormattedDate(DateTime date) {
    final format = DateFormat(AppConstants.appDateFormat);
    return format.format(date);
  }

  static String getLocaleFormattedDate(DateTime date, BuildContext context) {
    String locale = Localizations.localeOf(context).countryCode;
    DateFormat format = DateFormat(locale);
    return format.format(date);
  }

  static String getFormattedTime(TimeOfDay time, String outputPattern) {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat(outputPattern);
    return format.format(date);
  }

  static String getAppFormattedTime(TimeOfDay time) {
    return getFormattedTime(time, AppConstants.appTimeFormat);
  }

  static TimeOfDay getTimeOfDayFromDateTime(DateTime dateTime) {
    return TimeOfDay.fromDateTime(dateTime);
  }

  static DateTime getDateTimeFromTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final time = DateTime.utc(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return time;
  }

}
