import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/travel_memory.dart';
import '../services/gallery_download_service.dart';
import '../services/memory_store.dart';
import '../widgets/memory_media.dart';

class LocationGalleryScreen extends StatefulWidget {
  final String? locationKey;
  final String? title;
  final MemoryScope? scope;

  const LocationGalleryScreen({
    super.key,
    this.locationKey,
    this.title,
    this.scope,
  });

  @override
  State<LocationGalleryScreen> createState() => _LocationGalleryScreenState();
}

class _LocationGalleryScreenState extends State<LocationGalleryScreen> {
  bool _downloading = false;

  List<TravelMemory> _memories(MemoryStore store) {
    final memories = widget.locationKey == null
        ? store.memories
        : store.forLocation(widget.locationKey!);
    if (widget.scope == null) return memories;
    return memories.where((memory) => memory.scope == widget.scope).toList();
  }

  Future<void> _downloadOne(TravelMemory memory) async {
    try {
      await GalleryDownloadService.save(memory);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medya cihaz galerisine kaydedildi.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Galeriye kaydetmek için izin verilmesi gerekiyor.'),
        ),
      );
    }
  }

  Future<void> _downloadAll(List<TravelMemory> memories) async {
    if (memories.isEmpty || _downloading) return;
    setState(() => _downloading = true);
    try {
      final count = await GalleryDownloadService.saveAll(memories);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$count medya “Rota” albümüne indirildi.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Bazı medyalar indirilemedi. Galeri iznini kontrol et.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF183D3D),
        foregroundColor: Colors.white,
        title: Text(widget.title ?? 'Genel Galeri'),
        actions: [
          AnimatedBuilder(
            animation: MemoryStore.instance,
            builder: (context, _) {
              final memories = _memories(MemoryStore.instance);
              return IconButton(
                tooltip: 'Galerinin tamamını indir',
                onPressed: _downloading || memories.isEmpty
                    ? null
                    : () => _downloadAll(memories),
                icon: _downloading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.download_for_offline_rounded),
              );
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: MemoryStore.instance,
        builder: (context, _) {
          final memories = _memories(MemoryStore.instance);
          if (memories.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Bu konumda henüz fotoğraf veya video yok.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 13),
                color: const Color(0xFF183D3D),
                child: Text(
                  '${memories.length} medya • Bir karta dokunarak aç',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: memories.length,
                  itemBuilder: (context, index) {
                    final memory = memories[index];
                    return _GalleryCard(
                      memory: memory,
                      onOpen: () => showMemoryMediaViewer(context, memory),
                      onDownload: () => _downloadOne(memory),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GalleryCard extends StatelessWidget {
  final TravelMemory memory;
  final VoidCallback onOpen;
  final VoidCallback onDownload;

  const _GalleryCard({
    required this.memory,
    required this.onOpen,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MemoryMediaThumbnail(memory: memory),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: 0.52),
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                      ),
                      tooltip: 'Cihaz galerisine indir',
                      onPressed: onDownload,
                      icon: const Icon(Icons.download_rounded, size: 19),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.52),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        memory.isVideo
                            ? Icons.videocam_rounded
                            : Icons.photo_camera_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memory.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF243432),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    memory.locationLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF7A8584),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
