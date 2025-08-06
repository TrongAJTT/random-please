import 'package:flutter_test/flutter_test.dart';
import 'package:random_please/services/converter_services/currency_service.dart';

void main() {
  test('Currency service basic test', () {
    // Test basic currency conversion
    final result = CurrencyService.convert(100, 'USD', 'EUR');
    expect(result, 85.0);
  });
}
