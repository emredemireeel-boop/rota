import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScratchMapStore extends ChangeNotifier {
  ScratchMapStore._();

  static final ScratchMapStore instance = ScratchMapStore._();
  static const _provinceStorageKey = 'rota_scratched_provinces_v1';
  static const _countryStorageKey = 'rota_scratched_countries_v1';

  final Set<int> _provincePlates = {};
  final Set<String> _countryCodes = {};
  bool _initialized = false;

  Set<int> get provincePlates => Set.unmodifiable(_provincePlates);
  Set<String> get countryCodes => Set.unmodifiable(_countryCodes);
  bool get initialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      final preferences = await SharedPreferences.getInstance();
      _provincePlates
        ..clear()
        ..addAll(
          (preferences.getStringList(_provinceStorageKey) ?? const [])
              .map(int.tryParse)
              .whereType<int>()
              .where((plate) => plate >= 1 && plate <= 81),
        );
      _countryCodes
        ..clear()
        ..addAll(
          (preferences.getStringList(_countryStorageKey) ?? const [])
              .map((code) => code.trim().toUpperCase())
              .where((code) => code.isNotEmpty),
        );
    } catch (error) {
      debugPrint('Gez Kazan verileri yüklenemedi: $error');
    }
    _initialized = true;
    notifyListeners();
  }

  Future<bool> scratchProvince(int plateCode) async {
    if (plateCode < 1 || plateCode > 81) return false;
    final changed = _provincePlates.add(plateCode);
    if (!changed) return false;
    notifyListeners();
    await _saveProvinces();
    return true;
  }

  Future<bool> scratchCountry(String countryCode) async {
    final normalized = countryCode.trim().toUpperCase();
    if (normalized.isEmpty) return false;
    final changed = _countryCodes.add(normalized);
    if (!changed) return false;
    notifyListeners();
    await _saveCountries();
    return true;
  }

  Future<void> removeProvince(int plateCode) async {
    if (!_provincePlates.remove(plateCode)) return;
    notifyListeners();
    await _saveProvinces();
  }

  Future<void> removeCountry(String countryCode) async {
    final normalized = countryCode.trim().toUpperCase();
    if (!_countryCodes.remove(normalized)) return;
    notifyListeners();
    await _saveCountries();
  }

  Future<void> _saveProvinces() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final values = _provincePlates.map((plate) => '$plate').toList()..sort();
      await preferences.setStringList(_provinceStorageKey, values);
    } catch (error) {
      debugPrint('Kazınan iller kaydedilemedi: $error');
    }
  }

  Future<void> _saveCountries() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final values = _countryCodes.toList()..sort();
      await preferences.setStringList(_countryStorageKey, values);
    } catch (error) {
      debugPrint('Kazınan ülkeler kaydedilemedi: $error');
    }
  }
}
