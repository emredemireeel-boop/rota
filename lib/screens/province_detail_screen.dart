import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:district_picker_turkey_map/district_picker_turkey_map.dart';
import '../data/turkey_data.dart';
import '../data/province_social_data.dart';
import '../widgets/memory_capture_sheet.dart';
import '../widgets/memory_section.dart';
import '../widgets/aegean_routes_section.dart';

class ProvinceDetailScreen extends StatefulWidget {
  final Province province;
  final String? initialDistrict;
  const ProvinceDetailScreen({
    super.key,
    required this.province,
    this.initialDistrict,
  });

  @override
  State<ProvinceDetailScreen> createState() => _ProvinceDetailScreenState();
}

class _ProvinceDetailScreenState extends State<ProvinceDetailScreen> {
  late String _selectedDistrict; // 'Genel' or district name
  late SocialInfo _currentInfo;

  // Plate code → Maps SVG constant mapping
  static const Map<int, String> _plateToMap = {
    1: Maps.ADANA,
    2: Maps.ADIYAMAN,
    3: Maps.AFYONKARAHISAR,
    4: Maps.AGRI,
    5: Maps.AMASYA,
    6: Maps.ANKARA,
    7: Maps.ANTALYA,
    8: Maps.ARTVIN,
    9: Maps.AYDIN,
    10: Maps.BALIKESIR,
    11: Maps.BILECIK,
    12: Maps.BINGOL,
    13: Maps.BITLIS,
    14: Maps.BOLU,
    15: Maps.BURDUR,
    16: Maps.BURSA,
    17: Maps.CANAKKALE,
    18: Maps.CANKIRI,
    19: Maps.CORUM,
    20: Maps.DENIZLI,
    21: Maps.DIYARBAKIR,
    22: Maps.EDIRNE,
    23: Maps.ELAZIG,
    24: Maps.ERZINCAN,
    25: Maps.ERZURUM,
    26: Maps.ESKISEHIR,
    27: Maps.GAZIANTEP,
    28: Maps.GIRESUN,
    29: Maps.GUMUSHANE,
    30: Maps.HAKKARI,
    31: Maps.HATAY,
    32: Maps.ISPARTA,
    33: Maps.MERSIN,
    34: Maps.ISTANBUL,
    35: Maps.IZMIR,
    36: Maps.KARS,
    37: Maps.KASTAMONU,
    38: Maps.KAYSERI,
    39: Maps.KIRKLARELI,
    40: Maps.KIRSEHIR,
    41: Maps.KOCAELI,
    42: Maps.KONYA,
    43: Maps.KUTAHYA,
    44: Maps.MALATYA,
    45: Maps.MANISA,
    46: Maps.KAHRAMANMARAS,
    47: Maps.MARDIN,
    48: Maps.MUGLA,
    49: Maps.MUS,
    50: Maps.NEVSEHIR,
    51: Maps.NIGDE,
    52: Maps.ORDU,
    53: Maps.RIZE,
    54: Maps.SAKARYA,
    55: Maps.SAMSUN,
    56: Maps.SIIRT,
    57: Maps.SINOP,
    58: Maps.SIVAS,
    59: Maps.TEKIRDAG,
    60: Maps.TOKAT,
    61: Maps.TRABZON,
    62: Maps.TUNCELI,
    63: Maps.SANLIURFA,
    64: Maps.USAK,
    65: Maps.VAN,
    66: Maps.YOZGAT,
    67: Maps.ZONGULDAK,
    68: Maps.AKSARAY,
    69: Maps.BAYBURT,
    70: Maps.KARAMAN,
    71: Maps.KIRIKKALE,
    72: Maps.BATMAN,
    73: Maps.SIRNAK,
    74: Maps.BARTIN,
    75: Maps.ARDAHAN,
    76: Maps.IGDIR,
    77: Maps.YALOVA,
    78: Maps.KARABUK,
    79: Maps.KILIS,
    80: Maps.OSMANIYE,
    81: Maps.DUZCE,
  };

  @override
  void initState() {
    super.initState();
    _selectedDistrict = widget.initialDistrict ?? 'Genel';
    _updateSocialInfo();
  }

  void _updateSocialInfo() {
    if (_selectedDistrict == 'Genel') {
      _currentInfo = getProvinceSocialInfo(widget.province.plateCode);
    } else {
      _currentInfo = getDistrictSocialInfo(
        widget.province.plateCode,
        _selectedDistrict,
      );
    }
  }

  void _selectDistrict(String district) {
    setState(() {
      _selectedDistrict = district;
      _updateSocialInfo();
    });
  }

