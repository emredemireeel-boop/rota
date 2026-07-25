import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/aegean_routes_data.dart';

class AegeanRoutesSection extends StatelessWidget {
  final int plateCode;
  final Color accentColor;
  final ValueChanged<String> onDistrictSelected;

  const AegeanRoutesSection({
    super.key,
    required this.plateCode,
    required this.accentColor,
    required this.onDistrictSelected,
  });

  @override
  Widget build(BuildContext context) {
    final routes = aegeanRoutes[plateCode] ?? const <AegeanRoute>[];
    if (routes.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                const Icon(Icons.route_rounded, color: Color(0xFFB56D40)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ege Rotaları • Yakın Plan',
                    style: GoogleFonts.outfit(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A2B4A),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ...routes.map(
            (route) => Container(
              margin: const EdgeInsets.only(bottom: 11),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: accentColor.withValues(alpha: 0.22)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.035),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              route.title,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF27364D),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              route.subtitle,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                height: 1.4,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          route.duration,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: route.districts
                        .map(
                          (district) => ActionChip(
                            visualDensity: VisualDensity.compact,
                            avatar: Icon(
                              Icons.location_on_rounded,
                              size: 15,
                              color: accentColor,
                            ),
                            label: Text(district),
                            onPressed: () => onDistrictSelected(district),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    route.highlights.join('  •  '),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 14,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'En iyi zaman: ${route.bestSeason}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF7C8798),
                        ),
                      ),
                    ],
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
