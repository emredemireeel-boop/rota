import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import '../data/passport_data.dart';

class InteractiveWorldMap extends StatefulWidget {
  final Function(Country)? onCountrySelected;
  const InteractiveWorldMap({super.key, this.onCountrySelected});

  @override
  State<InteractiveWorldMap> createState() => _InteractiveWorldMapState();
}

class _InteractiveWorldMapState extends State<InteractiveWorldMap> {
  Country? _selectedCountry;
  String? _selectedId;

  // Visa status color mapping
  Color _visaColor(VisaStatus status) {
    switch (status) {
      case VisaStatus.visaFree:
        return const Color(0xFF2ecc71);
      case VisaStatus.idOnly:
        return const Color(0xFF9b59b6);
      case VisaStatus.visaOnArrival:
        return const Color(0xFF3498db);
      case VisaStatus.eTA:
        return const Color(0xFFf1c40f);
      case VisaStatus.visaRequired:
        return const Color(0xFFe74c3c);
    }
  }

  // Find country by map id (lowercase 2-letter code)
  Country? _findCountryByMapId(String id) {
    final upperCode = id.toUpperCase();
    try {
      return passportCountries.firstWhere(
        (c) => c.code.toUpperCase() == upperCode,
      );
    } catch (_) {
      return null;
    }
  }

  // Build color map for all countries based on visa status
  Map<String, Color> _buildColorMap() {
    final Map<String, Color> colors = {};

    for (final c in passportCountries) {
      final code = c.code.toLowerCase();
      final color = _visaColor(c.visaStatus);
      colors[code] = color.withValues(alpha: 0.75);
    }

    // Highlight Turkey
    colors['tr'] = const Color(0xFFD4AF37);

    // Highlight selected country
    if (_selectedCountry != null && _selectedId != null) {
      final color = _visaColor(_selectedCountry!.visaStatus);
      colors[_selectedId!] = color;
    }

    return colors;
  }

  void _onCountryTap(String id, String name, TapUpDetails tapDetails) {
    final country = _findCountryByMapId(id);
    if (country != null) {
      setState(() {
        _selectedCountry = country;
        _selectedId = id;
      });

      // Show bottom info sheet
      _showCountryInfo(country);
    }
  }

  void _showCountryInfo(Country country) {
    final bgColor = _visaColor(country.visaStatus);
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A2836),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF6B7B8F),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            // Country info
            Row(
              children: [
                Text(country.flag, style: const TextStyle(fontSize: 36)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        country.name,
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        country.continent,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF8899AA),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Status + Duration
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    visaStatusText(country.visaStatus),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                if (country.duration.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      country.duration,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                if (country.notes.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      country.notes,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF8899AA),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            // Detail button
            if (widget.onCountrySelected != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    widget.onCountrySelected!(country);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bgColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Detayları Gör',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2836),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A3A4A)),
      ),
      child: Column(
        children: [
          // Title bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Icon(
                  Icons.public_rounded,
                  size: 16,
                  color: const Color(0xFFD4AF37),
                ),
                const SizedBox(width: 6),
                Text(
                  'DÜNYA SİYASİ HARİTASI',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFD4AF37),
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                Text(
                  'Vize Durumuna Göre',
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    color: const Color(0xFF6B7B8F),
                  ),
                ),
              ],
            ),
          ),

          // Map
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: SizedBox(
              height: 180,
              child: InteractiveViewer(
                minScale: 1.0,
                maxScale: 6.0,
                child: SimpleMap(
                  instructions: SMapWorld.instructions,
                  defaultColor: const Color(0xFF2A3A4A),
                  colors: _buildColorMap(),
                  callback: _onCountryTap,
                ),
              ),
            ),
          ),

          // Legend
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _legendDot(const Color(0xFF2ecc71), 'Vizesiz'),
                _legendDot(const Color(0xFF9b59b6), 'Kimlik'),
                _legendDot(const Color(0xFF3498db), 'Kapıda'),
                _legendDot(const Color(0xFFf1c40f), 'eTA'),
                _legendDot(const Color(0xFFe74c3c), 'Vizeli'),
                _legendDot(const Color(0xFFD4AF37), 'TR'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 9, color: const Color(0xFF8899AA)),
        ),
      ],
    );
  }
}
