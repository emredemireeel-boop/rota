import 'travel_memory.dart';

class MemoryLocation {
  final MemoryScope scope;
  final int? provincePlate;
  final String? provinceName;
  final String? districtName;
  final String? countryCode;
  final String? countryName;
  final String? regionName;

  const MemoryLocation.turkey({
    required int plateCode,
    required String province,
    required String district,
  }) : scope = MemoryScope.turkey,
       provincePlate = plateCode,
       provinceName = province,
       districtName = district,
       countryCode = 'TR',
       countryName = 'Türkiye',
       regionName = null;

  const MemoryLocation.world({
    required this.countryCode,
    required String country,
    required String region,
  }) : scope = MemoryScope.world,
       provincePlate = null,
       provinceName = null,
       districtName = null,
       countryName = country,
       regionName = region;

  String get label {
    if (scope == MemoryScope.turkey) {
      return districtName == 'Genel'
          ? provinceName!
          : '$districtName, $provinceName';
    }
    return regionName == 'Genel' ? countryName! : '$regionName, $countryName';
  }
}