  void _openMaps(double lat, double lng) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    // Directly launch to bypass canLaunchUrl Android 11+ queries restriction
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Launch Maps error: $e');
    }
  }

  void _searchInMaps(String query) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}',
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Launch Maps Query error: $e');
    }
  }

  Future<void> _addMemory(Color accentColor) async {
    final saved = await showMemoryCaptureSheet(
      context,
      location: MemoryLocation.turkey(
        plateCode: widget.province.plateCode,
        province: widget.province.name,
        district: _selectedDistrict,
      ),
      accentColor: accentColor,
    );
    if (saved && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$_selectedDistrict anısı, Anı Atlası\'na eklendi.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Color _safetyColor(String level) {
    switch (level) {
      case 'Güvenli':
        return const Color(0xFF22C55E);
      case 'Ortalama':
        return const Color(0xFFF59E0B);
      case 'Az Tehlikeli':
        return const Color(0xFFF97316);
      case 'Tehlikeli':
        return const Color(0xFFEF4444);
      case 'Çok Tehlikeli':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  IconData _safetyIcon(String level) {
    switch (level) {
      case 'Güvenli':
        return Icons.verified_user_rounded;
      case 'Ortalama':
        return Icons.shield_rounded;
      case 'Az Tehlikeli':
        return Icons.warning_amber_rounded;
      case 'Tehlikeli':
        return Icons.dangerous_rounded;
      case 'Çok Tehlikeli':
        return Icons.report_rounded;
      default:
        return Icons.shield_rounded;
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
    final province = widget.province;
    final accentColor = _regionColor(province.region);
    final mapSvg = _plateToMap[province.plateCode];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF183D3D),
        foregroundColor: Colors.white,
        onPressed: () => _addMemory(accentColor),
        icon: const Icon(Icons.add_a_photo_rounded),
        label: Text(
          'Anı ekle',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accentColor,
                      accentColor.withValues(alpha: 0.7),
                      accentColor.withValues(alpha: 0.5),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 50, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${province.plateCode}',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              province.name,
                              style: GoogleFonts.outfit(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${province.region} • ${province.districts.length} ilçe',
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
            ),
          ),

          // District Selector (Genel + Districts)
          SliverToBoxAdapter(
            child: _buildDistrictSelector(province, accentColor),
          ),

          // District Map
          if (mapSvg != null)
            SliverToBoxAdapter(child: _buildDistrictMap(mapSvg, accentColor)),

          SliverToBoxAdapter(
            child: MemorySectionBuilder(
              accentColor: accentColor,
              title: _selectedDistrict == 'Genel'
                  ? '${province.name} Anıları'
                  : '$_selectedDistrict Anıları',
              memories: (store) => store.forProvince(
                province.plateCode,
                district: _selectedDistrict,
              ),
              onAdd: () => _addMemory(accentColor),
            ),
          ),

          if (province.region == 'Ege')
            SliverToBoxAdapter(
              child: AegeanRoutesSection(
                plateCode: province.plateCode,
                accentColor: accentColor,
                onDistrictSelected: _selectDistrict,
              ),
            ),

          // Social Info Cards
          SliverToBoxAdapter(child: _buildSocialInfoSection(accentColor)),

          // Famous Foods
          SliverToBoxAdapter(child: _buildFoodSection(accentColor)),

          // Interesting Facts
          SliverToBoxAdapter(child: _buildFactsSection(accentColor)),

          // Places (existing)
          if (province.places.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text(
                  'Gezilecek Yerler',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A2B4A),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => _PlaceCard(
                    place: province.places[i],
                    onNavigate: () => _openMaps(
                      province.places[i].lat,
                      province.places[i].lng,
                    ),
                  ),
                  childCount: province.places.length,
                ),
              ),
            ),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildDistrictSelector(Province province, Color accent) {
    final items = ['Genel', ...province.districts];
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_city_rounded, size: 18, color: accent),
              const SizedBox(width: 6),
              Text(
                'İlçe Seçimi',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A2B4A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (ctx, i) {
                final item = items[i];
                final sel = item == _selectedDistrict;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () => _selectDistrict(item),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: sel ? accent : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        border: sel
                            ? null
                            : Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Text(
                        item,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                          color: sel ? Colors.white : const Color(0xFF475569),
                        ),
                      ),
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

  Widget _buildDistrictMap(String mapSvg, Color accent) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.all(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.map_outlined, size: 16, color: accent),
              const SizedBox(width: 6),
              Text(
                'İlçe Siyasi Haritası',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF475569),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: DistrictPickerMap(
              width: double.infinity,
              height: 200,
              map: mapSvg,
              onChanged: (district) {
                if (district != null && district.title.isNotEmpty) {
                  _selectDistrict(district.title);
                }
              },
              actAsToggle: true,
              selectedColor: accent,
              strokeColor: Colors.white,
              dotColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialInfoSection(Color accent) {
    final info = _currentInfo;
    final safetyClr = _safetyColor(info.safetyLevel);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedDistrict == 'Genel'
                ? 'Sosyal Bilgiler'
                : '$_selectedDistrict - Sosyal Bilgiler',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A2B4A),
            ),
          ),
          const SizedBox(height: 14),

          // Safety Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: safetyClr.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: safetyClr.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(_safetyIcon(info.safetyLevel), color: safetyClr, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Güvenlik Durumu',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        info.safetyLevel,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: safetyClr,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Happiness & Friendliness bars
          _buildProgressBar(
            '😊 Mutluluk Endeksi',
            info.happinessIndex,
            10,
            const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 10),
          _buildProgressBar(
            '🤝 İnsan Yakınlığı',
            info.humanFriendliness,
            10,
            const Color(0xFF3B82F6),
          ),
          const SizedBox(height: 14),

          // Social Population
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('👥', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sosyal Yapı',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        info.socialPopulation,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Google Haritalar'da Keşfet Butonu
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent, accent.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  final query = _selectedDistrict == 'Genel'
                      ? '${widget.province.name} gezilecek yerler'
                      : '$_selectedDistrict, ${widget.province.name} gezilecek yerler';
                  _searchInMaps(query);
                },
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.explore_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _selectedDistrict == 'Genel'
                            ? '${widget.province.name} Keşfine Başla!'
                            : '$_selectedDistrict Keşfine Başla!',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(
    String label,
    double value,
    double max,
    Color color,
  ) {
    final fraction = (value / max).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF475569),
              ),
            ),
            Text(
              '${value.toStringAsFixed(1)} / $max',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 8,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }

  Widget _buildFoodSection(Color accent) {
    final info = _currentInfo;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🍽️', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(
                'Yöresel Lezzetler',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A2B4A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: info.famousFoods
                .map(
                  (f) => GestureDetector(
                    onTap: () => _searchInMaps(
                      '$f nerede yenir ${widget.province.name}',
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFED7AA)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            f,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFEA580C),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: Color(0xFFEA580C),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          if (info.foodPlaces.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              '📍 Önerilen Yemek Mekanları',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A2B4A),
              ),
            ),
            const SizedBox(height: 8),
            ...info.foodPlaces.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.restaurant_rounded, size: 16, color: accent),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          p,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF475569),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            _searchInMaps('$p, ${widget.province.name}'),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.map_rounded,
                            size: 16,
                            color: accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFactsSection(Color accent) {
    final info = _currentInfo;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(
                'İlginç Bilgiler',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A2B4A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...info.interestingFacts.asMap().entries.map(
            (e) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accent.withValues(alpha: 0.15)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${e.key + 1}',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      e.value,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF475569),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Place card widget (kept from original)
class _PlaceCard extends StatefulWidget {
  final Place place;
  final VoidCallback onNavigate;
  const _PlaceCard({required this.place, required this.onNavigate});
  @override
  State<_PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<_PlaceCard> {
  bool _expanded = false;
  IconData _catIcon(String c) {
    switch (c) {
      case 'Tarihi':
        return Icons.account_balance_rounded;
      case 'Doğa':
        return Icons.park_rounded;
      case 'Deniz':
        return Icons.waves_rounded;
      case 'Gezi':
        return Icons.explore_rounded;
      case 'Müze':
        return Icons.museum_rounded;
      default:
        return Icons.place_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.place;
    return Container(
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
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F7FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      _catIcon(p.category),
                      color: const Color(0xFF2B8FBF),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A2B4A),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          p.description,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF64748B),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFF59E0B),
                            size: 16,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            p.rating.toString(),
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A2B4A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        _expanded
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                        color: const Color(0xFF94A3B8),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Yorumlar (${p.reviews.length})',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A2B4A),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: widget.onNavigate,
                    icon: const Icon(Icons.navigation_rounded, size: 16),
                    label: Text(
                      'Yol Tarifi',
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            if (p.reviews.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  'Henüz yorum yok',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              )
            else
              ...p.reviews.map(
                (r) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: const Color(0xFF2B8FBF),
                              child: Text(
                                r.user[0],
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              r.user,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A2B4A),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: List.generate(
                                5,
                                (j) => Icon(
                                  j < r.rating
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  size: 14,
                                  color: const Color(0xFFF59E0B),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          r.comment,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          r.date,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
