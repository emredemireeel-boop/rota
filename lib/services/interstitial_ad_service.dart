import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ad_mob_service.dart';

class RotaInterstitialAdService {
  RotaInterstitialAdService._();

  static final RotaInterstitialAdService instance =
      RotaInterstitialAdService._();

  static const _productionAdUnitId = 'ca-app-pub-2265053267835785/3323007762';
  static const _iosTestAdUnitId = 'ca-app-pub-3940256099942544/4411468910';
  static const _saveCountKey = 'rota_interstitial_media_save_count_v1';
  static const _thresholdKey = 'rota_interstitial_media_threshold_v1';
  static const _lastShownAtKey = 'rota_interstitial_last_shown_at_v1';
  static const _minimumInterval = Duration(minutes: 2);
  static const _maximumAdAge = Duration(minutes: 55);

  final Random _random = Random();
  InterstitialAd? _interstitialAd;
  DateTime? _loadedAt;
  bool _initialized = false;
  bool _loading = false;
  bool _showing = false;

  String get _adUnitId => kReleaseMode ? _productionAdUnitId : _iosTestAdUnitId;

  void initialize() {
    if (_initialized || !AdMobService.instance.isSupported) return;
    _initialized = true;
    AdMobService.instance.addListener(_handleAdServiceChanged);
    _loadIfPossible();
  }

  void _handleAdServiceChanged() => _loadIfPossible();

  Future<void> registerSuccessfulMediaSave() async {
    if (!AdMobService.instance.isSupported) return;

    final preferences = await SharedPreferences.getInstance();
    final saveCount = (preferences.getInt(_saveCountKey) ?? 0) + 1;
    await preferences.setInt(_saveCountKey, saveCount);

    final storedThreshold = preferences.getInt(_thresholdKey);
    final threshold = storedThreshold == 3 || storedThreshold == 4
        ? storedThreshold!
        : _nextThreshold();
    if (storedThreshold != threshold) {
      await preferences.setInt(_thresholdKey, threshold);
    }
    if (saveCount < threshold || _showing) return;

    final lastShownAt = preferences.getInt(_lastShownAtKey);
    if (lastShownAt != null) {
      final elapsed = DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(lastShownAt),
      );
      if (elapsed < _minimumInterval) return;
    }

    if (!AdMobService.instance.adsReady) return;
    if (_isLoadedAdExpired) {
      await _disposeLoadedAd();
    }

    final ad = _interstitialAd;
    if (ad == null) {
      _loadIfPossible();
      return;
    }

    _interstitialAd = null;
    _loadedAt = null;
    _showing = true;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) {
        unawaited(_recordSuccessfulShow());
      },
      onAdDismissedFullScreenContent: (dismissedAd) {
        dismissedAd.dispose();
        _showing = false;
        _loadIfPossible();
      },
      onAdFailedToShowFullScreenContent: (failedAd, error) {
        debugPrint(
          'Geçiş reklamı gösterilemedi: ${error.code} ${error.message}',
        );
        failedAd.dispose();
        _showing = false;
        _loadIfPossible();
      },
    );

    try {
      await ad.show();
    } catch (error) {
      debugPrint('Geçiş reklamı açılamadı: $error');
      ad.dispose();
      _showing = false;
      _loadIfPossible();
    }
  }

  bool get _isLoadedAdExpired {
    final loadedAt = _loadedAt;
    return loadedAt != null &&
        DateTime.now().difference(loadedAt) >= _maximumAdAge;
  }

  Future<void> _recordSuccessfulShow() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.wait([
      preferences.setInt(_saveCountKey, 0),
      preferences.setInt(_thresholdKey, _nextThreshold()),
      preferences.setInt(
        _lastShownAtKey,
        DateTime.now().millisecondsSinceEpoch,
      ),
    ]);
  }

  int _nextThreshold() => 3 + _random.nextInt(2);

  Future<void> _disposeLoadedAd() async {
    final ad = _interstitialAd;
    _interstitialAd = null;
    _loadedAt = null;
    await ad?.dispose();
  }

  void _loadIfPossible() {
    if (!AdMobService.instance.adsReady ||
        _loading ||
        _showing ||
        _interstitialAd != null) {
      return;
    }

    _loading = true;
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(nonPersonalizedAds: true),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _loadedAt = DateTime.now();
          _loading = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint(
            'Geçiş reklamı yüklenemedi: ${error.code} ${error.message}',
          );
          _loading = false;
        },
      ),
    );
  }
}
