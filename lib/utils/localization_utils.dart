import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_please/l10n/app_localizations.dart';

class LocalizationUtils {
  static String formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    // Use 'yMd' for a standard numeric date format that adapts to the locale
    // e.g., 'M/d/y' for en_US, 'd/M/y' for en_GB, etc.
    final DateFormat formatter = DateFormat.yMd(locale);
    return formatter.format(date);
  }

  static String formatDateTime(BuildContext context, DateTime dateTime) {
    final locale = Localizations.localeOf(context).toString();
    final DateFormat formatter =
        DateFormat.yMd(locale).add_jms(); // Date and time
    return formatter.format(dateTime);
  }

  static String getLocalizedWeekdayName(
      dynamic weekday, AppLocalizations l10n) {
    if (weekday == null) return '';
    final day =
        weekday is int ? weekday : int.tryParse(weekday.toString()) ?? 1;
    switch (day) {
      case 1:
        return l10n.monday;
      case 2:
        return l10n.tuesday;
      case 3:
        return l10n.wednesday;
      case 4:
        return l10n.thursday;
      case 5:
        return l10n.friday;
      case 6:
        return l10n.saturday;
      case 7:
        return l10n.sunday;
      default:
        return '';
    }
  }

  static String getLocalizedMonthName(dynamic month, AppLocalizations l10n) {
    if (month == null) return '';
    final monthNum = month is int ? month : int.tryParse(month.toString()) ?? 1;
    switch (monthNum) {
      case 1:
        return l10n.january;
      case 2:
        return l10n.february;
      case 3:
        return l10n.march;
      case 4:
        return l10n.april;
      case 5:
        return l10n.may;
      case 6:
        return l10n.june;
      case 7:
        return l10n.july;
      case 8:
        return l10n.august;
      case 9:
        return l10n.september;
      case 10:
        return l10n.october;
      case 11:
        return l10n.november;
      case 12:
        return l10n.december;
      default:
        return '';
    }
  }
}
