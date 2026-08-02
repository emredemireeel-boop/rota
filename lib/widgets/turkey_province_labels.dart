import 'package:flutter/material.dart';

import '../data/turkey_data.dart';

/// Türkiye SVG haritasının üstüne, haritayla birlikte yakınlaşıp uzaklaşan
/// il adlarını yerleştirir.
class TurkeyProvinceLabels extends StatelessWidget {
  final Set<int> highlightedPlates;

  const TurkeyProvinceLabels({super.key, this.highlightedPlates = const {}});

  static const _minLongitude = 25.55;
  static const _maxLongitude = 44.85;
  static const _minLatitude = 35.75;
  static const _maxLatitude = 42.15;

  // Uzun adları okunamayacak kadar küçültmek yerine harita diline uygun,
  // yaygın ve anlaşılır kısa biçimler kullanılır.
  static const Map<int, String> _shortNames = {
    3: 'Afyon',
    46: 'K.Maraş',
    63: 'Ş.Urfa',
  };

  // Şehir merkezleri ile il geometrilerinin görsel merkezi her zaman aynı
  // değildir. Özellikle sıkışık bölgelerde birkaç piksellik düzeltme, etiketin
  // komşu ilin üstüne kaymasını önler.
  static const Map<int, Offset> _positionTweaks = {
    14: Offset(1, -2), // Bolu
    34: Offset(-2, -1), // İstanbul
    41: Offset(2, 1), // Kocaeli
    54: Offset(3, -1), // Sakarya
    69: Offset(0, -2), // Bayburt
    72: Offset(2, 1), // Batman
    77: Offset(1, 3), // Yalova
    79: Offset(-2, 3), // Kilis
    80: Offset(2, 1), // Osmaniye
    81: Offset(2, -2), // Düzce
  };

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mapWidth = constraints.maxWidth;
          final mapHeight = constraints.maxHeight;
          final scale = (mapWidth / 360).clamp(0.82, 1.18).toDouble();

          return Stack(
            clipBehavior: Clip.hardEdge,
            children: turkeyProvinces.map((province) {
              final rawX =
                  (province.lng - _minLongitude) /
                  (_maxLongitude - _minLongitude);
              final rawY =
                  (_maxLatitude - province.lat) / (_maxLatitude - _minLatitude);
              final highlighted = highlightedPlates.contains(
                province.plateCode,
              );
              final text = _shortNames[province.plateCode] ?? province.name;
              final labelWidth = (text.length > 8 ? 48.0 : 41.0) * scale;
              final labelHeight = 14.0 * scale;
              final tweak = _positionTweaks[province.plateCode] ?? Offset.zero;

              // Kenardaki illerin etiketlerini haritanın dışına taşırmamak için
              // koordinatlara küçük ve dengeli bir güvenli alan uygulanır.
              final x = 0.025 + rawX.clamp(0.0, 1.0).toDouble() * 0.95;
              final y = 0.045 + rawY.clamp(0.0, 1.0).toDouble() * 0.91;
              final left = (x * mapWidth - labelWidth / 2 + tweak.dx * scale)
                  .clamp(0.0, mapWidth - labelWidth)
                  .toDouble();
              final top = (y * mapHeight - labelHeight / 2 + tweak.dy * scale)
                  .clamp(0.0, mapHeight - labelHeight)
                  .toDouble();

              return Positioned(
                key: ValueKey('province-label-${province.plateCode}'),
                left: left,
                top: top,
                width: labelWidth,
                height: labelHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: highlighted
                        ? const Color(0xFF15805F).withValues(alpha: 0.94)
                        : Colors.white.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(4 * scale),
                    border: Border.all(
                      color: highlighted
                          ? Colors.white.withValues(alpha: 0.85)
                          : const Color(0xFFCAD5D0).withValues(alpha: 0.72),
                      width: 0.55,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: highlighted ? 0.18 : 0.08,
                        ),
                        blurRadius: highlighted ? 2.5 : 1.5,
                        offset: const Offset(0, 0.5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.5 * scale),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        text,
                        maxLines: 1,
                        style: TextStyle(
                          color: highlighted
                              ? Colors.white
                              : const Color(0xFF243B34),
                          fontSize: 8.1 * scale,
                          height: 1,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.12,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
