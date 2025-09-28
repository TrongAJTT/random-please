/// Abstract base class for all counter statistics
abstract class CounterStatisticsBase {
  final DateTime startTime;
  final int totalGenerations;

  const CounterStatisticsBase({
    required this.startTime,
    required this.totalGenerations,
  });

  /// Get all count values as a map
  Map<String, int> get counts;

  /// Get all percentage values as a map
  Map<String, double> get percentages;

  /// Get all labels for display
  Map<String, String> get labels;

  /// Get all icons for display
  Map<String, String> get icons;

  /// Get all colors for display
  Map<String, int> get colors;

  /// Calculate percentage for a given count
  double calculatePercentage(int count) {
    if (totalGenerations == 0) return 0.0;
    return (count / totalGenerations) * 100;
  }

  /// Format time for display
  String formatTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Create a copy with updated values - to be implemented by subclasses
  CounterStatisticsBase copyWith({
    DateTime? startTime,
    int? totalGenerations,
  });
}
