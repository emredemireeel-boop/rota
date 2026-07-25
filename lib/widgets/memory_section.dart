import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/travel_memory.dart';
import '../services/memory_store.dart';
import '../screens/memories_screen.dart';
import 'memory_media.dart';

class MemorySection extends StatelessWidget {
  final List<TravelMemory> memories;
  final Color accentColor;
  final String title;
  final VoidCallback onAdd;

  const MemorySection({
    super.key,
    required this.memories,
    required this.accentColor,
    required this.title,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF183D3D),
            const Color(0xFF244D49),
            accentColor.withValues(alpha: 0.86),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF183D3D).withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.photo_camera_back_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      memories.isEmpty
                          ? 'Bu yere ilk hatıranı bırak'
                          : '${memories.length} fotoğraf / video',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF183D3D),
                ),
                onPressed: onAdd,
                tooltip: 'Yeni anı ekle',
                icon: const Icon(Icons.add_a_photo_rounded),
              ),
            ],
          ),
          if (memories.isEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Fotoğrafını veya videonu ekle, o anki hissini yaz. Yıllar sonra bu rota seni aynı güne geri götürsün.',
              style: GoogleFonts.inter(
                fontSize: 13,
                height: 1.5,
                color: Colors.white.withValues(alpha: 0.82),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF183D3D),
                ),
                onPressed: onAdd,
                icon: const Icon(Icons.camera_alt_rounded),
                label: const Text('Bu anı kaydet'),
              ),
            ),
          ] else ...[
            const SizedBox(height: 14),
            SizedBox(
              height: 154,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: memories.take(8).length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final memory = memories[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: Stack(
                      children: [
                        MemoryMediaThumbnail(
                          memory: memory,
                          width: 128,
                          height: 154,
                        ),
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.72),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          right: 8,
                          bottom: 9,
                          child: Text(
                            memory.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (memory.isFavorite)
                          const Positioned(
                            top: 8,
                            right: 8,
                            child: Icon(
                              Icons.star_rounded,
                              size: 18,
                              color: Color(0xFFFFD166),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MemoriesScreen()),
                );
              },
              icon: const Icon(Icons.history_rounded, size: 18),
              label: const Text('Tüm geçmişi gör'),
            ),
          ],
        ],
      ),
    );
  }
}

class MemorySectionBuilder extends StatelessWidget {
  final Color accentColor;
  final String title;
  final List<TravelMemory> Function(MemoryStore store) memories;
  final VoidCallback onAdd;

  const MemorySectionBuilder({
    super.key,
    required this.accentColor,
    required this.title,
    required this.memories,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: MemoryStore.instance,
      builder: (context, _) => MemorySection(
        memories: memories(MemoryStore.instance),
        accentColor: accentColor,
        title: title,
        onAdd: onAdd,
      ),
    );
  }
}
