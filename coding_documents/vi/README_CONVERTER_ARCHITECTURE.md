# Generic Converter Architecture

## Tổng quan

Hệ thống converter mới được thiết kế để tái sử dụng logic UI và business logic cho tất cả các loại converter (currency, length, weight, temperature, v.v.).

## Kiến trúc

### 1. Base Models (`lib/models/converter_base.dart`)

- `ConverterUnit`: Abstract base class cho tất cả các đơn vị
- `ConversionStatus`: Enum cho trạng thái conversion
- `ConverterCardState`: State của một card/row trong converter
- `ConverterState`: Tổng thể state của converter
- `UnitItem`: Configuration cho customization dialog

### 2. Base Services (`lib/services/converter_service_base.dart`)

- `ConverterServiceBase`: Abstract interface cho tất cả converter services
- `ConverterStateService`: Interface cho việc lưu/load state

### 3. Controller (`lib/controllers/converter_controller.dart`)

- `ConverterController`: Quản lý UI state và operations
- Sử dụng ChangeNotifier pattern
- Handle tất cả UI logic: add/remove cards, reorder, update values, v.v.

### 4. Generic UI Components (`lib/widgets/converter_ui/`)

- `GenericConverterView`: Main view có thể sử dụng cho bất kỳ converter nào
- `ConverterCardWidget`: Widget cho card view
- `ConverterTableWidget`: Widget cho table view  
- `ConverterStatusWidget`: Status bar hiển thị thông tin và actions

### 5. State Management (`lib/services/generic_state_service.dart`)

- Implementation của `ConverterStateService`
- Sử dụng SharedPreferences để persist state
- Tự động serialize/deserialize JSON

## Cách triển khai Converter mới

### Bước 1: Tạo Unit class

```dart
class LengthUnit extends ConverterUnit {
  final String _id;
  final String _name;
  final String _symbol;
  final double _factor;

  LengthUnit({
    required String id,
    required String name,
    required String symbol,
    required double factor,
  }) : _id = id, _name = name, _symbol = symbol, _factor = factor;

  @override
  String get id => _id;
  @override
  String get name => _name;
  @override
  String get symbol => _symbol;

  @override
  String formatValue(double value) {
    // Custom formatting logic
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'symbol': symbol,
    'factor': factor,
  };
}
```

### Bước 2: Implement Service

```dart
class LengthConverterService extends ConverterServiceBase {
  @override
  String get converterType => 'length';
  
  @override
  String get displayName => 'Length Converter';
  
  @override
  Set<String> get defaultVisibleUnits => {'meter', 'kilometer', 'centimeter'};
  
  @override
  List<ConverterUnit> get units => [
    LengthUnit(id: 'meter', name: 'Meter', symbol: 'm', factor: 1.0),
    // ... more units
  ];
  
  @override
  double convert(double value, String fromUnitId, String toUnitId) {
    // Conversion logic
  }
  
  @override
  ConverterUnit? getUnit(String unitId) {
    // Find unit by ID
  }
}
```

### Bước 3: Tạo Screen

```dart
class LengthConverterScreen extends StatefulWidget {
  @override
  State<LengthConverterScreen> createState() => _LengthConverterScreenState();
}

class _LengthConverterScreenState extends State<LengthConverterScreen> {
  late ConverterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConverterController(
      converterService: LengthConverterService(),
      stateService: GenericStateService(),
    );
    _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: GenericConverterView(
        title: 'Length Converter',
        titleIcon: Icons.straighten,
        onShowInfo: () => _showLengthConverterInfo(context),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

## Lợi ích

### 1. Tái sử dụng code
- Một bộ UI components cho tất cả converter
- Logic chung cho state management, persistence, v.v.
- Giảm duplicate code đáng kể

### 2. Consistency
- UI/UX nhất quán giữa các converter
- Cùng một pattern cho tất cả features

### 3. Maintainability  
- Bug fixes và improvements áp dụng cho tất cả converter
- Dễ dàng add features mới cho tất cả converter cùng lúc

### 4. Type Safety
- Abstract classes đảm bảo implementation đúng interface
- Compile-time error checking

### 5. Extensibility
- Dễ dàng add converter mới chỉ bằng cách implement interface
- Flexible customization qua configuration

## Migration từ Currency Converter hiện tại

1. Tạo `CurrencyUnit` extends `ConverterUnit`
2. Refactor `CurrencyConverter` thành `CurrencyConverterService` extends `ConverterServiceBase`
3. Replace UI logic bằng `GenericConverterView`
4. Sử dụng `ConverterController` thay vì custom state management
5. Update state persistence để sử dụng `GenericStateService`

## Dependencies cần thêm

```yaml
dependencies:
  provider: ^6.0.0  # For state management
  shared_preferences: ^2.0.0  # For state persistence
```

## Tương lai

- Có thể add plugin system cho custom converters
- Support cho custom themes và layouts
- Advanced features như favorites, history, etc.
- Integration với other apps qua intents/deep links 