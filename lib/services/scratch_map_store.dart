import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScratchMapStore extends ChangeNotifier {
  ScratchMapStore._();

  static final ScratchMapStore instance = ScratchMapStore._();
  static const _provinceStorageKey = 'rota_scratched_provinces_v1';
  static const _countryStorageKey = 'rota_scratched_countries_v1';
  static const _hiddenProvinceStorageKey = 'rota_hidden_scratched_provinces_v1';
  static const _hiddenCountryStorageKey = 'rota_hidden_scratched_countries_v1';

  final Set<int> _provincePlates = {};
  final Set<String> _countryCodes = {};
  final Set<int> _hiddenProvincePlates = {};
  final Set<String> _hiddenCountryCodes = {};
  bool _initialized = false;

  Set<int> get provincePlates => Set.unmodifiable(_provincePlates);
  Set<String> get countryCodes => Set.unmodifiable(_countryCodes);
  Set<int> get hiddenProvincePlates => Set.unmodifiable(_hiddenProvincePlates);
  Set<String> get hiddenCountryCodes => Set.unmodifiable(_hiddenCountryCodes);
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
      _hiddenProvincePlates
        ..clear()
        ..addAll(
          (preferences.getStringList(_hiddenProvinceStorageKey) ?? const [])
              .map(int.tryParse)
              .whereType<int>()
              .where((plate) => plate >= 1 && plate <= 81),
        );
      _hiddenCountryCodes
        ..clear()
        ..addAll(
          (preferences.getStringList(_hiddenCountryStorageKey) ?? const [])
              .map((code) => code.trim().toUpperCase())
              .where((code) => code.isNotEmpty),
        );
    } catch (error) {
      debugPrint('Gez Kazı verileri yüklenemedi: $error');
    }
    _initialized = true;
    notifyListeners();
  }

  Future<bool> scratchProvince(int plateCode) async {
    if (plateCode < 1 || plateCode > 81) return false;
    final wasHidden = _hiddenProvincePlates.remove(plateCode);
    final changed = _provincePlates.add(plateCode) || wasHidden;
    if (!changed) return false;
    notifyListeners();
    await Future.wait([_saveProvinces(), _saveHiddenProvinces()]);
    return true;
  }

  Future<bool> scratchCountry(String countryCode) async {
    final normalized = countryCode.trim().toUpperCase();
    if (normalized.isEmpty) return false;
    final wasHidden = _hiddenCountryCodes.remove(normalized);
    final changed = _countryCodes.add(normalized) || wasHidden;
    if (!changed) return false;
    notifyListeners();
    await Future.wait([_saveCountries(), _saveHiddenCountries()]);
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

  Future<void> unvisitProvince(int plateCode) async {
    if (plateCode < 1 || plateCode > 81) return;
    final removed = _provincePlates.remove(plateCode);
    final hidden = _hiddenProvincePlates.add(plateCode);
    if (!removed && !hidden) return;
    notifyListeners();
    await Future.wait([_saveProvinces(), _saveHiddenProvinces()]);
  }

  Future<void> unvisitCountry(String countryCode) async {
    final normalized = countryCode.trim().toUpperCase();
    if (normalized.isEmpty) return;
    final removed = _countryCodes.remove(normalized);
    final hidden = _hiddenCountryCodes.add(normalized);
    if (!removed && !hidden) return;
    notifyListeners();
    await Future.wait([_saveCountries(), _saveHiddenCountries()]);
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

  Future<void> _saveHiddenProvinces() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final values = _hiddenProvincePlates.map((plate) => '$plate').toList()
        ..sort();
      await preferences.setStringList(_hiddenProvinceStorageKey, values);
    } catch (error) {
      debugPrint('Geri alınan iller kaydedilemedi: $error');
    }
  }

  Future<void> _saveHiddenCountries() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final values = _hiddenCountryCodes.toList()..sort();
      await preferences.setStringList(_hiddenCountryStorageKey, values);
    } catch (error) {
      debugPrint('Geri alınan ülkeler kaydedilemedi: $error');
    }
  }
}
