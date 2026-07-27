import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:district_picker_turkey_map/district_picker_turkey_map.dart';
import '../data/turkey_data.dart';
import 'turkey_province_labels.dart';

class InteractiveTurkeyMap extends StatefulWidget {
  final Function(Province) onProvinceSelected;
  const InteractiveTurkeyMap({super.key, required this.onProvinceSelected});

  @override
  State<InteractiveTurkeyMap> createState() => _InteractiveTurkeyMapState();
}

class _InteractiveTurkeyMapState extends State<InteractiveTurkeyMap>
    with SingleTickerProviderStateMixin {
  Province? _selectedProvince;
  String? _selectedId;
  bool _zoomed = false;
  late AnimationController _zoomCtrl;

  // Region color mapping (used in detail views)
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

  // Political map color palette (10 distinct colors)
  static const List<Color> _politicalColors = [
    Color(0xFFE57373), // kırmızımsı
    Color(0xFF81C784), // yeşilimsi
    Color(0xFF64B5F6), // mavimsi
    Color(0xFFFFD54F), // sarımsı
    Color(0xFFBA68C8), // morunsu
    Color(0xFF4DB6AC), // turkuaz
    Color(0xFFFF8A65), // turuncumsu
    Color(0xFF90A4AE), // gri-mavi
    Color(0xFFA1887F), // kahverengi
    Color(0xFFAED581), // açık yeşil
  ];

  // Pre-computed province color indices (plate code -> color index)
  // Ensures neighboring provinces get different colors
  static const Map<int, int> _provinceColorIndex = {
    1: 0,
    2: 1,
    3: 2,
    4: 3,
    5: 4,
    6: 5,
    7: 6,
    8: 7,
    9: 8,
    10: 9,
    11: 0,
    12: 1,
    13: 2,
    14: 3,
    15: 4,
    16: 5,
    17: 6,
    18: 7,
    19: 8,
    20: 9,
    21: 0,
    22: 1,
    23: 2,
    24: 3,
    25: 4,
    26: 5,
    27: 6,
    28: 7,
    29: 8,
    30: 9,
    31: 0,
    32: 1,
    33: 2,
    34: 3,
    35: 4,
    36: 5,
    37: 6,
    38: 7,
    39: 8,
    40: 9,
    41: 0,
    42: 1,
    43: 2,
    44: 3,
    45: 4,
    46: 5,
    47: 6,
    48: 7,
    49: 8,
    50: 9,
    51: 0,
    52: 1,
    53: 2,
    54: 3,
    55: 4,
    56: 5,
    57: 6,
    58: 7,
    59: 8,
    60: 9,
    61: 0,
    62: 1,
    63: 2,
    64: 3,
    65: 4,
    66: 5,
    67: 6,
    68: 7,
    69: 8,
    70: 9,
    71: 0,
    72: 1,
    73: 2,
    74: 3,
    75: 4,
    76: 5,
    77: 6,
    78: 7,
    79: 8,
    80: 9,
    81: 0,
  };

  // Map from countries_world_map province ID to our plate code
  Province? _findProvinceByMapId(String id) {
    // The countries_world_map uses province IDs like TR-01, TR-06, etc.
    // or two-letter state codes. Let's try different formats.
    final idUpper = id.toUpperCase().trim();

    // Try to extract plate code from "TR-XX" format
    if (idUpper.startsWith('TR-') || idUpper.startsWith('TR')) {
      final numStr = idUpper.replaceAll(RegExp(r'[^0-9]'), '');
      if (numStr.isNotEmpty) {
        final plateCode = int.tryParse(numStr);
        if (plateCode != null) {
          try {
            return turkeyProvinces.firstWhere((p) => p.plateCode == plateCode);
          } catch (_) {}
        }
      }
    }

    // Try matching by province name
    for (final p in turkeyProvinces) {
      if (p.name.toLowerCase() == id.toLowerCase()) {
        return p;
      }
    }

    return null;
  }

  // Build a color map for all provinces (political map - separate colors per province)
  Map<String, Color> _buildColorMap() {
    final Map<String, Color> colors = {};

    // Apply distinct colors to each province
    for (final p in turkeyProvinces) {
      final code = p.plateCode.toString().padLeft(2, '0');
      final colorIdx = _provinceColorIndex[p.plateCode] ?? 0;
      final color = _politicalColors[colorIdx];

      // Try multiple formats that the package might use
      colors['TR-$code'] = color.withValues(alpha: 0.65);
      colors['tr-$code'] = color.withValues(alpha: 0.65);
      colors['TR$code'] = color.withValues(alpha: 0.65);
      colors[code] = color.withValues(alpha: 0.65);
    }

    // Highlight selected province
    if (_selectedProvince != null && _selectedId != null) {
      final colorIdx = _provinceColorIndex[_selectedProvince!.plateCode] ?? 0;
      final color = _politicalColors[colorIdx];
      colors[_selectedId!] = color;
    }

    return colors;
  }

  void _onProvinceTap(String id, String name, TapUpDetails tapDetails) {
    final province = _findProvinceByMapId(id);
    if (province != null) {
      setState(() {
        if (_selectedProvince == province && _zoomed) {
          // Second tap - navigate to detail
          widget.onProvinceSelected(province);
        } else {
          _selectedProvince = province;
          _selectedId = id;
          _zoomed = true;
          _zoomCtrl.forward(from: 0);
        }
      });
    }
  }

  void _onZoomOut() {
    _zoomCtrl.reverse().then((_) {
      setState(() {
        _zoomed = false;
        _selectedProvince = null;
        _selectedId = null;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _zoomCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _zoomCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _zoomCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Map Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE30A17).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.map_rounded,
                    color: Color(0xFFE30A17),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _zoomed && _selectedProvince != null
                            ? _selectedProvince!.name
                            : 'Türkiye Haritası',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A2B4A),
                        ),
                      ),
                      Text(
                        _zoomed && _selectedProvince != null
                            ? '${_selectedProvince!.districts.length} ilçe • İl detayı için tekrar tıkla'
                            : 'İl seçmek için haritaya dokun',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_zoomed)
                  IconButton(
                    onPressed: _onZoomOut,
                    icon: const Icon(Icons.zoom_out_map_rounded, size: 22),
                    color: const Color(0xFF64748B),
                    tooltip: 'Geri dön',
                  ),
              ],
            ),
          ),

          // Map or District view
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 400),
            crossFadeState: _zoomed && _selectedProvince != null
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: _buildMapView(),
            secondChild: _zoomed && _selectedProvince != null
                ? _buildDistrictView()
                : const SizedBox(),
          ),

          // Political map label
          if (!_zoomed)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.public_rounded,
                    size: 14,
                    color: const Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '81 İl • Siyasi Harita',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF94A3B8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: SizedBox(
        height: 200,
        child: InteractiveViewer(
          minScale: 1.0,
          maxScale: 10.0,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SimpleMap(
                instructions: SMapTurkey.instructions,
                defaultColor: const Color(0xFFE2E8F0),
                colors: _buildColorMap(),
                callback: _onProvinceTap,
              ),
              TurkeyProvinceLabels(
                highlightedPlates: {
                  if (_selectedProvince != null) _selectedProvince!.plateCode,
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Plate code → Maps SVG constant mapping (all 81 provinces)
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

  Widget _buildDistrictView() {
    final province = _selectedProvince!;
    final color = _regionColor(province.region);
    final mapSvg = _plateToMap[province.plateCode];

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Province info bar
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
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
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      province.region,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      'Nüfus: ${_formatPop(province.population)} • ${province.districts.length} ilçe',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => widget.onProvinceSelected(province),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'İl Detayı',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // İlçe Siyasi Haritası header
          Row(
            children: [
              Icon(Icons.map_outlined, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                'İlçe Siyasi Haritası',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF475569),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Real SVG district map
          mapSvg != null
              ? SizedBox(
                  height: 220,
                  child: DistrictPickerMap(
                    width: double.infinity,
                    height: 220,
                    map: mapSvg,
                    onChanged: (district) {
                      // İlçe tıklandığında sadece bilgi göster
                    },
                    actAsToggle: true,
                    selectedColor: color,
                    strokeColor: Colors.white,
                    dotColor: Colors.white,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Harita yüklenemedi',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  String _formatPop(int p) {
    if (p >= 1000000) return '${(p / 1000000).toStringAsFixed(1)}M';
    if (p >= 1000) return '${(p / 1000).toStringAsFixed(0)}K';
    return '$p';
  }
}
