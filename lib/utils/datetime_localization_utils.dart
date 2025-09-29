/// Utility class for formatting DateTime durations in localized strings
class DateTimeLocalizationUtils {
  /// Format a duration into a localized string
  ///
  /// Parameters:
  /// - [duration]: The Duration to format
  /// - [includeTime]: Whether to include hours and minutes
  /// - [includeDate]: Whether to include days
  /// - [includeMonth]: Whether to include months
  /// - [includeYear]: Whether to include years
  /// - [locale]: The locale for formatting (default: 'en')
  static String formatDuration({
    required Duration duration,
    bool includeTime = true,
    bool includeDate = true,
    bool includeMonth = true,
    bool includeYear = true,
    String locale = 'en',
  }) {
    final parts = <String>[];

    // Calculate components using more accurate method
    final totalDays = duration.inDays;

    // Use a more accurate year calculation (accounting for leap years)
    final years = totalDays ~/ 365;
    final remainingDaysAfterYears = totalDays % 365;

    // Use average month length (365.25/12 ≈ 30.44 days)
    final months = (remainingDaysAfterYears / 30.44).floor();
    final remainingDaysAfterMonths =
        remainingDaysAfterYears - (months * 30.44).round();

    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    // Build localized string based on locale
    if (locale == 'vi') {
      // Vietnamese formatting
      if (includeYear && years > 0) {
        parts.add('$years ${years == 1 ? 'năm' : 'năm'}');
      }
      if (includeMonth && months > 0) {
        parts.add('$months ${months == 1 ? 'tháng' : 'tháng'}');
      }
      if (includeDate && remainingDaysAfterMonths > 0) {
        final days = remainingDaysAfterMonths.round();
        parts.add('$days ${days == 1 ? 'ngày' : 'ngày'}');
      }
      if (includeTime && hours > 0) {
        parts.add('$hours ${hours == 1 ? 'giờ' : 'giờ'}');
      }
      if (includeTime && minutes > 0) {
        parts.add('$minutes ${minutes == 1 ? 'phút' : 'phút'}');
      }
    } else {
      // English formatting
      if (includeYear && years > 0) {
        parts.add('$years ${years == 1 ? 'year' : 'years'}');
      }
      if (includeMonth && months > 0) {
        parts.add('$months ${months == 1 ? 'month' : 'months'}');
      }
      if (includeDate && remainingDaysAfterMonths > 0) {
        final days = remainingDaysAfterMonths.round();
        parts.add('$days ${days == 1 ? 'day' : 'days'}');
      }
      if (includeTime && hours > 0) {
        parts.add('$hours ${hours == 1 ? 'hour' : 'hours'}');
      }
      if (includeTime && minutes > 0) {
        parts.add('$minutes ${minutes == 1 ? 'minute' : 'minutes'}');
      }
    }

    // If no parts, return "0" with appropriate unit
    if (parts.isEmpty) {
      if (locale == 'vi') {
        if (includeTime) return '0 phút';
        if (includeDate) return '0 ngày';
        if (includeMonth) return '0 tháng';
        if (includeYear) return '0 năm';
      } else {
        if (includeTime) return '0 minutes';
        if (includeDate) return '0 days';
        if (includeMonth) return '0 months';
        if (includeYear) return '0 years';
      }
    }

    return parts.join(' ');
  }

  /// Format duration for DateTime (includes all components)
  static String formatDateTimeDuration(Duration duration, String locale) {
    return formatDuration(
      duration: duration,
      includeTime: true,
      includeDate: true,
      includeMonth: true,
      includeYear: true,
      locale: locale,
    );
  }

  /// Format duration for Date only (excludes time)
  static String formatDateDuration(Duration duration, String locale) {
    return formatDuration(
      duration: duration,
      includeTime: false,
      includeDate: true,
      includeMonth: true,
      includeYear: true,
      locale: locale,
    );
  }

  /// Format duration for Time only (excludes date/month/year)
  static String formatTimeDuration(Duration duration, String locale) {
    return formatDuration(
      duration: duration,
      includeTime: true,
      includeDate: false,
      includeMonth: false,
      includeYear: false,
      locale: locale,
    );
  }
}
