import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/services/cache_service.dart';

// Provider for cache information
class CacheNotifier extends StateNotifier<String> {
  CacheNotifier() : super('Calculating...') {
    _loadCacheInfo();
  }

  Future<void> _loadCacheInfo() async {
    try {
      final totalSize = await CacheService.getTotalCacheSize();
      if (mounted) {
        state = CacheService.formatCacheSize(totalSize);
      }
    } catch (e) {
      if (mounted) {
        state = 'Error loading cache info';
      }
    }
  }

  Future<void> clearCache(String confirmationText) async {
    await CacheService.clearCache(confirmationText);
    await _loadCacheInfo();
  }

  Future<void> refreshCacheInfo() async {
    await _loadCacheInfo();
  }
}

// Provider instance
final cacheProvider = StateNotifierProvider<CacheNotifier, String>((ref) {
  return CacheNotifier();
});
