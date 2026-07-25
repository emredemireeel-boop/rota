import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/travel_memory.dart';
import 'media_storage.dart';

class MemoryStore extends ChangeNotifier {
  MemoryStore._();

  static final MemoryStore instance = MemoryStore._();
  static const _storageKey = 'rota_travel_memories_v1';

  final List<TravelMemory> _memories = [];
  bool _initialized = false;

  List<TravelMemory> get memories => List.unmodifiable(_memories);
  bool get initialized => _initialized;
  int get turkeyCount =>
      _memories.where((m) => m.scope == MemoryScope.turkey).length;
  int get worldCount =>
      _memories.where((m) => m.scope == MemoryScope.world).length;
  int get favoriteCount => _memories.where((m) => m.isFavorite).length;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      final preferences = await SharedPreferences.getInstance();
      final raw = preferences.getString(_storageKey);
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        _memories
          ..clear()
          ..addAll(
            decoded.whereType<Map<String, dynamic>>().map(
              TravelMemory.fromJson,
            ),
          );
        _sort();
      }
    } catch (error) {
      debugPrint('Anılar yüklenemedi: $error');
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> add(TravelMemory memory) async {
    _memories.add(memory);
    _sort();
    notifyListeners();
    await _save();
  }

  Future<void> delete(String id) async {
    final index = _memories.indexWhere((memory) => memory.id == id);
    if (index == -1) return;
    final memory = _memories.removeAt(index);
    notifyListeners();
    await _save();
    await MediaStorage.remove(memory.mediaPath);
  }

  List<TravelMemory> forLocation(String locationKey) =>
      _memories.where((memory) => memory.locationKey == locationKey).toList();

  Future<void> toggleFavorite(String id) async {
    final index = _memories.indexWhere((memory) => memory.id == id);
    if (index == -1) return;
    _memories[index] = _memories[index].copyWith(
      isFavorite: !_memories[index].isFavorite,
    );
    notifyListeners();
    await _save();
  }

  List<TravelMemory> forProvince(int plateCode, {String? district}) {
    return _memories.where((memory) {
      if (memory.provincePlate != plateCode) return false;
      if (district == null || district == 'Genel') return true;
      return memory.districtName == district;
    }).toList();
  }

  List<TravelMemory> forCountry(String countryCode, {String? region}) {
    return _memories.where((memory) {
      if (memory.countryCode != countryCode) return false;
      if (region == null || region == 'Genel') return true;
      return memory.regionName == region;
    }).toList();
  }

  Set<int> get visitedProvincePlates => _memories
      .where((m) => m.provincePlate != null)
      .map((m) => m.provincePlate!)
      .toSet();

  Set<String> get visitedDistrictKeys => _memories
      .where((m) => m.provincePlate != null && m.districtName != null)
      .map((m) => '${m.provincePlate}:${m.districtName}')
      .toSet();

  Set<String> get visitedCountryCodes => _memories
      .where((m) => m.countryCode != null)
      .map((m) => m.countryCode!)
      .toSet();

  void _sort() {
    _memories.sort((a, b) => b.capturedAt.compareTo(a.capturedAt));
  }

  Future<void> _save() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final value = jsonEncode(_memories.map((m) => m.toJson()).toList());
      await preferences.setString(_storageKey, value);
    } catch (error) {
      debugPrint('Anılar kaydedilemedi: $error');
    }
  }
}
