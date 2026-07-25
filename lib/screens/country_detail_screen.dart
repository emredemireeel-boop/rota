import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:countries_world_map/countries_world_map.dart';
import '../data/passport_data.dart';
import '../data/country_social_data.dart';
import '../widgets/memory_capture_sheet.dart';
import '../widgets/memory_section.dart';

class CountryDetailScreen extends StatefulWidget {
  final Country country;
  const CountryDetailScreen({super.key, required this.country});

  @override
  State<CountryDetailScreen> createState() => _CountryDetailScreenState();
}

class _CountryDetailScreenState extends State<CountryDetailScreen> {
  late String _selectedRegion;
  late CountrySocialInfo _countryInfo;
  late RegionSocialInfo _currentRegionInfo;

  @override
  void initState() {
    super.initState();
    _selectedRegion = 'Genel';
    _countryInfo = getCountrySocialInfo(widget.country.code);
    _updateRegionInfo();
  }

  void _updateRegionInfo() {
    if (_selectedRegion == 'Genel') {
      _currentRegionInfo = RegionSocialInfo(
        safetyLevel: _countryInfo.safetyLevel,
        humanFriendliness: _countryInfo.humanFriendliness,
        happinessIndex: _countryInfo.happinessIndex,
        famousFoods: _countryInfo.famousFoods,
        places: _countryInfo.places,
        interestingFacts: _countryInfo.interestingFacts,
        socialInfo: _countryInfo.socialInfo,
      );
    } else {
      _currentRegionInfo = getRegionSocialInfo(
        widget.country.code,
        _selectedRegion,
      );
    }
  }

  void _selectRegion(String region) {
    setState(() {
      _selectedRegion = region;
      _updateRegionInfo();
    });
  }

