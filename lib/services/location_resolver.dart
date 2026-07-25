import 'package:geocoding/geocoding.dart';

import '../data/turkey_data.dart';

class ResolvedCoordinates {
  final double latitude;
  final double longitude;

  const ResolvedCoordinates(this.latitude, this.longitude);
}

class LocationResolver {
  const LocationResolver._();

  static Future<ResolvedCoordinates> resolve({
    required String countryName,
    String? provinceName,
    String? districtName,
  }) async {
    final query = countryName == 'Türkiye'
        ? '$districtName, $provinceName, Türkiye'
        : countryName;

    try {
      final geocoding = Geocoding();
      final results = await geocoding.locationFromAddress(query);
      if (results.isNotEmpty) {
        return ResolvedCoordinates(
          results.first.latitude,
          results.first.longitude,
        );
      }
    } catch (_) {
      // Yerel servis sonuç vermezse aşağıdaki güvenli merkez kullanılır.
    }

    if (countryName == 'Türkiye' && provinceName != null) {
      final province = turkeyProvinces.where(
        (item) => item.name == provinceName,
      );
      if (province.isNotEmpty) {
        return ResolvedCoordinates(province.first.lat, province.first.lng);
      }
    }

    return const ResolvedCoordinates(20, 0);
  }
}
