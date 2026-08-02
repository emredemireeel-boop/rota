import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/memory_store.dart';
import '../services/scratch_map_store.dart';
import '../theme/rota_theme.dart';
import '../widgets/rota_banner_ad.dart';
import 'media_map_screen.dart';
import 'memories_screen.dart';
import 'scratch_map_screen.dart';
import 'turkey_screen.dart';
import 'world_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;
  late final Listenable _travelData;

  static const _dailyRoutes =
      <({String title, String subtitle, IconData icon})>[
        (
          title: 'Ege kıyılarında gün batımı',
          subtitle: 'İzmir, Aydın ve Muğla rotanı tamamla',
          icon: Icons.wb_twilight_rounded,
        ),
        (
          title: 'Tarihin izinde',
          subtitle: 'Bir şehir seç, ilk anını haritaya bırak',
          icon: Icons.account_balance_rounded,
        ),
        (
          title: 'Yeni bir ülkeye merhaba',
          subtitle: 'Dünya haritasından sıradaki rotanı keşfet',
          icon: Icons.flight_takeoff_rounded,
        ),
        (
          title: 'Doğaya kaçış',
          subtitle: 'Yeşil bir rota seç ve Gez Kazı haritanı büyüt',
          icon: Icons.forest_rounded,
        ),
      ];

  @override
  void initState() {
    super.initState();
    _travelData = Listenable.merge([
      MemoryStore.instance,
      ScratchMapStore.instance,
    ]);
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  void _goTo(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  Set<int> get _provincePlates => {
    ...ScratchMapStore.instance.provincePlates,
    ...MemoryStore.instance.visitedProvincePlates,
  };

  Set<String> get _countryCodes {
    final countries = {
      ...ScratchMapStore.instance.countryCodes,
      ...MemoryStore.instance.visitedCountryCodes,
    };
    if (_provincePlates.isNotEmpty) countries.add('TR');
    return countries;
  }

  void _showInfo() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: RotaColors.paper,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yolculuğun artık tek yerde',
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 28,
                color: RotaColors.ink,
              ),
            ),
            const SizedBox(height: 12),
            const _InfoRow(
              icon: Icons.auto_awesome_rounded,
              title: 'Gez Kazı',
              text: 'Gezdiğin il ve ülkeleri yeşile çevir.',
            ),
            const _InfoRow(
              icon: Icons.photo_library_rounded,
              title: 'Medya Haritam',
              text: 'Fotoğraf ve videolarını konumunda biriktir.',
            ),
            const _InfoRow(
              icon: Icons.shield_outlined,
              title: 'Güvenli reklam testi',
              text: 'Bu sürüm yalnızca Google demo reklamlarını kullanır.',
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RotaColors.cream,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const RotaBannerAd(),
          _HomeNavigation(onOpen: _goTo),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: AnimatedBuilder(
          animation: Listenable.merge([_entrance, _travelData]),
          builder: (context, _) {
            final animation = CurvedAnimation(
              parent: _entrance,
              curve: Curves.easeOutCubic,
            );
            final memories = MemoryStore.instance.memories;
            final provinces = _provincePlates;
            final countries = _countryCodes;
            final route =
                _dailyRoutes[DateTime.now().day % _dailyRoutes.length];
            return FadeTransition(
              opacity: animation,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 34),
                children: [
                  _HomeHeader(onInfo: _showInfo),
                  const SizedBox(height: 18),
                  _HeroMap(
                    provinceCount: provinces.length,
                    countryCount: countries.length,
                    memoryCount: memories.length,
                    onTap: () => _goTo(const MediaMapScreen()),
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle(
                    eyebrow: 'KEŞFET',
                    title: 'Rotanı nerede büyüteceksin?',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _DestinationCard(
                          image: 'assets/images/rota_turkiye_card.png',
                          title: 'Türkiye',
                          subtitle: '${provinces.length} / 81 il',
                          icon: Icons.location_on_rounded,
                          onTap: () => _goTo(const TurkeyScreen()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DestinationCard(
                          image: 'assets/images/rota_dunya_card.png',
                          title: 'Dünya',
                          subtitle: '${countries.length} ülke',
                          icon: Icons.public_rounded,
                          onTap: () => _goTo(const WorldScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _ScratchFeature(
                    provinceCount: provinces.length,
                    countryCount: countries.length,
                    onTap: () => _goTo(const ScratchMapScreen()),
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle(
                    eyebrow: 'SEYAHAT ÖZETİ',
                    title: 'Biriktirdiğin izler',
                  ),
                  const SizedBox(height: 12),
                  _StatsRow(
                    provinceCount: provinces.length,
                    countryCount: countries.length,
                    memoryCount: memories.length,
                    favoriteCount: MemoryStore.instance.favoriteCount,
                  ),
                  const SizedBox(height: 20),
                  _DailyRouteCard(
                    route: route,
                    completed: math.min(provinces.length + countries.length, 3),
                    onTap: () => _goTo(const ScratchMapScreen()),
                  ),
                  const SizedBox(height: 20),
                  _MediaFeature(
                    memoryCount: memories.length,
                    favoriteCount: MemoryStore.instance.favoriteCount,
                    onTap: () => _goTo(const MediaMapScreen()),
                  ),
                  const SizedBox(height: 24),
                  _Achievements(
                    provinceCount: provinces.length,
                    countryCount: countries.length,
                    memoryCount: memories.length,
                    favoriteCount: MemoryStore.instance.favoriteCount,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final VoidCallback onInfo;

  const _HomeHeader({required this.onInfo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 54,
          height: 54,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: RotaColors.ink,
            borderRadius: BorderRadius.circular(17),
            boxShadow: RotaShadows.soft(),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset('assets/logo.png', fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rota Dünya',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 29,
                  height: 1,
                  color: RotaColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Anılarını haritada biriktir',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: RotaColors.forest,
                ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          onPressed: onInfo,
          tooltip: 'Rota Dünya hakkında',
          style: IconButton.styleFrom(
            backgroundColor: RotaColors.paper,
            foregroundColor: RotaColors.ink,
          ),
          icon: const Icon(Icons.tune_rounded),
        ),
      ],
    );
  }
}

class _HeroMap extends StatelessWidget {
  final int provinceCount;
  final int countryCount;
  final int memoryCount;
  final VoidCallback onTap;

  const _HeroMap({
    required this.provinceCount,
    required this.countryCount,
    required this.memoryCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Medya haritamı aç',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 244,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: RotaShadows.soft(),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/rota_world_hero.png',
                fit: BoxFit.cover,
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xE6073032)],
                    stops: [0.28, 1],
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: RotaColors.paper.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.explore_rounded,
                        size: 16,
                        color: RotaColors.forest,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'CANLI ROTA PANOSU',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.7,
                          color: RotaColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 17,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memoryCount == 0
                          ? 'İlk anın için dünya hazır'
                          : '$memoryCount anı, tek bir büyük hikâye',
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 25,
                        height: 1.08,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _HeroStat(value: '$provinceCount', label: 'il'),
                        const _HeroDivider(),
                        _HeroStat(value: '$countryCount', label: 'ülke'),
                        const _HeroDivider(),
                        _HeroStat(value: '$memoryCount', label: 'anı'),
                        const Spacer(),
                        const CircleAvatar(
                          radius: 19,
                          backgroundColor: RotaColors.gold,
                          foregroundColor: RotaColors.ink,
                          child: Icon(Icons.arrow_outward_rounded, size: 20),
                        ),
                      ],
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

class _HeroStat extends StatelessWidget {
  final String value;
  final String label;

  const _HeroStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: value,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        children: [
          TextSpan(
            text: ' $label',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}

class _HeroDivider extends StatelessWidget {
  const _HeroDivider();

  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 17,
    margin: const EdgeInsets.symmetric(horizontal: 10),
    color: Colors.white.withValues(alpha: 0.25),
  );
}

class _SectionTitle extends StatelessWidget {
  final String eyebrow;
  final String title;

  const _SectionTitle({required this.eyebrow, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.3,
            color: RotaColors.forest,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.dmSerifDisplay(
            fontSize: 25,
            height: 1.1,
            color: RotaColors.ink,
          ),
        ),
      ],
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _DestinationCard({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Ink(
          height: 205,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
            boxShadow: RotaShadows.soft(),
          ),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xF2073536)],
                stops: [0.38, 1],
              ),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: RotaColors.forest,
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 24,
                    height: 1,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScratchFeature extends StatelessWidget {
  final int provinceCount;
  final int countryCount;
  final VoidCallback onTap;

  const _ScratchFeature({
    required this.provinceCount,
    required this.countryCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE7EEDA), Color(0xFFF9F2D9)],
            ),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: RotaColors.sage.withValues(alpha: 0.4)),
            boxShadow: RotaShadows.soft(RotaColors.forest),
          ),
          child: Row(
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: RotaColors.forest,
                  border: Border.all(color: RotaColors.paper, width: 5),
                ),
                child: const Icon(
                  Icons.eco_rounded,
                  color: RotaColors.cream,
                  size: 31,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gez Kazı',
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 27,
                        height: 1,
                        color: RotaColors.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      provinceCount + countryCount == 0
                          ? 'Gezdiğin yerleri yeşile çevir'
                          : '$provinceCount il ve $countryCount ülke yeşillendi',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: RotaColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded, color: RotaColors.ink),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int provinceCount;
  final int countryCount;
  final int memoryCount;
  final int favoriteCount;

  const _StatsRow({
    required this.provinceCount,
    required this.countryCount,
    required this.memoryCount,
    required this.favoriteCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            value: '$provinceCount',
            label: 'İl',
            icon: Icons.map_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatTile(
            value: '$countryCount',
            label: 'Ülke',
            icon: Icons.public_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatTile(
            value: '$memoryCount',
            label: 'Anı',
            icon: Icons.photo_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatTile(
            value: '$favoriteCount',
            label: 'Favori',
            icon: Icons.favorite_rounded,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatTile({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 5),
      decoration: BoxDecoration(
        color: RotaColors.paper,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: RotaColors.mist),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: RotaColors.forest),
          const SizedBox(height: 5),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 19,
              height: 1,
              fontWeight: FontWeight.w900,
              color: RotaColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: RotaColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyRouteCard extends StatelessWidget {
  final ({String title, String subtitle, IconData icon}) route;
  final int completed;
  final VoidCallback onTap;

  const _DailyRouteCard({
    required this.route,
    required this.completed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: RotaColors.ink,
        borderRadius: BorderRadius.circular(24),
        boxShadow: RotaShadows.soft(),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(route.icon, color: RotaColors.gold),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GÜNÜN ROTA FİKRİ',
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                    color: RotaColors.gold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  route.title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  route.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    height: 1.3,
                    color: Colors.white.withValues(alpha: 0.66),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onTap,
            color: Colors.white,
            icon: const Icon(Icons.arrow_outward_rounded),
          ),
        ],
      ),
    );
  }
}

class _MediaFeature extends StatelessWidget {
  final int memoryCount;
  final int favoriteCount;
  final VoidCallback onTap;

  const _MediaFeature({
    required this.memoryCount,
    required this.favoriteCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: RotaColors.paper,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: RotaColors.mist),
          ),
          child: Row(
            children: [
              Container(
                width: 53,
                height: 53,
                decoration: BoxDecoration(
                  color: RotaColors.sea,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.add_a_photo_rounded,
                  color: RotaColors.ink,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Medya Haritam',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: RotaColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      memoryCount == 0
                          ? 'Fotoğraf ve videonu konumuna bırak'
                          : '$memoryCount anı • $favoriteCount favori',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: RotaColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: RotaColors.ink),
            ],
          ),
        ),
      ),
    );
  }
}

class _Achievements extends StatelessWidget {
  final int provinceCount;
  final int countryCount;
  final int memoryCount;
  final int favoriteCount;

  const _Achievements({
    required this.provinceCount,
    required this.countryCount,
    required this.memoryCount,
    required this.favoriteCount,
  });

  @override
  Widget build(BuildContext context) {
    final badges = [
      ('İlk Rota', Icons.flag_rounded, provinceCount + countryCount > 0),
      ('Şehir Avcısı', Icons.location_city_rounded, provinceCount >= 10),
      ('Dünya Gezgini', Icons.flight_rounded, countryCount >= 5),
      ('Anı Ustası', Icons.collections_rounded, memoryCount >= 10),
      ('Kalpten', Icons.favorite_rounded, favoriteCount >= 5),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          eyebrow: 'ROTA ROZETLERİ',
          title: 'Yolculuğun başarıları',
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 91,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: badges.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final badge = badges[index];
              return Container(
                width: 92,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: badge.$3 ? RotaColors.ink : RotaColors.paper,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: RotaColors.mist),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      badge.$2,
                      color: badge.$3 ? RotaColors.gold : Colors.black26,
                    ),
                    const SizedBox(height: 7),
                    Text(
                      badge.$1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: badge.$3 ? Colors.white : RotaColors.textMuted,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HomeNavigation extends StatelessWidget {
  final void Function(Widget) onOpen;

  const _HomeNavigation({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: RotaColors.paper,
      elevation: 14,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Row(
            children: [
              const Expanded(
                child: _NavItem(
                  icon: Icons.explore_rounded,
                  label: 'Keşfet',
                  selected: true,
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.map_outlined,
                  label: 'Harita',
                  onTap: () => onOpen(const ScratchMapScreen()),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.favorite_border_rounded,
                  label: 'Anılar',
                  onTap: () => onOpen(const MemoriesScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: selected ? RotaColors.ink : RotaColors.textMuted),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
              color: selected ? RotaColors.ink : RotaColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _InfoRow({required this.icon, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: RotaColors.mist,
            foregroundColor: RotaColors.forest,
            child: Icon(icon, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 12,
                    color: RotaColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
