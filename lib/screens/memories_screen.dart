import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/travel_memory.dart';
import '../services/memory_store.dart';
import '../widgets/memory_media.dart';

enum _MemoryFilter { all, turkey, world, favorites }

class MemoriesScreen extends StatefulWidget {
  const MemoriesScreen({super.key});

  @override
  State<MemoriesScreen> createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends State<MemoriesScreen> {
  _MemoryFilter _filter = _MemoryFilter.all;

  List<TravelMemory> _filtered(List<TravelMemory> memories) {
    return switch (_filter) {
      _MemoryFilter.all => memories,
      _MemoryFilter.turkey =>
        memories.where((m) => m.scope == MemoryScope.turkey).toList(),
      _MemoryFilter.world =>
        memories.where((m) => m.scope == MemoryScope.world).toList(),
      _MemoryFilter.favorites => memories.where((m) => m.isFavorite).toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final store = MemoryStore.instance;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EA),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final memories = _filtered(store.memories);
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 238,
                pinned: true,
                backgroundColor: const Color(0xFF183D3D),
                foregroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: const EdgeInsets.fromLTRB(22, 88, 22, 22),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF102E2E),
                          Color(0xFF1E5B56),
                          Color(0xFFB56D40),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Anı Atlasım',
                          style: GoogleFonts.outfit(
                            fontSize: 34,
                            height: 1,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Gittiğin yerler, çektiğin kareler,\nsenin hikâyen.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            height: 1.45,
                            color: Colors.white.withValues(alpha: 0.78),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            _HeroStat(
                              value: '${store.memories.length}',
                              label: 'anı',
                            ),
                            _HeroStat(
                              value: '${store.visitedDistrictKeys.length}',
                              label: 'ilçe',
                            ),
                            _HeroStat(
                              value: '${store.visitedCountryCodes.length}',
                              label: 'ülke',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 62,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                    children: [
                      _filterChip(_MemoryFilter.all, 'Tümü'),
                      _filterChip(_MemoryFilter.turkey, 'Türkiye'),
                      _filterChip(_MemoryFilter.world, 'Dünya'),
                      _filterChip(_MemoryFilter.favorites, 'Favoriler'),
                    ],
                  ),
                ),
              ),
              if (memories.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyMemories(filter: _filter),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 36),
                  sliver: SliverList.builder(
                    itemCount: memories.length,
                    itemBuilder: (context, index) {
                      final memory = memories[index];
                      final showYear =
                          index == 0 ||
                          memories[index - 1].capturedAt.year !=
                              memory.capturedAt.year;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showYear)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 16, 4, 10),
                              child: Text(
                                '${memory.capturedAt.year}',
                                style: GoogleFonts.outfit(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF183D3D),
                                ),
                              ),
                            ),
                          _MemoryTimelineCard(memory: memory),
                        ],
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

  Widget _filterChip(_MemoryFilter filter, String label) {
    final selected = filter == _filter;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        selectedColor: const Color(0xFF183D3D),
        backgroundColor: Colors.white,
        side: BorderSide(
          color: selected ? Colors.transparent : const Color(0xFFD8D3C9),
        ),
        labelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : const Color(0xFF5F625F),
        ),
        onSelected: (_) => setState(() => _filter = filter),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String value;
  final String label;

  const _HeroStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: value,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: ' $label',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyMemories extends StatelessWidget {
  final _MemoryFilter filter;

  const _EmptyMemories({required this.filter});

  @override
  Widget build(BuildContext context) {
    final favorites = filter == _MemoryFilter.favorites;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: const Color(0xFF183D3D).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                favorites
                    ? Icons.favorite_border_rounded
                    : Icons.photo_camera_back_rounded,
                size: 38,
                color: const Color(0xFF183D3D),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              favorites ? 'Henüz favorin yok' : 'İlk anın rotanı bekliyor',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF263635),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              favorites
                  ? 'Kalbine dokunan anıları yıldızlayarak burada biriktir.'
                  : 'Bir ilçe ya da ülke seç; fotoğraf veya videonu o yere bağla.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                height: 1.5,
                color: const Color(0xFF757875),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoryTimelineCard extends StatelessWidget {
  final TravelMemory memory;

  const _MemoryTimelineCard({required this.memory});

  String get _date {
    const months = [
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara',
    ];
    return '${memory.capturedAt.day} ${months[memory.capturedAt.month - 1]}';
  }

  String get _moodEmoji => switch (memory.mood) {
    'Huzurlu' => '🌿',
    'Heyecanlı' => '✨',
    'Macera' => '🧭',
    _ => '😊',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF22302F).withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () => showMemoryMediaViewer(context, memory),
                  child: MemoryMediaThumbnail(
                    memory: memory,
                    width: double.infinity,
                    height: 220,
                  ),
                ),
                Positioned(
                  left: 14,
                  top: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '$_date  ·  $_moodEmoji ${memory.mood}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 9,
                  child: IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.45),
                      foregroundColor: memory.isFavorite
                          ? const Color(0xFFFFD166)
                          : Colors.white,
                    ),
                    onPressed: () =>
                        MemoryStore.instance.toggleFavorite(memory.id),
                    icon: Icon(
                      memory.isFavorite
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 10, 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              memory.scope == MemoryScope.turkey
                                  ? Icons.location_on_rounded
                                  : Icons.public_rounded,
                              size: 16,
                              color: const Color(0xFFB56D40),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                memory.locationLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFB56D40),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          memory.title,
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1D2E2C),
                          ),
                        ),
                        if (memory.note.isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Text(
                            memory.note,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              height: 1.45,
                              color: const Color(0xFF64706E),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    tooltip: 'Anı seçenekleri',
                    onSelected: (value) async {
                      if (value != 'delete') return;
                      final approved = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Anı silinsin mi?'),
                          content: const Text(
                            'Bu medya ve not cihazındaki anı atlasından kaldırılacak.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext, false),
                              child: const Text('Vazgeç'),
                            ),
                            FilledButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext, true),
                              child: const Text('Sil'),
                            ),
                          ],
                        ),
                      );
                      if (approved == true) {
                        await MemoryStore.instance.delete(memory.id);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline_rounded),
                            SizedBox(width: 8),
                            Text('Anıyı sil'),
                          ],
                        ),
                      ),
                    ],
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
