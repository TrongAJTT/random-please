# Multi Tools Flutter App - Tài Liệu Lập Trình
Đính kèm commit Remove gray layout divider on PC layout | a4b6bb5082a004157e21c62f0624d4a2c7e289f9.

## Tổng Quan
Ứng dụng Flutter đa nền tảng cung cấp các công cụ tiện ích khác nhau bao gồm tạo mẫu văn bản và bộ tạo ngẫu nhiên. Ứng dụng có thiết kế responsive với layout riêng cho mobile và desktop.

## Kiến Trúc

### Cấu Trúc Dự Án
```
lib/
├── main.dart                    # Điểm vào ứng dụng và quản lý layout
├── l10n/                       # Files quốc tế hóa
├── models/                     # Mô hình dữ liệu
├── screens/                    # Màn hình UI
├── services/                   # Logic nghiệp vụ và dịch vụ dữ liệu
├── utils/                      # Hàm tiện ích
└── widgets/                    # Thành phần UI tái sử dụng
```

### Các Mẫu Thiết Kế Chính

#### 1. Layout Responsive
- **Layout Mobile**: Navigation truyền thống với `Navigator.push()`
- **Layout Desktop**: Sidebar navigation với nội dung nhúng
- Breakpoint: 600px chiều rộng

#### 2. Mẫu Embedded Mode
Tất cả màn hình công cụ hỗ trợ embedded mode cho layout desktop:
```dart
class ToolScreen extends StatefulWidget {
  final bool isEmbedded;
  final Function(Widget, String)? onToolSelected;
  
  const ToolScreen({
    super.key, 
    this.isEmbedded = false, 
    this.onToolSelected
  });
}
```

#### 3. Chiến Lược Navigation
- **Mobile**: Flutter navigation stack tiêu chuẩn
- **Desktop**: Chuyển đổi công cụ dựa trên callback không có navigation stack

## Tính Năng Cốt Lõi

### 1. Trình Tạo Mẫu Văn Bản
- Tạo mẫu tài liệu tái sử dụng
- Hỗ trợ các trường động (text, number, date, time)
- Các phần lặp lại với logic tùy chỉnh
- Xuất/nhập mẫu để backup và chia sẻ

### 2. Bộ Tạo Ngẫu Nhiên
12 công cụ tạo ngẫu nhiên khác nhau:
- Tạo mật khẩu với quy tắc tùy chỉnh
- Tạo số với phạm vi và tùy chọn
- Tạo ngày/thời gian ngẫu nhiên
- Công cụ quyết định (Yes/No, tung xu, kéo búa bao)
- Tạo màu sắc và văn bản ngẫu nhiên

### 3. Hệ Thống Cache
- Quản lý cache tự động
- Dọn dẹp cache thủ công
- Theo dõi kích thước storage
- Tích hợp với quản lý log

### 4. Hệ Thống Logging
- File logging với hiệu năng cao
- Tự động cleanup và rotation
- Buffered I/O cho tối ưu hóa
- Quản lý log tích hợp trong UI

## Dịch Vụ Chính

### TemplateService
Quản lý mẫu văn bản:
- CRUD operations cho templates
- Import/export batch
- Validation và error handling

### CacheService
Quản lý cache ứng dụng:
- Tính toán kích thước cache
- Xóa cache theo category
- Tích hợp với UI quản lý

### FileLoggerService
Logging hiệu năng cao:
- Buffered file writing
- Automatic log rotation
- Daily cleanup scheduler
- Performance optimization

### AppLogger
Interface logging đơn giản:
- Singleton pattern
- Extension methods
- Structured logging levels

## Internationalization (i18n)

### Hỗ Trợ Ngôn Ngữ
- **Tiếng Anh**: Ngôn ngữ mặc định
- **Tiếng Việt**: Bản địa hóa đầy đủ

### Cấu Trúc ARB Files
```
lib/l10n/
├── app_en.arb          # Tiếng Anh
└── app_vi.arb          # Tiếng Việt
```

### Tạo Localization
```bash
flutter pub get
flutter pub run intl_utils:generate
```

## Responsive Design

### Breakpoints
- **Mobile**: < 600px - Single column, bottom navigation
- **Desktop**: ≥ 600px - Sidebar navigation, multi-column layout

### Navigation Patterns
```dart
// Mobile Navigation
Navigator.push(context, MaterialPageRoute(...));

// Desktop Navigation
onToolSelected?.call(toolWidget, toolTitle);
```

## Testing

### Cấu Trúc Test
```
test/
├── unit/              # Unit tests
├── widget/            # Widget tests
└── integration/       # Integration tests
```

### Chạy Tests
```bash
flutter test
flutter test integration_test/
```

### Loại Tests
- Unit tests cho models và services
- Widget tests cho UI components
- Integration tests cho workflows hoàn chỉnh

### Build & Deployment
```bash
# Development build
flutter run

# Release build
flutter build apk --release
flutter build windows --release
```

## Tài Liệu Bổ Sung
- **[Triển Khai Logging](LOGGING_IMPLEMENTATION.md)**: Hệ thống logging toàn diện với lưu trữ file và tự động dọn dẹp
- **[Di Chuyển Hive](HIVE_MIGRATION.md)**: Hướng dẫn di chuyển từ SharedPreferences sang Hive

## Cải Tiến Tương Lai
- Đồng bộ hóa cloud
- Hệ thống plugin cho công cụ tùy chỉnh
- Template scripting nâng cao
- Xuất ra nhiều định dạng (PDF, DOCX)
- Cải thiện dark theme
- Tối ưu hóa hiệu năng

## Khắc Phục Sự Cố

### Vấn Đề Thường Gặp
1. **Vấn đề layout trên desktop**: Kiểm tra triển khai flag `isEmbedded`
2. **Vấn đề navigation**: Xác minh sử dụng callback vs Navigator
3. **Localization không hoạt động**: Kiểm tra cú pháp ARB file và generation
4. **File operations thất bại**: Xác minh permissions và paths

### Lệnh Debug
```bash
flutter clean
flutter pub get
flutter pub run build_runner build
flutter analyze
```

## Đóng Góp
Khi thêm tính năng mới:
1. Thêm tests tương ứng
2. Cập nhật documentation
3. Tuân thủ các mẫu thiết kế hiện có
4. Đảm bảo hỗ trợ embedded mode cho desktop
