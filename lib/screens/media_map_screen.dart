import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/turkey_data.dart';
import '../models/travel_memory.dart';
import '../services/memory_store.dart';
import '../widgets/memory_media.dart';
import 'location_gallery_screen.dart';
import 'media_composer_screen.dart';

class MediaMapScreen extends StatelessWidget {
  const MediaMapScreen({super.key});

  LatLng? _pointFor(TravelMemory memory) {
    if (memory.hasCoordinates) {
      return LatLng(memory.latitude!, memory.longitude!);
    }
    if (memory.provincePlate != null) {
      final province = turkeyProvinces.where(
        (item) => item.plateCode == memory.provincePlate,
      );
      if (province.isNotEmpty) {
        return LatLng(province.first.lat, province.first.lng);
      }
    }
    return null;
  }

  List<_MemoryPlace> _places(List<TravelMemory> memories) {
    final grouped = <String, List<TravelMemory>>{};
    for (final memory in memories) {
      if (_pointFor(memory) == null) continue;
      grouped.putIfAbsent(memory.locationKey, () => []).add(memory);
    }
    return grouped.entries
        .map(
          (entry) => _MemoryPlace(
            key: entry.key,
            point: _pointFor(entry.value.first)!,
            memories: entry.value,
          ),
        )
        .toList();
  }

  LatLng _initialCenter(List<_MemoryPlace> places) {
    if (places.isEmpty) return const LatLng(39.0, 35.0);
    final latitude =
        places.fold<double>(0, (sum, place) => sum + place.point.latitude) /
        places.length;
    final longitude =
        places.fold<double>(0, (sum, place) => sum + place.point.longitude) /
        places.length;
    return LatLng(latitude, longitude);
  }

  double _initialZoom(List<_MemoryPlace> places) {
    if (places.isEmpty) return 5.2;
    if (places.length == 1) return 8;
    final latitudes = places.map((place) => place.point.latitude).toList();
    final longitudes = places.map((place) => place.point.longitude).toList();
    final span = [
      latitudes.reduce((a, b) => a > b ? a : b) -
          latitudes.reduce((a, b) => a < b ? a : b),
      longitudes.reduce((a, b) => a > b ? a : b) -
          longitudes.reduce((a, b) => a < b ? a : b),
    ].reduce((a, b) => a > b ? a : b);
    if (span > 60) return 2.2;
    if (span > 30) return 3;
    if (span > 15) return 4;
    if (span > 7) return 5;
    return 6;
  }

  Future<void> _add(BuildContext context) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const MediaComposerScreen(),
      ),
    );
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medya haritadaki konumuna eklendi.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: MemoryStore.instance,
        builder: (context, _) {
          final memories = MemoryStore.instance.memories;
          final places = _places(memories);
          return Stack(
            children: [
              FlutterMap(
                key: ValueKey(places.map((place) => place.key).join('|')),
                options: MapOptions(
                  initialCenter: _initialCenter(places),
                  initialZoom: _initialZoom(places),
                  minZoom: 2,
                  maxZoom: 18,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.pudinglabs.rotaturkiye',
                  ),
                  MarkerLayer(
                    markers: places
                        .map(
                          (place) => Marker(
                            point: place.point,
                            width: 74,
                            height: 84,
                            alignment: Alignment.topCenter,
                            child: _MapMemoryMarker(
                              place: place,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LocationGalleryScreen(
                                      locationKey: place.key,
                                      title: place.memories.first.locationLabel,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap katkıcıları',
                        onTap: () => launchUrl(
                          Uri.parse('https://www.openstreetmap.org/copyright'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                  child: Row(
                    children: [
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF183D3D),
                        ),
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF183D3D),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Medya Haritam',
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${places.length} konum • ${memories.length} anı',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.68),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 9),
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF183D3D),
                        ),
                        tooltip: 'Genel galeri',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LocationGalleryScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.grid_view_rounded),
                      ),
                    ],
                  ),
                ),
              ),
              if (places.isEmpty)
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 28),
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.96),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.add_location_alt_rounded,
                          size: 44,
                          color: Color(0xFFB56D40),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Haritana ilk anını bırak',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF183D3D),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          'Fotoğraf veya video ekle; ülke, il ve ilçe seçerek haritadaki yerine sabitle.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            height: 1.45,
                            color: const Color(0xFF667573),
                          ),
                        ),
                        const SizedBox(height: 14),
                        FilledButton.icon(
                          onPressed: () => _add(context),
                          icon: const Icon(Icons.add_a_photo_rounded),
                          label: const Text('Medya ekle'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF183D3D),
        foregroundColor: Colors.white,
        onPressed: () => _add(context),
        icon: const Icon(Icons.add_a_photo_rounded),
        label: const Text('Fotoğraf / Video'),
      ),
    );
  }
}

class _MemoryPlace {
  final String key;
  final LatLng point;
  final List<TravelMemory> memories;

  const _MemoryPlace({
    required this.key,
    required this.point,
    required this.memories,
  });
}

class _MapMemoryMarker extends StatelessWidget {
  final _MemoryPlace place;
  final VoidCallback onTap;

  const _MapMemoryMarker({required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final memory = place.memories.first;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF183D3D), width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.24),
                  blurRadius: 9,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                MemoryMediaThumbnail(memory: memory),
                if (place.memories.length > 1)
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Color(0xFFB56D40),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${place.memories.length}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          CustomPaint(size: const Size(18, 12), painter: _MarkerTipPainter()),
        ],
      ),
    );
  }
}

class _MarkerTipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFF183D3D));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
