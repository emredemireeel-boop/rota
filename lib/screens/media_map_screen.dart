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

enum MemoryMapMode { turkey, world }

class MediaMapScreen extends StatefulWidget {
  final MemoryMapMode initialMode;

  const MediaMapScreen({super.key, this.initialMode = MemoryMapMode.turkey});

  @override
  State<MediaMapScreen> createState() => _MediaMapScreenState();
}

class _MediaMapScreenState extends State<MediaMapScreen> {
  late MemoryMapMode _mode;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
  }

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

  List<TravelMemory> _visibleMemories(List<TravelMemory> memories) {
    if (_mode == MemoryMapMode.world) return memories;
    return memories
        .where((memory) => memory.scope == MemoryScope.turkey)
        .toList();
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
    if (_mode == MemoryMapMode.world) {
      return const LatLng(20, 0);
    }
    if (places.isEmpty) return const LatLng(39, 35);
    final latitude =
        places.fold<double>(0, (sum, place) => sum + place.point.latitude) /
        places.length;
    final longitude =
        places.fold<double>(0, (sum, place) => sum + place.point.longitude) /
        places.length;
    return LatLng(latitude, longitude);
  }

  double _initialZoom(List<_MemoryPlace> places) {
    if (_mode == MemoryMapMode.world) return 2.15;
    if (places.isEmpty) return 5.2;
    if (places.length == 1) return 9;
    final latitudes = places.map((place) => place.point.latitude).toList();
    final longitudes = places.map((place) => place.point.longitude).toList();
    final span = [
      latitudes.reduce((a, b) => a > b ? a : b) -
          latitudes.reduce((a, b) => a < b ? a : b),
      longitudes.reduce((a, b) => a > b ? a : b) -
          longitudes.reduce((a, b) => a < b ? a : b),
    ].reduce((a, b) => a > b ? a : b);
    if (span > 15) return 4;
    if (span > 7) return 5;
    if (span > 3) return 6;
    return 7;
  }

  String get _title => _mode == MemoryMapMode.turkey
      ? 'Türkiye Anı Haritası'
      : 'Dünya Anı Haritası';

  String get _emptyMessage => _mode == MemoryMapMode.turkey
      ? 'Türkiye haritana ilk anını bırak'
      : 'Dünya haritana ilk anını bırak';

  Future<void> _add() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const MediaComposerScreen(),
      ),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medya haritadaki konumuna eklendi.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _openGeneralGallery() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LocationGalleryScreen(
          title: _mode == MemoryMapMode.turkey
              ? 'Türkiye Galerisi'
              : 'Dünya Galerisi',
          scope: _mode == MemoryMapMode.turkey ? MemoryScope.turkey : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: MemoryStore.instance,
        builder: (context, _) {
          final memories = _visibleMemories(MemoryStore.instance.memories);
          final places = _places(memories);
          final mapKey = [
            _mode.name,
            ...places.map((place) => '${place.key}:${place.memories.length}'),
          ].join('|');

          return Stack(
            children: [
              FlutterMap(
                key: ValueKey(mapKey),
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
                            width: 64,
                            height: 70,
                            alignment: Alignment.bottomCenter,
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
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            _MapIconButton(
                              icon: Icons.arrow_back_rounded,
                              tooltip: 'Geri',
                              onPressed: () => Navigator.pop(context),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: _floatingDecoration(
                                  const Color(0xFF183D3D),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '${places.length} konum • '
                                      '${memories.length} anı',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: Colors.white.withValues(
                                          alpha: 0.72,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _MapIconButton(
                              icon: Icons.grid_view_rounded,
                              tooltip: 'Genel galeri',
                              onPressed: _openGeneralGallery,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _MapModeSelector(
                          mode: _mode,
                          onChanged: (mode) => setState(() => _mode = mode),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (places.isEmpty)
                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: false,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(28, 170, 28, 110),
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
                              size: 42,
                              color: Color(0xFFB56D40),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _emptyMessage,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF183D3D),
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              _mode == MemoryMapMode.turkey
                                  ? 'Fotoğraf veya video ekle; il ve ilçe '
                                        'seçtiğinde burada yuvarlak olarak '
                                        'görünsün.'
                                  : 'Türkiye dahil herhangi bir ülkedeki '
                                        'fotoğraf ve videoların burada '
                                        'görünsün.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                height: 1.4,
                                color: const Color(0xFF667573),
                              ),
                            ),
                            const SizedBox(height: 14),
                            FilledButton.icon(
                              onPressed: _add,
                              icon: const Icon(Icons.add_a_photo_rounded),
                              label: const Text('Medya ekle'),
                            ),
                          ],
                        ),
                      ),
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
        onPressed: _add,
        icon: const Icon(Icons.add_a_photo_rounded),
        label: const Text('Fotoğraf / Video'),
      ),
    );
  }
}

BoxDecoration _floatingDecoration(Color color) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(18),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.2),
        blurRadius: 14,
        offset: const Offset(0, 5),
      ),
    ],
  );
}

class _MapIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _MapIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF183D3D),
        shadowColor: Colors.black.withValues(alpha: 0.2),
        elevation: 4,
      ),
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}

class _MapModeSelector extends StatelessWidget {
  final MemoryMapMode mode;
  final ValueChanged<MemoryMapMode> onChanged;

  const _MapModeSelector({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 46,
      constraints: const BoxConstraints(maxWidth: 330),
      padding: const EdgeInsets.all(4),
      decoration: _floatingDecoration(Colors.white.withValues(alpha: 0.96)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MapModeButton(
            label: 'Türkiye',
            icon: Icons.location_on_rounded,
            selected: mode == MemoryMapMode.turkey,
            onTap: () => onChanged(MemoryMapMode.turkey),
          ),
          _MapModeButton(
            label: 'Dünya',
            icon: Icons.public_rounded,
            selected: mode == MemoryMapMode.world,
            onTap: () => onChanged(MemoryMapMode.world),
          ),
        ],
      ),
    );
  }
}

class _MapModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _MapModeButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? const Color(0xFF183D3D) : Colors.transparent,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          borderRadius: BorderRadius.circular(13),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? Colors.white : const Color(0xFF506360),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : const Color(0xFF506360),
                ),
              ),
            ],
          ),
        ),
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
    return Semantics(
      button: true,
      label: '${memory.locationLabel}, ${place.memories.length} anı',
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
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
                  if (memory.isVideo)
                    const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.play_circle_fill_rounded,
                        color: Colors.white,
                        size: 24,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 6)],
                      ),
                    ),
                  if (place.memories.length > 1)
                    Positioned(
                      right: 1,
                      top: 1,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFB56D40),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${place.memories.length}',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            CustomPaint(size: const Size(16, 10), painter: _MarkerTipPainter()),
          ],
        ),
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
