import 'dart:ui';

extension ColorUtil on Color {
  String getAlphaStringFixed(int fractionDigits) {
    return a.toStringAsFixed(fractionDigits);
  }

  String getRedStringFixed(int fractionDigits) {
    return r.toStringAsFixed(fractionDigits);
  }

  String getGreenStringFixed(int fractionDigits) {
    return g.toStringAsFixed(fractionDigits);
  }

  String getBlueStringFixed(int fractionDigits) {
    return b.toStringAsFixed(fractionDigits);
  }

  String getAlpha255String() {
    return ((a * 255).round()).toString();
  }

  String getRed255String() {
    return ((r * 255).round()).toString();
  }

  String getGreen255String() {
    return ((g * 255).round()).toString();
  }

  String getBlue255String() {
    return ((b * 255).round()).toString();
  }
}
