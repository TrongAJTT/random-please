import '../interfaces/api_random_generator.dart';
import '../services/number_api_service.dart';
import '../services/color_api_service.dart';
import '../services/password_api_service.dart';
import '../services/cards_api_service.dart';
import '../services/simple_generators_api_service.dart';
import '../services/date_api_service.dart';
import '../services/lorem_ipsum_api_service.dart';
import '../services/latin_letter_api_service.dart';
import '../services/list_picker_api_service.dart';

// Service registry để quản lý tất cả generators theo SOLID DIP principle
class ApiServiceRegistry {
  final Map<String, ApiRandomGenerator> _services = {};

  // Singleton pattern
  static final ApiServiceRegistry _instance = ApiServiceRegistry._internal();
  factory ApiServiceRegistry() => _instance;
  ApiServiceRegistry._internal() {
    _registerServices();
  }

  // Register all available services
  void _registerServices() {
    _services['number'] = NumberApiService();
    _services['color'] = ColorApiService();
    _services['password'] = PasswordApiService();
    _services['card'] = CardsApiService();
    _services['coin'] = CoinApiService();
    _services['dice'] = DiceApiService();
    _services['rps'] = RpsApiService();
    _services['yesno'] = YesNoApiService();
    // New services implemented
    _services['date'] = DateApiService();
    _services['lorem'] = LoremIpsumApiService();
    _services['letter'] = LatinLetterApiService();
    _services['list'] = ListPickerApiService();
  }

  // Get service by name
  ApiRandomGenerator? getService(String name) {
    return _services[name];
  }

  // Get all available services
  Map<String, ApiRandomGenerator> getAllServices() {
    return Map.unmodifiable(_services);
  }

  // Get service info for meta endpoints
  List<Map<String, dynamic>> getServicesInfo() {
    return _services.entries.map((entry) {
      final service = entry.value;
      return {
        'name': entry.key,
        'description': service.description,
        'version': service.version,
        'endpoint': '/api/v1/random/${entry.key}',
      };
    }).toList();
  }

  // Check if service exists
  bool hasService(String name) {
    return _services.containsKey(name);
  }
}
