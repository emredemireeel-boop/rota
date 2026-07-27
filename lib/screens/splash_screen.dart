import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'turkey_screen.dart';
import 'world_screen.dart';
import 'media_map_screen.dart';
import 'scratch_map_screen.dart';
import '../services/memory_store.dart';
import '../services/scratch_map_store.dart';
import '../widgets/ad_free_purchase_button.dart';
import '../widgets/rota_banner_ad.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _cardsFade;
  late Animation<Offset> _turkeySlide;
  late Animation<Offset> _worldSlide;
  late final Listenable _scratchProgress;

  @override
  void initState() {
    super.initState();
    _scratchProgress = Listenable.merge([
      ScratchMapStore.instance,
      MemoryStore.instance,
    ]);
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _logoFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );
    _logoScale = Tween(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );
    _cardsFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
      ),
    );
    _turkeySlide = Tween(begin: const Offset(-1.0, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.5, 0.85, curve: Curves.easeOutCubic),
          ),
        );
    _worldSlide = Tween(begin: const Offset(1.0, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.5, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _goTo(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const RotaBannerAd(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFF0F7FF), Color(0xFFE8F4FD)],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (context, _) {
              return Column(
                children: [
                  const Spacer(flex: 2),
                  // Logo only - no text
                  Opacity(
                    opacity: _logoFade.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF2B8FBF,
                              ).withValues(alpha: 0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                  // Title
                  Opacity(
                    opacity: _cardsFade.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            'Rotan nereye?',
                            style: GoogleFonts.outfit(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A2B4A),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: AdFreePurchaseButton(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Cards with real map visuals
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        // Turkey Card
                        Expanded(
                          child: Transform.translate(
                            offset: Offset(
                              _turkeySlide.value.dx *
                                  MediaQuery.of(context).size.width *
                                  0.5,
                              0,
                            ),
                            child: Opacity(
                              opacity: _cardsFade.value,
                              child: _RouteCard(
                                title: 'Türkiye',
                                subtitle: '81 İl Keşfet',
                                icon: '🇹🇷',
                                colors: const [
                                  Color(0xFFE30A17),
                                  Color(0xFFCE0A14),
                                ],
                                mapWidget: _buildTurkeyMiniMap(),
                                onTap: () => _goTo(const TurkeyScreen()),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // World Card
                        Expanded(
                          child: Transform.translate(
                            offset: Offset(
                              _worldSlide.value.dx *
                                  MediaQuery.of(context).size.width *
                                  0.5,
                              0,
                            ),
                            child: Opacity(
                              opacity: _cardsFade.value,
                              child: _RouteCard(
                                title: 'Dünya',
                                subtitle: 'Pasaport Gücü',
                                icon: '🌍',
                                colors: const [
                                  Color(0xFF2B8FBF),
                                  Color(0xFF1A6B9C),
                                ],
                                mapWidget: _buildWorldMiniMap(),
                                onTap: () => _goTo(const WorldScreen()),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Opacity(
                    opacity: _cardsFade.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: AnimatedBuilder(
                        animation: _scratchProgress,
                        builder: (context, _) {
                          final provinces = {
                            ...ScratchMapStore.instance.provincePlates,
                            ...MemoryStore.instance.visitedProvincePlates,
                          };
                          final countries = {
                            ...ScratchMapStore.instance.countryCodes,
                            ...MemoryStore.instance.visitedCountryCodes,
                          };
                          if (provinces.isNotEmpty) countries.add('TR');
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _goTo(const ScratchMapScreen()),
                              borderRadius: BorderRadius.circular(18),
                              child: Ink(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF153F35),
                                      Color(0xFF24745B),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF153F35,
                                      ).withValues(alpha: 0.2),
                                      blurRadius: 16,
                                      offset: const Offset(0, 7),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.12,
                                        ),
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      child: const Icon(
                                        Icons.auto_awesome_rounded,
                                        color: Color(0xFFFFD166),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Gez Kazı Haritası',
                                            style: GoogleFonts.outfit(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            '${provinces.length}/81 il • '
                                            '${countries.length} ülke kazındı',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: Colors.white.withValues(
                                                alpha: 0.7,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Opacity(
                    opacity: _cardsFade.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: AnimatedBuilder(
                        animation: MemoryStore.instance,
                        builder: (context, _) {
                          final count = MemoryStore.instance.memories.length;
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _goTo(const MediaMapScreen()),
                              borderRadius: BorderRadius.circular(18),
                              child: Ink(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 13,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF183D3D),
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF183D3D,
                                      ).withValues(alpha: 0.22),
                                      blurRadius: 16,
                                      offset: const Offset(0, 7),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.12,
                                        ),
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      child: const Icon(
                                        Icons.add_location_alt_rounded,
                                        color: Color(0xFFFFD166),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Medya Haritam',
                                            style: GoogleFonts.outfit(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            count == 0
                                                ? 'Fotoğraf ve videonu haritaya ekle'
                                                : '$count medya • haritada ve galeride gör',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: Colors.white.withValues(
                                                alpha: 0.68,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTurkeyMiniMap() {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.15,
        child: SimpleMap(
          instructions: SMapTurkey.instructions,
          defaultColor: Colors.white,
          colors: const {},
        ),
      ),
    );
  }

  Widget _buildWorldMiniMap() {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.12,
        child: SimpleMap(
          instructions: SMapWorld.instructions,
          defaultColor: Colors.white,
          colors: const {},
        ),
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  final String title, subtitle, icon;
  final List<Color> colors;
  final VoidCallback onTap;
  final Widget? mapWidget;
  const _RouteCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    required this.onTap,
    this.mapWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          height: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: colors.first.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Real map background
              if (mapWidget != null)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: mapWidget,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(icon, style: const TextStyle(fontSize: 40)),
                    const Spacer(),
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
