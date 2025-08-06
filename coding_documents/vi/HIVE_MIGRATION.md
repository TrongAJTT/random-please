# Hive Migration Documentation

## Tổng quan
Dự án đã được chuyển đổi từ SharedPreferences sang Hive database để tăng hiệu suất lưu trữ cache. Việc này giúp:
- Tăng tốc độ đọc/ghi dữ liệu
- Hỗ trợ lưu trữ dữ liệu phức tạp tốt hơn
- Quản lý cache hiệu quả hơn

## Các thay đổi chính

### 1. Dependencies đã thêm
```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.12
```

### 2. Services đã cập nhật

#### HiveService (Mới)
- Quản lý khởi tạo và đóng Hive boxes
- Cung cấp các phương thức tiện ích để làm việc với Hive
- Boxes: `templates`, `history`

#### TemplateService 
- **Trước**: Sử dụng SharedPreferences
- **Sau**: Sử dụng Hive box `templates`
- Tất cả CRUD operations giữ nguyên interface

#### GenerationHistoryService
- **Trước**: Sử dụng SharedPreferences 
- **Sau**: Sử dụng Hive box `history`
- Giữ nguyên encryption và các tính năng bảo mật
- **Settings**: Vẫn dùng SharedPreferences (theo yêu cầu)

#### CacheService
- Cập nhật để hỗ trợ cả Hive và SharedPreferences
- Settings cache vẫn dùng SharedPreferences
- Templates và History cache dùng Hive

#### MigrationService (Mới)
- Tự động migration dữ liệu từ SharedPreferences sang Hive
- Chạy một lần duy nhất khi khởi động app
- Backup và cleanup dữ liệu cũ

### 3. Cấu trúc cache mới

#### SharedPreferences (Settings only)
- `themeMode`: Theme của ứng dụng
- `language`: Ngôn ngữ hiện tại
- `generation_history_enabled`: Bật/tắt lưu lịch sử
- `hive_migration_completed`: Đánh dấu migration hoàn thành

#### Hive Box: templates
- Key: `templates`
- Value: List<String> (JSON serialized Template objects)

#### Hive Box: history
- Key pattern: `generation_history_{type}`
- Value: String (Encrypted JSON data)
- Types: password, number, date, time, color, etc.

## Migration Process

### Tự động Migration
Khi app khởi động lần đầu sau update:

1. **HiveService.initialize()**: Khởi tạo Hive boxes
2. **MigrationService.performMigrationIfNeeded()**: 
   - Kiểm tra flag `hive_migration_completed`
   - Nếu chưa migration: thực hiện chuyển đổi
   - Templates: Copy từ SharedPreferences sang Hive
   - History: Copy từ SharedPreferences sang Hive 
   - Đánh dấu migration completed
3. **MigrationService.cleanupOldData()**: Xóa dữ liệu cũ (optional)

### Manual Migration (Development)
```dart
// Reset migration để test lại
await MigrationService.resetMigration();

// Kiểm tra trạng thái migration
bool completed = await MigrationService.isMigrationCompleted();

// Force migration
await MigrationService.performMigrationIfNeeded();
```

## Hiệu suất và Lợi ích

### So sánh hiệu suất
- **SharedPreferences**: Sync I/O, chậm với dữ liệu lớn
- **Hive**: Async I/O, nhanh hơn 10-100x tùy theo kích thước data

### Lợi ích
1. **Tốc độ**: Đọc/ghi nhanh hơn đáng kể
2. **Bộ nhớ**: Sử dụng memory hiệu quả hơn
3. **Flexible**: Hỗ trợ complex data types
4. **Encryption**: Vẫn maintain security cho history data
5. **Backward compatibility**: Tự động migration, không mất dữ liệu

## API Changes

### Template Operations
```dart
// Không thay đổi - vẫn dùng TemplateService
await TemplateService.getTemplates();
await TemplateService.saveTemplate(template);
await TemplateService.deleteTemplate(id);
```

### History Operations  
```dart
// Không thay đổi - vẫn dùng GenerationHistoryService
await GenerationHistoryService.addHistoryItem(value, type);
await GenerationHistoryService.getHistory(type);
await GenerationHistoryService.clearHistory(type);
```

### Cache Management
```dart
// Không thay đổi - vẫn dùng CacheService  
await CacheService.clearCache('text_templates'); // Clears Hive
await CacheService.clearCache('settings'); // Clears SharedPreferences
await CacheService.clearAllCache(); // Clears both
```

## Testing

### Unit Tests
- Migration logic tests (cần environment setup)
- Service integration tests
- Cache operations tests

### Manual Testing
1. Install app với dữ liệu cũ
2. Update app với Hive migration
3. Verify data integrity
4. Test performance improvements

## Troubleshooting

### Migration Issues
- Check logs cho MigrationService errors
- Verify Hive initialization
- Fallback: Reset migration và retry

### Performance Issues  
- Monitor Hive box sizes
- Check async operations
- Optimize encryption/decryption

### Data Integrity
- Compare data before/after migration
- Test edge cases (empty data, corrupted data)
- Verify encryption compatibility

## Future Improvements

1. **Compression**: Add data compression cho large datasets
2. **Encryption**: Upgrade encryption algorithm
3. **Backup**: Implement backup/restore functionality
4. **Monitoring**: Add performance monitoring
5. **Cleanup**: Periodic cleanup of old cache data
