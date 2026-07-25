import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService extends ChangeNotifier {
  AdMobService._();

  static final AdMobService instance = AdMobService._();

  bool _initializationStarted = false;
  bool _adsReady = false;
  bool _privacyOptionsRequired = false;

  bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  bool get adsReady => _adsReady;
  bool get privacyOptionsRequired => _privacyOptionsRequired;

  Future<void> initialize() async {
    if (!isSupported || _initializationStarted) return;
    _initializationStarted = true;

    final parameters = ConsentRequestParameters();
    ConsentInformation.instance.requestConsentInfoUpdate(
      parameters,
      () async {
        await _refreshPrivacyOptionsRequirement();
        await ConsentForm.loadAndShowConsentFormIfRequired((error) {
          if (error != null) {
            debugPrint(
              'AdMob izin formu gösterilemedi: '
              '${error.errorCode} ${error.message}',
            );
          }
        });
        await _refreshPrivacyOptionsRequirement();
        await _initializeAdsIfAllowed();
      },
      (error) async {
        debugPrint(
          'AdMob izin bilgisi güncellenemedi: '
          '${error.errorCode} ${error.message}',
        );
        await _refreshPrivacyOptionsRequirement();
        await _initializeAdsIfAllowed();
      },
    );
  }

  Future<void> showPrivacyOptions() async {
    if (!isSupported) return;
    await ConsentForm.showPrivacyOptionsForm((error) {
      if (error != null) {
        debugPrint(
          'AdMob gizlilik seçenekleri gösterilemedi: '
          '${error.errorCode} ${error.message}',
        );
      }
    });
    await _refreshPrivacyOptionsRequirement();
    await _initializeAdsIfAllowed();
  }

  Future<void> _initializeAdsIfAllowed() async {
    if (_adsReady || !await ConsentInformation.instance.canRequestAds()) {
      return;
    }
    await MobileAds.instance.initialize();
    _adsReady = true;
    notifyListeners();
  }

  Future<void> _refreshPrivacyOptionsRequirement() async {
    final status = await ConsentInformation.instance
        .getPrivacyOptionsRequirementStatus();
    final required = status == PrivacyOptionsRequirementStatus.required;
    if (_privacyOptionsRequired == required) return;
    _privacyOptionsRequired = required;
    notifyListeners();
  }
}
