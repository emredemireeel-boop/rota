import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../models/travel_memory.dart';

class MediaStorage {
  const MediaStorage._();

  static Future<String> persist(XFile source, TravelMediaType mediaType) async {
    final documents = await getApplicationDocumentsDirectory();
    final mediaDirectory = Directory('${documents.path}/rota_media');
    if (!await mediaDirectory.exists()) {
      await mediaDirectory.create(recursive: true);
    }

    final extension = _extension(
      source.name.isNotEmpty ? source.name : source.path,
      mediaType,
    );
    final fileName = 'rota_${DateTime.now().microsecondsSinceEpoch}.$extension';
    final destination = '${mediaDirectory.path}/$fileName';
    await source.saveTo(destination);
    return destination;
  }

  static Future<void> remove(String path) async {
    if (path.isEmpty) return;
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static String _extension(String name, TravelMediaType mediaType) {
    final dot = name.lastIndexOf('.');
    if (dot != -1 && dot < name.length - 1) {
      final value = name.substring(dot + 1).toLowerCase();
      if (RegExp(r'^[a-z0-9]{2,5}$').hasMatch(value)) return value;
    }
    return mediaType == TravelMediaType.video ? 'mp4' : 'jpg';
  }
}
