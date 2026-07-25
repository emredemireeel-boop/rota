import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rota/data/aegean_routes_data.dart';
import 'package:rota/data/turkey_data.dart';
import 'package:rota/models/travel_memory.dart';

void main() {
  test('81 ilin tamamında ilçe verisi bulunur', () {
    expect(turkeyProvinces.length, 81);
    expect(
      turkeyProvinces.where((province) => province.districts.isEmpty),
      isEmpty,
    );
  });

  test('Ege illerinin tamamında yakın plan rotası bulunur', () {
    final aegeanPlates = turkeyProvinces
        .where((province) => province.region == 'Ege')
        .map((province) => province.plateCode)
        .toSet();

    expect(aegeanRoutes.keys.toSet(), containsAll(aegeanPlates));
    expect(
      aegeanRoutes.values.expand((routes) => routes).length,
      greaterThanOrEqualTo(16),
    );
  });

  test('fotoğraflı anı kalıcı veriye dönüşüp geri okunur', () {
    final memory = TravelMemory(
      id: 'test-memory',
      scope: MemoryScope.turkey,
      title: 'Sığacık sabahı',
      note: 'Kale içinde sakin bir yürüyüş.',
      capturedAt: DateTime(2026, 7, 25),
      imageBase64: base64Encode([1, 2, 3]),
      mediaType: TravelMediaType.image,
      mood: 'Huzurlu',
      latitude: 38.197,
      longitude: 26.838,
      provincePlate: 35,
      provinceName: 'İzmir',
      districtName: 'Seferihisar',
    );

    final restored = TravelMemory.fromJson(memory.toJson());

    expect(restored.title, memory.title);
    expect(restored.locationLabel, 'Seferihisar, İzmir');
    expect(restored.imageBytes, [1, 2, 3]);
    expect(restored.hasCoordinates, isTrue);
    expect(restored.locationKey, 'TR:35:Seferihisar');
  });

  test('video anısı ülke konumuyla saklanır', () {
    final memory = TravelMemory(
      id: 'video-memory',
      scope: MemoryScope.world,
      title: 'Roma sokakları',
      note: '',
      capturedAt: DateTime(2026, 7, 25),
      mediaPath: '/rota_media/roma.mp4',
      mediaType: TravelMediaType.video,
      mood: 'Heyecanlı',
      latitude: 41.9028,
      longitude: 12.4964,
      countryCode: 'IT',
      countryName: 'İtalya',
      regionName: 'Genel',
    );

    final restored = TravelMemory.fromJson(memory.toJson());

    expect(restored.isVideo, isTrue);
    expect(restored.locationLabel, 'İtalya');
    expect(restored.locationKey, 'IT:Genel');
  });
}
