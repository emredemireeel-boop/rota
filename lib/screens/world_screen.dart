import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/passport_data.dart';
import '../services/memory_store.dart';
import '../widgets/rota_banner_ad.dart';
import '../widgets/world_map_widget.dart';
import 'country_detail_screen.dart';

class WorldScreen extends StatefulWidget {
  const WorldScreen({super.key});
  @override
  State<WorldScreen> createState() => _WorldScreenState();
}

class _WorldScreenState extends State<WorldScreen> {
  String _search = '';
  VisaStatus? _selectedFilter;
  final _searchCtrl = TextEditingController();

  List<Country> get _filtered {
    var list = passportCountries.toList();
    if (_selectedFilter != null) {
      list = list.where((c) => c.visaStatus == _selectedFilter).toList();
    }
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list.where((c) => c.name.toLowerCase().contains(q)).toList();
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
      backgroundColor: const Color(0xFF0F1923),
      bottomNavigationBar: const RotaBannerAd(),
      body: CustomScrollView(
        slivers: [
          // Dark App Bar
          SliverAppBar(
            expandedHeight: 0,
            pinned: true,
            backgroundColor: const Color(0xFF0F1923),
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                const Text('🇹🇷', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'PASAPORT GÜÇ PANELİ',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Hero Section - Passport + Stats
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                children: [
                  // Passport Image + Big Stats Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Passport visual
                      Container(
                        width: 100,
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFB71C1C), Color(0xFF880E0E)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFB71C1C,
                              ).withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 36,
                              height: 36,
                              child: CustomPaint(
                                painter: _CrescentStarPainter(
                                  color: Colors.amber.shade300,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'TÜRKİYE\nCUMHURİYETİ',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 7,
                                fontWeight: FontWeight.w600,
                                color: Colors.amber.shade200,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'PASAPORT',
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.amber.shade200,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Big stats
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                _BigStat(
                                  value: '$mobilityScore',
                                  label: 'Mobilite\nSkoru',
                                  color: const Color(0xFFD4AF37),
                                ),
                                const SizedBox(width: 12),
                                _BigStat(
                                  value: '#$passportRank',
                                  label: 'Dünya\nSırası',
                                  color: const Color(0xFF2ecc71),
                                ),
                                const SizedBox(width: 12),
                                _BigStat(
                                  value: '%$worldReach',
                                  label: 'Dünya\nErişimi',
                                  color: const Color(0xFF3498db),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Mobility Score Bar
                  _MobilityBar(),

                  const SizedBox(height: 16),

                  // Detailed Stats Grid
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2836),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF2A3A4A),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        _StatRow(
                          label: 'VİZESİZ',
                          value: '$visaFreeCount',
                          color: const Color(0xFF2ecc71),
                        ),
                        const Divider(color: Color(0xFF2A3A4A), height: 16),
                        _StatRow(
                          label: 'KAPIDA VİZE',
                          value: '$visaOnArrivalCount',
                          color: const Color(0xFF3498db),
                        ),
                        const Divider(color: Color(0xFF2A3A4A), height: 16),
                        _StatRow(
                          label: 'eTA (Electronic Travel Authorization)',
                          value: '$etaCount',
                          color: const Color(0xFFf1c40f),
                        ),
                        const Divider(color: Color(0xFF2A3A4A), height: 16),
                        _StatRow(
                          label: 'VİZE GEREKLİ',
                          value: '$visaRequiredCount',
                          color: const Color(0xFFe74c3c),
                        ),
                        const Divider(color: Color(0xFF2A3A4A), height: 16),
                        _StatRow(
                          label: 'KİMLİKLE',
                          value: '$idOnlyCount',
                          color: const Color(0xFF9b59b6),
                        ),
                        const Divider(color: Color(0xFF2A3A4A), height: 16),
                        _StatRow(
                          label: 'NÜFUS',
                          value: population,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Interactive World Map
          SliverToBoxAdapter(
            child: InteractiveWorldMap(
              onCountrySelected: (country) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CountryDetailScreen(country: country),
                  ),
                );
              },
            ),
          ),

          // Section Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Text(
                'VİZE GEREKSİNİMLERİ',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFD4AF37),
                  letterSpacing: 2,
                ),
              ),
            ),
          ),

          // Search + Filter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A2836),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF2A3A4A)),
                      ),
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (v) => setState(() => _search = v),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ülke ara...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF6B7B8F),
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: Color(0xFF6B7B8F),
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Filter dots
                  _FilterDot(
                    color: const Color(0xFF2ecc71),
                    status: VisaStatus.visaFree,
                    selected: _selectedFilter,
                    onTap: (s) => setState(
                      () => _selectedFilter = _selectedFilter == s ? null : s,
                    ),
                  ),
                  _FilterDot(
                    color: const Color(0xFF3498db),
                    status: VisaStatus.visaOnArrival,
                    selected: _selectedFilter,
                    onTap: (s) => setState(
                      () => _selectedFilter = _selectedFilter == s ? null : s,
                    ),
                  ),
                  _FilterDot(
                    color: const Color(0xFFf1c40f),
                    status: VisaStatus.eTA,
                    selected: _selectedFilter,
                    onTap: (s) => setState(
                      () => _selectedFilter = _selectedFilter == s ? null : s,
                    ),
                  ),
                  _FilterDot(
                    color: const Color(0xFFe74c3c),
                    status: VisaStatus.visaRequired,
                    selected: _selectedFilter,
                    onTap: (s) => setState(
                      () => _selectedFilter = _selectedFilter == s ? null : s,
                    ),
                  ),
                  _FilterDot(
                    color: const Color(0xFF9b59b6),
                    status: VisaStatus.idOnly,
                    selected: _selectedFilter,
                    onTap: (s) => setState(
                      () => _selectedFilter = _selectedFilter == s ? null : s,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Country List Header
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF1A2836),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'ÜLKE',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6B7B8F),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'VİZE DURUMU',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6B7B8F),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 36,
                    child: Text(
                      'GÜN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6B7B8F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Country List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((ctx, i) {
                final c = _filtered[i];
                return _CountryRow(
                  country: c,
                  isLast: i == _filtered.length - 1,
                );
              }, childCount: _filtered.length),
            ),
          ),
        ],
      ),
    );
  }
}

