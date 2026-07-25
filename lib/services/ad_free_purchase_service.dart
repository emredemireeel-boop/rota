import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdFreePurchaseService extends ChangeNotifier {
  AdFreePurchaseService._();

  static final AdFreePurchaseService instance = AdFreePurchaseService._();

  static const productId = 'com.pudinglabs.rotaturkiye.remove_ads';
  static const _adFreeStorageKey = 'rota_ad_free_lifetime_v1';

  final InAppPurchase _store = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  bool _initialized = false;
  bool _storeAvailable = false;
  bool _loadingProduct = false;
  bool _purchasing = false;
  bool _isAdFree = false;
  ProductDetails? _product;
  String? _message;

  bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  bool get storeAvailable => _storeAvailable;
  bool get loadingProduct => _loadingProduct;
  bool get purchasing => _purchasing;
  bool get isAdFree => _isAdFree;
  ProductDetails? get product => _product;
  String? get message => _message;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    final preferences = await SharedPreferences.getInstance();
    _isAdFree = preferences.getBool(_adFreeStorageKey) ?? false;
    notifyListeners();

    if (!isSupported) return;
    _purchaseSubscription = _store.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (Object error) {
        _purchasing = false;
        _message = 'Satın alma bilgisi alınamadı. Lütfen tekrar deneyin.';
        debugPrint('Satın alma akışı hatası: $error');
        notifyListeners();
      },
    );
    unawaited(_connectToStore());
  }

  Future<void> _connectToStore() async {
    try {
      _storeAvailable = await _store.isAvailable();
      if (!_storeAvailable) {
        _message = 'App Store satın alma hizmetine şu anda ulaşılamıyor.';
        notifyListeners();
        return;
      }
      await refreshProduct();
    } catch (error) {
      _storeAvailable = false;
      _message = 'App Store satın alma hizmetine şu anda ulaşılamıyor.';
      debugPrint('App Store bağlantı hatası: $error');
      notifyListeners();
    }
  }

  Future<void> refreshProduct() async {
    if (!isSupported || !_storeAvailable || _loadingProduct) return;
    _loadingProduct = true;
    _message = null;
    notifyListeners();

    try {
      final response = await _store.queryProductDetails({productId});
      if (response.error != null) {
        _message = 'Reklamsız sürüm bilgisi App Store’dan alınamadı.';
        debugPrint('Ürün sorgusu hatası: ${response.error}');
      } else if (response.productDetails.isEmpty) {
        _message = 'Reklamsız sürüm henüz App Store’da kullanıma hazır değil.';
      } else {
        _product = response.productDetails.first;
        _message = null;
      }
    } catch (error) {
      _message = 'Reklamsız sürüm bilgisi App Store’dan alınamadı.';
      debugPrint('Ürün sorgusu hatası: $error');
    } finally {
      _loadingProduct = false;
      notifyListeners();
    }
  }

  Future<void> purchaseAdFree() async {
    if (_isAdFree || _purchasing) return;
    if (_product == null) {
      await refreshProduct();
    }
    final product = _product;
    if (product == null) return;

    _purchasing = true;
    _message = null;
    notifyListeners();
    try {
      final opened = await _store.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );
      if (!opened) {
        _purchasing = false;
        _message = 'Satın alma ekranı açılamadı. Lütfen tekrar deneyin.';
        notifyListeners();
      }
    } catch (error) {
      _purchasing = false;
      _message = 'Satın alma başlatılamadı. Lütfen tekrar deneyin.';
      debugPrint('Satın alma başlatma hatası: $error');
      notifyListeners();
    }
  }

  Future<void> restorePurchases() async {
    if (!isSupported || !_storeAvailable || _purchasing) return;
    _purchasing = true;
    _message = 'Önceki satın alımlar kontrol ediliyor...';
    notifyListeners();
    try {
      await _store.restorePurchases();
      if (!_isAdFree) {
        _message =
            'Geri yükleme tamamlandı. Uygun bir satın alma bulunursa '
            'reklamsız sürüm otomatik açılır.';
      }
    } catch (error) {
      _message = 'Satın alımlar geri yüklenemedi. Lütfen tekrar deneyin.';
      debugPrint('Satın alma geri yükleme hatası: $error');
    } finally {
      _purchasing = false;
      notifyListeners();
    }
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID != productId) continue;

      switch (purchase.status) {
        case PurchaseStatus.pending:
          _purchasing = true;
          _message = 'Satın alma işlemi tamamlanıyor...';
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (_isValidPurchase(purchase)) {
            await _grantAdFree();
            _message = purchase.status == PurchaseStatus.restored
                ? 'Satın alma geri yüklendi. Reklamlar kaldırıldı.'
                : 'Teşekkürler! Reklamlar kalıcı olarak kaldırıldı.';
          } else {
            _message = 'Satın alma doğrulanamadı.';
          }
          _purchasing = false;
          break;
        case PurchaseStatus.error:
          _purchasing = false;
          _message =
              purchase.error?.message ??
              'Satın alma tamamlanamadı. Lütfen tekrar deneyin.';
          break;
        case PurchaseStatus.canceled:
          _purchasing = false;
          _message = 'Satın alma iptal edildi.';
          break;
      }

      notifyListeners();
      if (purchase.pendingCompletePurchase) {
        try {
          await _store.completePurchase(purchase);
        } catch (error) {
          debugPrint('Satın alma tamamlama hatası: $error');
        }
      }
    }
  }

  bool _isValidPurchase(PurchaseDetails purchase) {
    return purchase.productID == productId &&
        (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) &&
        purchase.verificationData.serverVerificationData.isNotEmpty;
  }

  Future<void> _grantAdFree() async {
    if (_isAdFree) return;
    _isAdFree = true;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_adFreeStorageKey, true);
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }
}
