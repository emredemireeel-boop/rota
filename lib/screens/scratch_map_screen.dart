import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/passport_data.dart';
import '../data/turkey_data.dart';
import '../services/memory_store.dart';
import '../services/scratch_map_store.dart';
import '../widgets/rota_banner_ad.dart';
import '../theme/rota_theme.dart';
import '../widgets/turkey_province_labels.dart';

enum ScratchMapMode { turkey, world }

final Map<String, Country> _countriesByCode = {
  for (final country in passportCountries) country.code.toUpperCase(): country,
};

final Set<String> _worldCountryCodes = {
  ..._countriesByCode.keys.where(
    (code) => RegExp(r'^[A-Z]{2}$').hasMatch(code),
  ),
  'TR',
};

class ScratchMapScreen extends StatefulWidget {
  final ScratchMapMode initialMode;

  const ScratchMapScreen({super.key, this.initialMode = ScratchMapMode.turkey});

  @override
  State<ScratchMapScreen> createState() => _ScratchMapScreenState();
}

class _ScratchMapScreenState extends State<ScratchMapScreen> {
  static const _visitedColor = Color(0xFF22A06B);

  late ScratchMapMode _mode;
  late final Listenable _progressListenable;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
    _progressListenable = Listenable.merge([
      ScratchMapStore.instance,
      MemoryStore.instance,
    ]);
  }

  Set<int> get _visitedProvincePlates {
    return {
      ...ScratchMapStore.instance.provincePlates,
      ...MemoryStore.instance.visitedProvincePlates,
    }..removeAll(ScratchMapStore.instance.hiddenProvincePlates);
  }

  Set<String> get _visitedCountryCodes {
    final codes = {
      ...ScratchMapStore.instance.countryCodes.map(
        (code) => code.toUpperCase(),
      ),
      ...MemoryStore.instance.visitedCountryCodes.map(
        (code) => code.toUpperCase(),
      ),
    };
    if (_visitedProvincePlates.isNotEmpty) codes.add('TR');
    codes.removeAll(
      ScratchMapStore.instance.hiddenCountryCodes.map(
        (code) => code.toUpperCase(),
      ),
    );
    return codes;
  }

  Province? _provinceForMapId(String id, String name) {
    final normalizedId = id.toUpperCase().trim();
    if (normalizedId.startsWith('TR')) {
      final digits = normalizedId.replaceAll(RegExp(r'[^0-9]'), '');
      final plate = int.tryParse(digits);
      if (plate != null) {
        final matches = turkeyProvinces.where(
          (province) => province.plateCode == plate,
        );
        if (matches.isNotEmpty) return matches.first;
      }
    }
    final normalizedName = name.toLowerCase().trim();
    final matches = turkeyProvinces.where(
      (province) => province.name.toLowerCase() == normalizedName,
    );
    return matches.isEmpty ? null : matches.first;
  }

  String _countryCodeForMapId(String id) {
    return id.trim().toUpperCase();
  }

  String _countryName(String code, String fallback) {
    if (code == 'TR') return 'Türkiye';
    return _countriesByCode[code]?.name ?? fallback;
  }

  Map<String, Color> _turkeyColors(Set<int> visited) {
    final colors = <String, Color>{};
    for (final plate in visited) {
      final code = plate.toString().padLeft(2, '0');
      colors['TR-$code'] = _visitedColor;
      colors['tr-$code'] = _visitedColor;
      colors['TR$code'] = _visitedColor;
      colors[code] = _visitedColor;
    }
    return colors;
  }

  Map<String, Color> _worldColors(Set<String> visited) {
    return {
      for (final code in visited.where(_worldCountryCodes.contains))
        code.toLowerCase(): _visitedColor,
    };
  }

  Future<void> _scratchProvince(
    String id,
    String name,
    TapUpDetails details,
  ) async {
    final province = _provinceForMapId(id, name);
    if (province == null) return;
    await _toggleProvince(province);
  }

  Future<void> _toggleProvince(Province province) async {
    if (_visitedProvincePlates.contains(province.plateCode)) {
      final confirmed = await _confirmRemove(province.name, 'il');
      if (!confirmed) return;
      await ScratchMapStore.instance.unvisitProvince(province.plateCode);
      if (!mounted) return;
      _showRemoveSuccess(
        '${province.name} geri alındı.',
        onRestore: () =>
            ScratchMapStore.instance.scratchProvince(province.plateCode),
      );
      return;
    }

    final changed = await ScratchMapStore.instance.scratchProvince(
      province.plateCode,
    );
    if (!changed || !mounted) return;
    _showScratchSuccess(
      '${province.name} kazındı!',
      onUndo: () =>
          ScratchMapStore.instance.unvisitProvince(province.plateCode),
    );
  }

  Future<void> _scratchCountry(
    String id,
    String name,
    TapUpDetails details,
  ) async {
    final code = _countryCodeForMapId(id);
    if (!_worldCountryCodes.contains(code)) return;
    final displayName = _countryName(code, name);
    await _toggleCountry(code, displayName);
  }

  Future<void> _toggleCountry(String code, String displayName) async {
    if (_visitedCountryCodes.contains(code)) {
      final confirmed = await _confirmRemove(displayName, 'ülke');
      if (!confirmed) return;
      await ScratchMapStore.instance.unvisitCountry(code);
      if (!mounted) return;
      _showRemoveSuccess(
        '$displayName geri alındı.',
        onRestore: () => ScratchMapStore.instance.scratchCountry(code),
      );
      return;
    }

    final changed = await ScratchMapStore.instance.scratchCountry(code);
    if (!changed || !mounted) return;
    _showScratchSuccess(
      '$displayName kazındı!',
      onUndo: () => ScratchMapStore.instance.unvisitCountry(code),
    );
  }

  Future<bool> _confirmRemove(String name, String placeType) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.undo_rounded,
          color: Color(0xFFB45309),
          size: 34,
        ),
        title: const Text('Gez Kazı işaretini geri al'),
        content: Text(
          '$name için gezildi işaretini geri almak istediğinize emin misiniz? '
          'Kayıtlı fotoğraf ve videolarınız silinmez.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB45309),
            ),
            child: Text('$placeType işaretini geri al'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _openPlaceSearch() async {
    final place = await showSearch<_ScratchPlace?>(
      context: context,
      delegate: _ScratchPlaceSearchDelegate(
        mode: _mode,
        visitedProvincePlates: _visitedProvincePlates,
        visitedCountryCodes: _visitedCountryCodes,
      ),
    );
    if (place == null || !mounted) return;
    if (place.mode == ScratchMapMode.turkey) {
      final matches = turkeyProvinces.where(
        (province) => province.plateCode == place.provincePlate,
      );
      if (matches.isNotEmpty) await _toggleProvince(matches.first);
    } else {
      await _toggleCountry(place.countryCode!, place.name);
    }
  }

  void _showScratchSuccess(String message, {required VoidCallback onUndo}) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF153F35),
          content: Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: Color(0xFFFFD166)),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          action: SnackBarAction(
            label: 'Geri al',
            textColor: const Color(0xFFFFD166),
            onPressed: onUndo,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _showRemoveSuccess(String message, {required VoidCallback onRestore}) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('$message Fotoğraf ve videoların korundu.'),
          action: SnackBarAction(label: 'Yeniden ekle', onPressed: onRestore),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RotaColors.cream,
      bottomNavigationBar: const RotaBannerAd(),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _progressListenable,
          builder: (context, _) {
            final provinces = _visitedProvincePlates;
            final countries = _visitedCountryCodes
                .where(_worldCountryCodes.contains)
                .toSet();
            final currentCount = _mode == ScratchMapMode.turkey
                ? provinces.length
                : countries.length;
            final totalCount = _mode == ScratchMapMode.turkey
                ? turkeyProvinces.length
                : _worldCountryCodes.length;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                _JourneyHeader(onBack: () => Navigator.pop(context)),
                const SizedBox(height: 12),
                _ModeSelector(
                  mode: _mode,
                  onChanged: (mode) => setState(() => _mode = mode),
                ),
                const SizedBox(height: 12),
                _PlaceSearchButton(mode: _mode, onTap: _openPlaceSearch),
                const SizedBox(height: 14),
                _ScratchMapCard(
                  mode: _mode,
                  turkeyColors: _turkeyColors(provinces),
                  worldColors: _worldColors(countries),
                  visitedProvincePlates: provinces,
                  visitedCount: currentCount,
                  onProvinceTap: _scratchProvince,
                  onCountryTap: _scratchCountry,
                ),
                const SizedBox(height: 14),
                _ProgressHero(
                  mode: _mode,
                  currentCount: currentCount,
                  totalCount: totalCount,
                ),
                const SizedBox(height: 14),
                _VisitedPlaces(
                  mode: _mode,
                  provincePlates: provinces,
                  countryCodes: countries,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _JourneyHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _JourneyHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 56,
            top: 8,
            child: Icon(
              Icons.air_rounded,
              size: 27,
              color: RotaColors.sage.withValues(alpha: 0.35),
            ),
          ),
          Positioned(
            right: 48,
            bottom: 2,
            child: Icon(
              Icons.landscape_rounded,
              size: 54,
              color: RotaColors.sage.withValues(alpha: 0.22),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton.filledTonal(
              onPressed: onBack,
              tooltip: 'Geri',
              style: IconButton.styleFrom(
                backgroundColor: RotaColors.paper,
                foregroundColor: RotaColors.ink,
              ),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Gez Kazı',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 42,
                  height: 1,
                  color: RotaColors.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Gezdiğin yerleri yeşile çevir',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: RotaColors.forest,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressHero extends StatelessWidget {
  final ScratchMapMode mode;
  final int currentCount;
  final int totalCount;

  const _ProgressHero({
    required this.mode,
    required this.currentCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalCount == 0 ? 0.0 : currentCount / totalCount;
    final percent = (progress * 100).round();
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: RotaColors.paper,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: RotaColors.mist),
        boxShadow: [
          BoxShadow(
            color: RotaColors.ink.withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: RotaColors.mist,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: RotaColors.forest,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mode == ScratchMapMode.turkey
                          ? 'Türkiye Yolculuğum'
                          : 'Dünya Yolculuğum',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: RotaColors.ink,
                      ),
                    ),
                    Text(
                      '$currentCount / $totalCount '
                      '${mode == ScratchMapMode.turkey ? 'il' : 'ülke'} kazındı',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: RotaColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '%$percent',
                style: GoogleFonts.outfit(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: RotaColors.forest,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: RotaColors.mist,
              valueColor: const AlwaysStoppedAnimation(RotaColors.forest),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeSelector extends StatelessWidget {
  final ScratchMapMode mode;
  final ValueChanged<ScratchMapMode> onChanged;

  const _ModeSelector({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: RotaColors.paper,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          _ModeButton(
            label: 'Türkiye',
            icon: Icons.location_on_rounded,
            selected: mode == ScratchMapMode.turkey,
            onTap: () => onChanged(ScratchMapMode.turkey),
          ),
          _ModeButton(
            label: 'Dünya',
            icon: Icons.public_rounded,
            selected: mode == ScratchMapMode.world,
            onTap: () => onChanged(ScratchMapMode.world),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? RotaColors.ink : Colors.transparent,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          borderRadius: BorderRadius.circular(13),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? Colors.white : const Color(0xFF697A75),
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : const Color(0xFF697A75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceSearchButton extends StatelessWidget {
  final ScratchMapMode mode;
  final VoidCallback onTap;

  const _PlaceSearchButton({required this.mode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isTurkey = mode == ScratchMapMode.turkey;
    return Material(
      color: RotaColors.paper,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDDE6E1)),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, color: Color(0xFF153F35)),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  isTurkey ? 'İl adı veya plaka ara' : 'Ülke adı ara',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF71807C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: Color(0xFFA2AEA9),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScratchMapCard extends StatelessWidget {
  final ScratchMapMode mode;
  final Map<String, Color> turkeyColors;
  final Map<String, Color> worldColors;
  final Set<int> visitedProvincePlates;
  final int visitedCount;
  final void Function(String, String, TapUpDetails) onProvinceTap;
  final void Function(String, String, TapUpDetails) onCountryTap;

  const _ScratchMapCard({
    required this.mode,
    required this.turkeyColors,
    required this.worldColors,
    required this.visitedProvincePlates,
    required this.visitedCount,
    required this.onProvinceTap,
    required this.onCountryTap,
  });

  @override
  Widget build(BuildContext context) {
    final isTurkey = mode == ScratchMapMode.turkey;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 15, 12, 12),
      decoration: BoxDecoration(
        color: RotaColors.sea,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.touch_app_rounded,
                size: 20,
                color: Color(0xFFB56D40),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isTurkey
                      ? 'Gezdiğin ili kazımak için haritaya dokun'
                      : 'Gezdiğin ülkeyi kazımak için haritaya dokun',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF52645F),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: isTurkey ? 315 : 330,
            child: InteractiveViewer(
              minScale: 1,
              maxScale: isTurkey ? 9 : 7,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                child: Stack(
                  key: ValueKey('${mode.name}:$visitedCount'),
                  fit: StackFit.expand,
                  children: [
                    SimpleMap(
                      instructions: isTurkey
                          ? SMapTurkey.instructions
                          : SMapWorld.instructions,
                      defaultColor: const Color(0xFFE8E8E2),
                      colors: isTurkey ? turkeyColors : worldColors,
                      callback: isTurkey ? onProvinceTap : onCountryTap,
                    ),
                    if (isTurkey)
                      TurkeyProvinceLabels(
                        highlightedPlates: visitedProvincePlates,
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _LegendItem(color: Color(0xFFD5DBDF), label: 'Kazınmadı'),
              const SizedBox(width: 22),
              const _LegendItem(color: Color(0xFF22A06B), label: 'Gezildi'),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF71807C),
          ),
        ),
      ],
    );
  }
}

class _VisitedPlaces extends StatelessWidget {
  final ScratchMapMode mode;
  final Set<int> provincePlates;
  final Set<String> countryCodes;

  const _VisitedPlaces({
    required this.mode,
    required this.provincePlates,
    required this.countryCodes,
  });

  List<String> get _names {
    if (mode == ScratchMapMode.turkey) {
      final provinces =
          turkeyProvinces
              .where((province) => provincePlates.contains(province.plateCode))
              .toList()
            ..sort((a, b) => a.name.compareTo(b.name));
      return provinces.map((province) => province.name).toList();
    }
    final names = countryCodes.map((code) {
      if (code == 'TR') return 'Türkiye';
      return _countriesByCode[code]?.name ?? code;
    }).toList()..sort();
    return names;
  }

  @override
  Widget build(BuildContext context) {
    final names = _names;
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE1E8E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_rounded, color: Color(0xFF22A06B)),
              const SizedBox(width: 8),
              Text(
                'Kazıdıklarım',
                style: GoogleFonts.outfit(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF263B35),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          if (names.isEmpty)
            Text(
              'Henüz bir yer kazımadın. Haritadaki gri bir alana dokunarak başla.',
              style: GoogleFonts.inter(
                height: 1.4,
                color: const Color(0xFF71807C),
              ),
            )
          else
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: names
                  .map(
                    (name) => Chip(
                      avatar: const Icon(
                        Icons.check_circle_rounded,
                        size: 17,
                        color: Color(0xFF22A06B),
                      ),
                      label: Text(name),
                      backgroundColor: const Color(0xFFEAF7F0),
                      side: BorderSide.none,
                      labelStyle: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF246149),
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _ScratchPlace {
  final ScratchMapMode mode;
  final String name;
  final String subtitle;
  final int? provincePlate;
  final String? countryCode;

  _ScratchPlace.province(Province province)
    : mode = ScratchMapMode.turkey,
      name = province.name,
      subtitle = '${province.plateCode} plaka • ${province.region}',
      provincePlate = province.plateCode,
      countryCode = null;

  const _ScratchPlace.country({
    required this.name,
    required this.subtitle,
    required String code,
  }) : mode = ScratchMapMode.world,
       provincePlate = null,
       countryCode = code;
}

class _ScratchPlaceSearchDelegate extends SearchDelegate<_ScratchPlace?> {
  final ScratchMapMode mode;
  final Set<int> visitedProvincePlates;
  final Set<String> visitedCountryCodes;

  _ScratchPlaceSearchDelegate({
    required this.mode,
    required this.visitedProvincePlates,
    required this.visitedCountryCodes,
  }) : super(
         searchFieldLabel: mode == ScratchMapMode.turkey
             ? 'İl adı veya plaka yaz'
             : 'Ülke adı yaz',
         keyboardType: TextInputType.text,
       );

  List<_ScratchPlace> get _places {
    if (mode == ScratchMapMode.turkey) {
      final provinces = [...turkeyProvinces]
        ..sort((a, b) => a.name.compareTo(b.name));
      return provinces.map(_ScratchPlace.province).toList();
    }

    final places = <_ScratchPlace>[
      const _ScratchPlace.country(
        name: 'Türkiye',
        subtitle: 'Avrupa • Asya',
        code: 'TR',
      ),
      ..._countriesByCode.entries
          .where(
            (entry) =>
                entry.key != 'TR' && _worldCountryCodes.contains(entry.key),
          )
          .map(
            (entry) => _ScratchPlace.country(
              name: entry.value.name,
              subtitle: entry.value.continent,
              code: entry.key,
            ),
          ),
    ];
    places.sort((a, b) => a.name.compareTo(b.name));
    return places;
  }

  List<_ScratchPlace> get _filteredPlaces {
    final normalizedQuery = _normalizeSearch(query);
    if (normalizedQuery.isEmpty) return _places;
    return _places.where((place) {
      final plate = place.provincePlate?.toString() ?? '';
      return _normalizeSearch(place.name).contains(normalizedQuery) ||
          _normalizeSearch(place.subtitle).contains(normalizedQuery) ||
          plate == normalizedQuery;
    }).toList();
  }

  bool _isVisited(_ScratchPlace place) {
    if (place.mode == ScratchMapMode.turkey) {
      return visitedProvincePlates.contains(place.provincePlate);
    }
    return visitedCountryCodes.contains(place.countryCode);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          tooltip: 'Temizle',
          onPressed: () => query = '',
          icon: const Icon(Icons.close_rounded),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Geri',
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildPlaceList();

  @override
  Widget buildSuggestions(BuildContext context) => _buildPlaceList();

  Widget _buildPlaceList() {
    final places = _filteredPlaces;
    if (places.isEmpty) {
      return const Center(child: Text('Aradığın yer bulunamadı.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: places.length,
      separatorBuilder: (_, _) => const Divider(height: 1, indent: 68),
      itemBuilder: (context, index) {
        final place = places[index];
        final visited = _isVisited(place);
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: visited
                ? const Color(0xFFE4F6EC)
                : const Color(0xFFF0F3F2),
            child: Icon(
              visited ? Icons.check_rounded : Icons.location_on_outlined,
              color: visited
                  ? const Color(0xFF22A06B)
                  : const Color(0xFF71807C),
            ),
          ),
          title: Text(
            place.name,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            visited
                ? '${place.subtitle} • Gezildi; geri almak için seç'
                : '${place.subtitle} • Gez Kazı’ya ekle',
          ),
          onTap: () => close(context, place),
        );
      },
    );
  }
}

String _normalizeSearch(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll('ç', 'c')
      .replaceAll('ğ', 'g')
      .replaceAll('ı', 'i')
      .replaceAll('ö', 'o')
      .replaceAll('ş', 's')
      .replaceAll('ü', 'u');
}