class _BigStat extends StatelessWidget {
  final String value, label;
  final Color color;
  const _BigStat({
    required this.value,
    required this.label,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2836),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: const Color(0xFF8899AA),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobilityBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final total =
        visaFreeCount + visaOnArrivalCount + etaCount + visaRequiredCount;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2836),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A3A4A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MOBİLİTE SKORU',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF6B7B8F),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 28,
              child: Row(
                children: [
                  _BarSegment(
                    value: visaFreeCount,
                    total: total,
                    color: const Color(0xFF2ecc71),
                    label: '$visaFreeCount',
                  ),
                  _BarSegment(
                    value: visaOnArrivalCount,
                    total: total,
                    color: const Color(0xFF3498db),
                    label: '$visaOnArrivalCount',
                  ),
                  _BarSegment(
                    value: etaCount,
                    total: total,
                    color: const Color(0xFFf1c40f),
                    label: '$etaCount',
                  ),
                  _BarSegment(
                    value: visaRequiredCount,
                    total: total,
                    color: const Color(0xFFe74c3c),
                    label: '$visaRequiredCount',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LegendDot(color: const Color(0xFF2ecc71), label: 'Vizesiz'),
              _LegendDot(color: const Color(0xFF3498db), label: 'Kapıda'),
              _LegendDot(color: const Color(0xFFf1c40f), label: 'eTA'),
              _LegendDot(color: const Color(0xFFe74c3c), label: 'Vizeli'),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarSegment extends StatelessWidget {
  final int value, total;
  final Color color;
  final String label;
  const _BarSegment({
    required this.value,
    required this.total,
    required this.color,
    required this.label,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: value,
      child: Container(
        color: color,
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: const Color(0xFF8899AA),
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatRow({
    required this.label,
    required this.value,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF8899AA),
              letterSpacing: 1,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _FilterDot extends StatelessWidget {
  final Color color;
  final VisaStatus status;
  final VisaStatus? selected;
  final void Function(VisaStatus) onTap;
  const _FilterDot({
    required this.color,
    required this.status,
    required this.selected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final isSelected = selected == status;
    return GestureDetector(
      onTap: () => onTap(status),
      child: Container(
        width: 28,
        height: 28,
        margin: const EdgeInsets.only(left: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.3),
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
      ),
    );
  }
}

class _CountryRow extends StatelessWidget {
  final Country country;
  final bool isLast;
  const _CountryRow({required this.country, required this.isLast});

  Color _statusBgColor(VisaStatus s) {
    switch (s) {
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

  String _statusLabel(VisaStatus s) {
    switch (s) {
      case VisaStatus.visaFree:
        return 'VİZESİZ';
      case VisaStatus.idOnly:
        return 'KİMLİKLE';
      case VisaStatus.visaOnArrival:
        return 'KAPIDA VİZE';
      case VisaStatus.eTA:
        return 'eTA';
      case VisaStatus.visaRequired:
        return 'VİZE GEREKLİ';
    }
  }

  String? _extractDays(String duration) {
    final match = RegExp(r'(\d+)').firstMatch(duration);
    return match?.group(1);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _statusBgColor(country.visaStatus);
    final days = _extractDays(country.duration);

    return AnimatedBuilder(
      animation: MemoryStore.instance,
      builder: (context, _) {
        final memoryCount = MemoryStore.instance
            .forCountry(country.code)
            .length;
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CountryDetailScreen(country: country),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: bgColor.withValues(alpha: 0.08),
              border: Border(
                bottom: isLast
                    ? BorderSide.none
                    : BorderSide(
                        color: const Color(0xFF2A3A4A).withValues(alpha: 0.5),
                      ),
                left: BorderSide(color: bgColor, width: 3),
              ),
              borderRadius: isLast
                  ? const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    )
                  : null,
            ),
            child: Row(
              children: [
                // Flag + Name
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Text(country.flag, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                country.name,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (memoryCount > 0) ...[
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.auto_awesome_rounded,
                                size: 13,
                                color: Color(0xFFFFD166),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _statusLabel(country.visaStatus),
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
                // Days
                SizedBox(
                  width: 36,
                  child: days != null
                      ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            days,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CrescentStarPainter extends CustomPainter {
  final Color color;
  const _CrescentStarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    // Draw crescent (ay) – positioned toward the left
    final center = Offset(size.width * 0.36, size.height * 0.5);
    final outerRadius = size.width * 0.34;
    final innerRadius = size.width * 0.27;
    // Inner circle is shifted right to create a crescent opening on the right
    final innerOffset = Offset(size.width * 0.44, size.height * 0.5);

    // Draw crescent using saveLayer + clear blend
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    canvas.drawCircle(center, outerRadius, paint);
    final clearPaint = Paint()..blendMode = BlendMode.clear;
    canvas.drawCircle(innerOffset, innerRadius, clearPaint);
    canvas.restore();

    // Draw star (yıldız) – placed OUTSIDE the crescent, to its right
    // Like the real Turkish flag: the star is between the crescent tips
    _drawStar(
      canvas,
      Offset(size.width * 0.72, size.height * 0.5),
      size.width * 0.13,
      size.width * 0.055,
      paint,
    );
  }

  void _drawStar(
    Canvas canvas,
    Offset center,
    double outerR,
    double innerR,
    Paint paint,
  ) {
    final path = Path();
    const angle = -math.pi / 2; // Start from top
    for (int i = 0; i < 5; i++) {
      final outerAngle = angle + (i * 2 * math.pi / 5);
      final innerAngle = angle + ((i + 0.5) * 2 * math.pi / 5);
      final outerX = center.dx + outerR * math.cos(outerAngle);
      final outerY = center.dy + outerR * math.sin(outerAngle);
      final innerX = center.dx + innerR * math.cos(innerAngle);
      final innerY = center.dy + innerR * math.sin(innerAngle);
      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