  Future<void> _addMemory(Color accentColor) async {
    final saved = await showMemoryCaptureSheet(
      context,
      location: MemoryLocation.world(
        countryCode: widget.country.code,
        country: widget.country.name,
        region: _selectedRegion,
      ),
      accentColor: accentColor,
    );
    if (saved && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${widget.country.name} anısı, Anı Atlası\'na eklendi.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Country code -> SMap instructions mapping
  static String? _getMapInstructions(String code) {
    switch (code.toUpperCase()) {
      case 'GR':
        return SMapGreece.instructions;
      case 'BG':
        return SMapBulgaria.instructions;
      case 'GE':
        return SMapGeorgia.instructions;
      case 'IR':
        return SMapIran.instructions;
      case 'IQ':
        return SMapIraq.instructions;
      case 'SY':
        return SMapSyria.instructions;
      case 'AZ':
        return SMapAzerbaijan.instructions;
      case 'AM':
        return SMapArmenia.instructions;
      case 'CY':
        return SMapCyprus.instructions;
      case 'RU':
        return SMapRussia.instructions;
      case 'UA':
        return SMapUkraine.instructions;
      case 'EG':
        return SMapEgypt.instructions;
      case 'SA':
        return SMapSaudiArabia.instructions;
      case 'DE':
        return SMapGermany.instructions;
      case 'FR':
        return SMapFrance.instructions;
      case 'IT':
        return SMapItaly.instructions;
      case 'GB':
        return SMapUnitedKingdom.instructions;
      case 'US':
        return SMapUnitedStates.instructions;
      case 'JP':
        return SMapJapan.instructions;
      case 'BR':
        return SMapBrazil.instructions;
      case 'RS':
        return SMapSerbia.instructions;
      case 'ME':
        return SMapMontenegro.instructions;
      case 'MK':
        return SMapMacedonia.instructions;
      case 'MD':
        return SMapMoldova.instructions;
      case 'BY':
        return SMapBelarus.instructions;
      case 'KZ':
        return SMapKazakhstan.instructions;
      case 'UZ':
        return SMapUzbekistan.instructions;
      case 'KG':
        return SMapKyrgyzstan.instructions;
      case 'TJ':
        return SMapTajikistan.instructions;
      case 'TH':
        return SMapThailand.instructions;
      case 'MY':
        return SMapMalaysia.instructions;
      case 'ID':
        return SMapIndonesia.instructions;
      case 'PH':
        return SMapPhilippines.instructions;
      case 'AR':
        return SMapArgentina.instructions;
      case 'CO':
        return SMapColombia.instructions;
      case 'CL':
        return SMapChile.instructions;
      case 'PE':
        return SMapPeru.instructions;
      case 'EC':
        return SMapEcuador.instructions;
      case 'ZA':
        return SMapSouthAfrica.instructions;
      case 'MA':
        return SMapMorocco.instructions;
      case 'ES':
        return SMapSpain.instructions;
      case 'NL':
        return SMapNetherlands.instructions;
      case 'CH':
        return SMapSwitzerland.instructions;
      case 'CA':
        return SMapCanada.instructions;
      case 'AU':
        return SMapAustralia.instructions;
      case 'CN':
        return SMapChina.instructions;
      case 'IN':
        return SMapIndia.instructions;
      case 'MX':
        return SMapMexico.instructions;
      case 'KR':
        return SMapSouthKorea.instructions;
      default:
        return null;
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

  @override
  Widget build(BuildContext context) {
    final country = widget.country;
    final clr = visaStatusColor(country.visaStatus);
    final mapInstructions = _getMapInstructions(country.code);
    final info = _currentRegionInfo;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF183D3D),
        foregroundColor: Colors.white,
        onPressed: () => _addMemory(clr),
        icon: const Icon(Icons.add_a_photo_rounded),
        label: Text(
          'Anı ekle',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // App Bar with flag
          SliverAppBar(
            expandedHeight: 200,
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
                      clr,
                      clr.withValues(alpha: 0.7),
                      clr.withValues(alpha: 0.4),
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
                            Text(
                              country.flag,
                              style: const TextStyle(fontSize: 42),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    country.name,
                                    style: GoogleFonts.outfit(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${country.continent} • ${country.code}',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.white.withValues(
                                        alpha: 0.85,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            visaStatusText(country.visaStatus),
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Country Quick Info
          SliverToBoxAdapter(child: _buildQuickInfo(country)),

          // Country Map
          if (mapInstructions != null)
            SliverToBoxAdapter(child: _buildCountryMap(mapInstructions, clr)),

          // Region Selector
          if (_countryInfo.regions.isNotEmpty)
            SliverToBoxAdapter(child: _buildRegionSelector(clr)),

          SliverToBoxAdapter(
            child: MemorySectionBuilder(
              accentColor: clr,
              title: _selectedRegion == 'Genel'
                  ? '${country.name} Anıları'
                  : '$_selectedRegion Anıları',
              memories: (store) =>
                  store.forCountry(country.code, region: _selectedRegion),
              onAdd: () => _addMemory(clr),
            ),
          ),

          // Social Info
          SliverToBoxAdapter(child: _buildSocialInfo(info, clr)),

          // Food Section
          SliverToBoxAdapter(child: _buildFoodSection(info, clr)),

          // Places Section
          SliverToBoxAdapter(child: _buildPlacesSection(info, clr)),

          // Interesting Facts
          SliverToBoxAdapter(child: _buildFactsSection(info, clr)),

          // Visa Tips (kept from original)
          SliverToBoxAdapter(child: _buildVisaTips(country)),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildQuickInfo(Country country) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(14),
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
      child: Row(
        children: [
          _QuickInfoItem(
            icon: Icons.location_city_rounded,
            label: 'Başkent',
            value: _countryInfo.capital,
          ),
          _QuickInfoItem(
            icon: Icons.attach_money_rounded,
            label: 'Para',
            value: _countryInfo.currency,
          ),
          _QuickInfoItem(
            icon: Icons.translate_rounded,
            label: 'Dil',
            value: _countryInfo.language,
          ),
          _QuickInfoItem(
            icon: Icons.people_rounded,
            label: 'Nüfus',
            value: _countryInfo.population,
          ),
        ],
      ),
    );
  }

  Widget _buildCountryMap(String instructions, Color accent) {
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
                'Bölge Haritası',
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
            height: 220,
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 5.0,
              child: SimpleMap(
                instructions: instructions,
                defaultColor: accent.withValues(alpha: 0.3),
                callback: (id, name, tapDetails) {
                  // When a region is tapped on the map
                  if (name.isNotEmpty) {
                    _selectRegion(name);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionSelector(Color accent) {
    final items = ['Genel', ..._countryInfo.regions];
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
              Icon(Icons.location_city_rounded, size: 18, color: accent),
              const SizedBox(width: 6),
              Text(
                'Bölge Seçimi',
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
                final sel = item == _selectedRegion;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () => _selectRegion(item),
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

  Widget _buildSocialInfo(RegionSocialInfo info, Color accent) {
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
            _selectedRegion == 'Genel'
                ? 'Sosyal Bilgiler'
                : '$_selectedRegion - Sosyal Bilgiler',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A2B4A),
            ),
          ),
          const SizedBox(height: 14),
          // Safety
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
                        'Güvenlik',
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
                        info.socialInfo,
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

  Widget _buildFoodSection(RegionSocialInfo info, Color accent) {
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
                  (f) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFED7AA)),
                    ),
                    child: Text(
                      f,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFEA580C),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlacesSection(RegionSocialInfo info, Color accent) {
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
              const Text('📍', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(
                'Gezilecek Yerler',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A2B4A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...info.places.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      p,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF475569),
                        height: 1.3,
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

  Widget _buildFactsSection(RegionSocialInfo info, Color accent) {
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

  Widget _buildVisaTips(Country country) {
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
              const Text('✈️', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(
                'Seyahat Bilgileri',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A2B4A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _TipRow(
            icon: Icons.badge_rounded,
            text: _visaTip(country.visaStatus),
          ),
          if (country.duration.isNotEmpty)
            _TipRow(
              icon: Icons.timer_rounded,
              text: 'Kalış süresi: ${country.duration}',
            ),
          if (country.notes.isNotEmpty)
            _TipRow(icon: Icons.info_outline_rounded, text: country.notes),
          _TipRow(
            icon: Icons.calendar_month_rounded,
            text: 'Pasaportunuzun en az 6 ay geçerli olduğundan emin olun.',
          ),
          if (country.visaStatus == VisaStatus.idOnly)
            _TipRow(
              icon: Icons.warning_amber_rounded,
              text: 'Kimlikle seyahatte sadece direkt uçuşlar geçerlidir.',
            ),
        ],
      ),
    );
  }

  String _visaTip(VisaStatus s) {
    switch (s) {
      case VisaStatus.idOnly:
        return 'Yeni tip çipli kimlik kartı ile pasaportsuz seyahat edebilirsiniz.';
      case VisaStatus.visaFree:
        return 'Pasaport ile vizesiz giriş yapabilirsiniz.';
      case VisaStatus.visaOnArrival:
        return 'Varışta havalimanında vize alabilirsiniz.';
      case VisaStatus.eTA:
        return 'Online olarak elektronik seyahat izni almanız gerekmektedir.';
      case VisaStatus.visaRequired:
        return 'Seyahat öncesi konsolosluktan vize almanız gerekmektedir.';
    }
  }
}

class _QuickInfoItem extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _QuickInfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF2B8FBF), size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A2B4A),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _TipRow({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2B8FBF), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF475569),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
