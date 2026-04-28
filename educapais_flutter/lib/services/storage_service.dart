import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _cachePayloadKey = 'educapais_payload_cache';
  static const _cacheDateKey = 'educapais_payload_cache_date';

  Future<void> savePayload(String payload) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cachePayloadKey, payload);
    await prefs.setString(_cacheDateKey, DateTime.now().toIso8601String());
  }

  Future<String?> readPayload() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cachePayloadKey);
  }

  Future<DateTime?> readCacheDate() async {
    final prefs = await SharedPreferences.getInstance();
    final iso = prefs.getString(_cacheDateKey);
    if (iso == null || iso.isEmpty) {
      return null;
    }
    return DateTime.tryParse(iso);
  }
}
