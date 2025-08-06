import 'package:flutter/material.dart';

/// A divider with vertical spacing
class VerticalSpacingDivider extends StatelessWidget {
  final double top;
  final double bottom;

  const VerticalSpacingDivider._({required this.top, required this.bottom});

  /// Creates a divider with the same vertical spacing on the top and bottom.
  ///
  /// [value] is the spacing to apply.
  factory VerticalSpacingDivider.both(double value) {
    return VerticalSpacingDivider._(top: value, bottom: value);
  }

  /// Creates a divider with specific vertical spacing for top and bottom.
  factory VerticalSpacingDivider.specific({
    double top = 0,
    double bottom = 0,
  }) {
    return VerticalSpacingDivider._(top: top, bottom: bottom);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: bottom),
      child: const Divider(),
    );
  }

  /// Creates a divider with only top spacing.
  factory VerticalSpacingDivider.onlyTop(double value) {
    return VerticalSpacingDivider._(top: value, bottom: 0);
  }

  /// Creates a divider with only bottom spacing.
  factory VerticalSpacingDivider.onlyBottom(double value) {
    return VerticalSpacingDivider._(top: 0, bottom: value);
  }
}
