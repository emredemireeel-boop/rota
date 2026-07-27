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

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: turkeyProvinces.map((province) {
              final x =
                  (province.lng - _minLongitude) /
                  (_maxLongitude - _minLongitude);
              final y =
                  (_maxLatitude - province.lat) / (_maxLatitude - _minLatitude);
              final highlighted = highlightedPlates.contains(
                province.plateCode,
              );

              return Positioned(
                left: x * constraints.maxWidth - 19,
                top: y * constraints.maxHeight - 5,
                width: 38,
                height: 11,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    province.name,
                    maxLines: 1,
                    style: TextStyle(
                      color: highlighted
                          ? Colors.white
                          : const Color(0xFF263B35),
                      fontSize: 7,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(
                          color: highlighted
                              ? Colors.black.withValues(alpha: 0.65)
                              : Colors.white.withValues(alpha: 0.95),
                          blurRadius: 2,
                        ),
                      ],
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
