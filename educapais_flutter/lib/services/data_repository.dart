import '../models/school_data.dart';
import 'api_service.dart';
import 'storage_service.dart';

enum DataOrigin { network, cache }

class LoadResult {
  LoadResult({required this.data, required this.origin, this.cacheDate});

  final EducaPaisData data;
  final DataOrigin origin;
  final DateTime? cacheDate;
}

class DataRepository {
  DataRepository({
    required ApiService apiService,
    required StorageService storageService,
  }) : _apiService = apiService,
       _storageService = storageService;

  final ApiService _apiService;
  final StorageService _storageService;

  Future<LoadResult> loadData() async {
    try {
      final payload = await _apiService.fetchPayload();
      final data = EducaPaisData.fromRawJson(payload);
      await _storageService.savePayload(payload);
      return LoadResult(
        data: data,
        origin: DataOrigin.network,
        cacheDate: DateTime.now(),
      );
    } catch (_) {
      final cachedPayload = await _storageService.readPayload();
      if (cachedPayload == null || cachedPayload.isEmpty) {
        rethrow;
      }
      final data = EducaPaisData.fromRawJson(cachedPayload);
      return LoadResult(
        data: data,
        origin: DataOrigin.cache,
        cacheDate: await _storageService.readCacheDate(),
      );
    }
  }
}
