import 'package:gal/gal.dart';

import '../models/travel_memory.dart';

class GalleryDownloadService {
  const GalleryDownloadService._();

  static Future<void> save(TravelMemory memory) async {
    var hasAccess = await Gal.hasAccess(toAlbum: true);
    if (!hasAccess) {
      hasAccess = await Gal.requestAccess(toAlbum: true);
    }
    if (!hasAccess) {
      throw StateError('Galeri izni verilmedi.');
    }

    if (memory.isVideo) {
      if (memory.mediaPath.isEmpty) {
        throw StateError('Video dosyası bulunamadı.');
      }
      await Gal.putVideo(memory.mediaPath, album: 'Rota');
      return;
    }

    if (memory.mediaPath.isNotEmpty) {
      await Gal.putImage(memory.mediaPath, album: 'Rota');
    } else if (memory.imageBase64.isNotEmpty) {
      await Gal.putImageBytes(
        memory.imageBytes,
        album: 'Rota',
        name: 'rota_${memory.id}',
      );
    } else {
      throw StateError('Fotoğraf dosyası bulunamadı.');
    }
  }

  static Future<int> saveAll(Iterable<TravelMemory> memories) async {
    var saved = 0;
    for (final memory in memories) {
      await save(memory);
      saved++;
    }
    return saved;
  }
}
