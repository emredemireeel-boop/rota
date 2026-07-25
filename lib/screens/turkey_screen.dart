import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/turkey_data.dart';
import '../services/memory_store.dart';
import '../widgets/rota_banner_ad.dart';
import '../widgets/turkey_map_widget.dart';
import 'province_detail_screen.dart';

class TurkeyScreen extends StatefulWidget {
  const TurkeyScreen({super.key});
  @override
  State<TurkeyScreen> createState() => _TurkeyScreenState();
}

class _TurkeyScreenState extends State<TurkeyScreen> {
  String _searchQuery = '';
  String _selectedRegion = 'Tümü';
  final TextEditingController _searchCtrl = TextEditingController();

  final List<String> _regions = [
    'Tümü',
    'Marmara',
    'Ege',
    'Akdeniz',
    'İç Anadolu',
    'Karadeniz',
    'Doğu Anadolu',
    'Güneydoğu Anadolu',
  ];

  List<Province> get _filtered {
    var list = turkeyProvinces;
    if (_selectedRegion != 'Tümü') {
      list = list.where((p) => p.region == _selectedRegion).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where(
            (p) =>
                p.name.toLowerCase().contains(q) || p.plateCode.toString() == q,
          )
          .toList();
    }
    return list;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: const RotaBannerAd(),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF1A2B4A),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE30A17),
                      Color(0xFFCE0A14),
                      Color(0xFFAA0810),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('🇹🇷', style: TextStyle(fontSize: 36)),
                            const SizedBox(width: 12),
                            Text(
                              'Türkiye',
                              style: GoogleFonts.outfit(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '81 İl • 7 Bölge • Sınırsız Keşif',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              collapseMode: CollapseMode.parallax,
            ),
          ),

          // Interactive Map
          SliverToBoxAdapter(
            child: InteractiveTurkeyMap(
              onProvinceSelected: (province) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProvinceDetailScreen(province: province),
                  ),
                );
              },
            ),
          ),

          if ((_selectedRegion == 'Tümü' || _selectedRegion == 'Ege') &&
              _searchQuery.isEmpty)
            SliverToBoxAdapter(child: _buildAegeanSpotlight()),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'İl ara... (isim veya plaka kodu)',
                    hintStyle: GoogleFonts.inter(
                      color: const Color(0xFF94A3B8),
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF94A3B8),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 20),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Region Filter
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _regions.length,
                itemBuilder: (ctx, i) {
                  final r = _regions[i];
                  final sel = r == _selectedRegion;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(
                        r,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                          color: sel ? Colors.white : const Color(0xFF475569),
                        ),
                      ),
                      selected: sel,
                      onSelected: (_) => setState(() => _selectedRegion = r),
                      selectedColor: const Color(0xFFE30A17),
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: sel
                            ? Colors.transparent
                            : const Color(0xFFE2E8F0),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Result count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text(
                '${_filtered.length} il listeleniyor',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ),
          ),

          // Province List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((ctx, i) {
                final p = _filtered[i];
                return _ProvinceCard(
                  province: p,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProvinceDetailScreen(province: p),
                      ),
                    );
                  },
                );
              }, childCount: _filtered.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAegeanSpotlight() {
    final aegean = turkeyProvinces.where((p) => p.region == 'Ege').toList();
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF8E7), Color(0xFFFFE7BF)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF6C768)),
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
                  color: const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(Icons.wb_sunny_rounded, color: Colors.white),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ege • Yakın Plan',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF6C4511),
                      ),
                    ),
                    Text(
                      'Koylar, antik kentler, bağ yolları ve sakin rotalar',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF8A642F),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: aegean.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final province = aegean[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProvinceDetailScreen(province: province),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(15),
                  child: Ink(
                    width: 112,
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.82),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          province.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF6C4511),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${province.districts.length} ilçe',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF9A7541),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProvinceCard extends StatelessWidget {
  final Province province;
  final VoidCallback onTap;
  const _ProvinceCard({required this.province, required this.onTap});

  IconData _regionIcon(String r) {
    switch (r) {
      case 'Marmara':
        return Icons.sailing_rounded;
      case 'Ege':
        return Icons.wb_sunny_rounded;
      case 'Akdeniz':
        return Icons.beach_access_rounded;
      case 'İç Anadolu':
        return Icons.landscape_rounded;
      case 'Karadeniz':
        return Icons.forest_rounded;
      case 'Doğu Anadolu':
        return Icons.terrain_rounded;
      case 'Güneydoğu Anadolu':
        return Icons.castle_rounded;
      default:
        return Icons.place_rounded;
    }
  }

  Color _regionColor(String r) {
    switch (r) {
      case 'Marmara':
        return const Color(0xFF3B82F6);
      case 'Ege':
        return const Color(0xFFF59E0B);
      case 'Akdeniz':
        return const Color(0xFF06B6D4);
      case 'İç Anadolu':
        return const Color(0xFF8B5CF6);
      case 'Karadeniz':
        return const Color(0xFF22C55E);
      case 'Doğu Anadolu':
        return const Color(0xFFEF4444);
      case 'Güneydoğu Anadolu':
        return const Color(0xFFF97316);
      default:
        return const Color(0xFF64748B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clr = _regionColor(province.region);
    return AnimatedBuilder(
      animation: MemoryStore.instance,
      builder: (context, _) {
        final memoryCount = MemoryStore.instance
            .forProvince(province.plateCode)
            .length;
        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Plate Code Circle
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [clr, clr.withValues(alpha: 0.7)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        '${province.plateCode}',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          province.name,
                          style: GoogleFonts.outfit(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A2B4A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              _regionIcon(province.region),
                              size: 14,
                              color: clr,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              province.region,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.place_rounded,
                              size: 14,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${province.places.length} yer',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                            if (memoryCount > 0) ...[
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.auto_awesome_rounded,
                                size: 13,
                                color: Color(0xFFB56D40),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '$memoryCount anı',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFB56D40),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFFCBD5E1),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
