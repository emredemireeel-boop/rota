import 'dart:convert';
import 'dart:typed_data';

enum MemoryScope { turkey, world }

enum TravelMediaType { image, video }

class TravelMemory {
  final String id;
  final MemoryScope scope;
  final String title;
  final String note;
  final DateTime capturedAt;
  final String imageBase64;
  final String mediaPath;
  final TravelMediaType mediaType;
  final String mood;
  final bool isFavorite;
  final double? latitude;
  final double? longitude;
  final int? provincePlate;
  final String? provinceName;
  final String? districtName;
  final String? countryCode;
  final String? countryName;
  final String? regionName;

  const TravelMemory({
    required this.id,
    required this.scope,
    required this.title,
    required this.note,
    required this.capturedAt,
    this.imageBase64 = '',
    this.mediaPath = '',
    this.mediaType = TravelMediaType.image,
    required this.mood,
    this.isFavorite = false,
    this.latitude,
    this.longitude,
    this.provincePlate,
    this.provinceName,
    this.districtName,
    this.countryCode,
    this.countryName,
    this.regionName,
  });

  Uint8List get imageBytes => base64Decode(imageBase64);
  bool get hasCoordinates => latitude != null && longitude != null;
  bool get isVideo => mediaType == TravelMediaType.video;

  String get locationKey {
    if (scope == MemoryScope.turkey) {
      return 'TR:${provincePlate ?? 0}:${districtName ?? 'Genel'}';
    }
    return '${countryCode ?? 'WORLD'}:${regionName ?? 'Genel'}';
  }

  String get locationLabel {
    if (scope == MemoryScope.turkey) {
      final district = districtName == null || districtName == 'Genel'
          ? null
          : districtName;
      return [district, provinceName].whereType<String>().join(', ');
    }
    final region = regionName == null || regionName == 'Genel'
        ? null
        : regionName;
    return [region, countryName].whereType<String>().join(', ');
  }

  TravelMemory copyWith({bool? isFavorite}) {
    return TravelMemory(
      id: id,
      scope: scope,
      title: title,
      note: note,
      capturedAt: capturedAt,
      imageBase64: imageBase64,
      mediaPath: mediaPath,
      mediaType: mediaType,
      mood: mood,
      isFavorite: isFavorite ?? this.isFavorite,
      latitude: latitude,
      longitude: longitude,
      provincePlate: provincePlate,
      provinceName: provinceName,
      districtName: districtName,
      countryCode: countryCode,
      countryName: countryName,
      regionName: regionName,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'scope': scope.name,
    'title': title,
    'note': note,
    'capturedAt': capturedAt.toIso8601String(),
    'imageBase64': imageBase64,
    'mediaPath': mediaPath,
    'mediaType': mediaType.name,
    'mood': mood,
    'isFavorite': isFavorite,
    'latitude': latitude,
    'longitude': longitude,
    'provincePlate': provincePlate,
    'provinceName': provinceName,
    'districtName': districtName,
    'countryCode': countryCode,
    'countryName': countryName,
    'regionName': regionName,
  };

  factory TravelMemory.fromJson(Map<String, dynamic> json) {
    return TravelMemory(
      id: json['id'] as String,
      scope: json['scope'] == MemoryScope.world.name
          ? MemoryScope.world
          : MemoryScope.turkey,
      title: json['title'] as String? ?? '',
      note: json['note'] as String? ?? '',
      capturedAt:
          DateTime.tryParse(json['capturedAt'] as String? ?? '') ??
          DateTime.now(),
      imageBase64: json['imageBase64'] as String? ?? '',
      mediaPath: json['mediaPath'] as String? ?? '',
      mediaType: json['mediaType'] == TravelMediaType.video.name
          ? TravelMediaType.video
          : TravelMediaType.image,
      mood: json['mood'] as String? ?? 'Mutlu',
      isFavorite: json['isFavorite'] as bool? ?? false,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      provincePlate: json['provincePlate'] as int?,
      provinceName: json['provinceName'] as String?,
      districtName: json['districtName'] as String?,
      countryCode: json['countryCode'] as String?,
      countryName: json['countryName'] as String?,
      regionName: json['regionName'] as String?,
    );
  }
}
