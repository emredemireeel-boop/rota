import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../services/ad_free_purchase_service.dart';
import '../services/ad_mob_service.dart';

class RotaBannerAd extends StatefulWidget {
  const RotaBannerAd({super.key});

  @override
  State<RotaBannerAd> createState() => _RotaBannerAdState();
}

class _RotaBannerAdState extends State<RotaBannerAd> {
  static const _iosTestAdUnitId = 'ca-app-pub-3940256099942544/2435281174';
  static const _androidTestAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const _iosProductionAdUnitId =
      'ca-app-pub-2265053267835785/2632742624';

  BannerAd? _bannerAd;
  bool _loading = false;
  int? _loadedWidth;

  bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

  // Android kapalı testte; iOS yayın derlemesi gerçek AdMob birimini kullanır.
  String get _adUnitId => _isAndroid
      ? _androidTestAdUnitId
      : (kReleaseMode ? _iosProductionAdUnitId : _iosTestAdUnitId);

  @override
  void initState() {
    super.initState();
    AdMobService.instance.addListener(_handleAdServiceChanged);
    AdFreePurchaseService.instance.addListener(_handlePurchaseChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBannerIfReady();
  }

  void _handleAdServiceChanged() {
    if (!mounted) return;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadBannerIfReady();
    });
  }

  void _handlePurchaseChanged() {
    if (!mounted) return;
    if (AdFreePurchaseService.instance.isAdFree) {
      final ad = _bannerAd;
      _bannerAd = null;
      _loadedWidth = null;
      _loading = false;
      ad?.dispose();
    }
    setState(() {});
  }

  Future<void> _loadBannerIfReady() async {
    if (!mounted ||
        AdFreePurchaseService.instance.isAdFree ||
        !AdMobService.instance.isSupported ||
        !AdMobService.instance.adsReady ||
        _loading) {
      return;
    }

    final width = MediaQuery.sizeOf(context).width.truncate();
    if (width <= 0 || (_bannerAd != null && _loadedWidth == width)) return;

    _loading = true;
    await _bannerAd?.dispose();
    _bannerAd = null;
    _loadedWidth = null;

    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
    if (!mounted || size == null) {
      _loading = false;
      return;
    }

    final ad = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(nonPersonalizedAds: true),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (loadedAd) {
          if (!mounted) {
            loadedAd.dispose();
            return;
          }
          setState(() {
            _bannerAd = loadedAd as BannerAd;
            _loadedWidth = width;
            _loading = false;
          });
        },
        onAdFailedToLoad: (failedAd, error) {
          debugPrint(
            'Banner reklamı yüklenemedi: '
            '${error.code} ${error.message}',
          );
          failedAd.dispose();
          if (mounted) {
            setState(() => _loading = false);
          }
        },
      ),
    );
    await ad.load();
  }

  @override
  void dispose() {
    AdMobService.instance.removeListener(_handleAdServiceChanged);
    AdFreePurchaseService.instance.removeListener(_handlePurchaseChanged);
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = AdMobService.instance;
    if (!service.isSupported || AdFreePurchaseService.instance.isAdFree) {
      return const SizedBox.shrink();
    }

    final showPrivacy = service.privacyOptionsRequired;
    final ad = _bannerAd;
    if (ad == null && !showPrivacy) return const SizedBox.shrink();

    return Material(
      color: Colors.white,
      elevation: 10,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 3, 8, 2),
              child: Row(
                children: [
                  Text(
                    _isAndroid || !kReleaseMode
                        ? 'Demo reklam • Google test'
                        : 'Reklam',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const Spacer(),
                  if (showPrivacy)
                    TextButton.icon(
                      onPressed: service.showPrivacyOptions,
                      icon: const Icon(Icons.privacy_tip_outlined, size: 16),
                      label: const Text('Gizlilik seçenekleri'),
                      style: TextButton.styleFrom(
                        minimumSize: const Size(0, 28),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                ],
              ),
            ),
            if (ad != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: ad.size.width.toDouble(),
                  height: ad.size.height.toDouble(),
                  child: AdWidget(ad: ad),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
