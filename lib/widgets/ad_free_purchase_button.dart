import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/ad_free_purchase_service.dart';

class AdFreePurchaseButton extends StatelessWidget {
  const AdFreePurchaseButton({super.key});

  Future<void> _openPurchaseDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => const _AdFreePurchaseDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = AdFreePurchaseService.instance;
    if (!service.isSupported) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        return Tooltip(
          message: service.isAdFree
              ? 'Reklamsız sürüm aktif'
              : 'Reklamları kaldır',
          child: IconButton.filledTonal(
            onPressed: () => _openPurchaseDialog(context),
            icon: Icon(
              service.isAdFree
                  ? Icons.verified_rounded
                  : Icons.workspace_premium_rounded,
              color: service.isAdFree
                  ? const Color(0xFF14805E)
                  : const Color(0xFF8A5A00),
            ),
          ),
        );
      },
    );
  }
}

class _AdFreePurchaseDialog extends StatelessWidget {
  const _AdFreePurchaseDialog();

  @override
  Widget build(BuildContext context) {
    final service = AdFreePurchaseService.instance;
    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final product = service.product;
        return AlertDialog(
          icon: Icon(
            service.isAdFree
                ? Icons.verified_rounded
                : Icons.workspace_premium_rounded,
            size: 38,
            color: service.isAdFree
                ? const Color(0xFF14805E)
                : const Color(0xFFD39A18),
          ),
          title: Text(
            service.isAdFree
                ? 'Reklamsız sürüm aktif'
                : 'Rota Dünya’yı reklamsız kullan',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(fontWeight: FontWeight.w800),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                service.isAdFree
                    ? 'Bu Apple hesabıyla reklamsız kullanım kalıcı olarak '
                          'açıldı.'
                    : 'Tek seferlik satın alımla banner ve geçiş '
                          'reklamlarını kalıcı olarak kaldır.',
                textAlign: TextAlign.center,
              ),
              if (!service.isAdFree) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6DE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        product?.price ??
                            (service.loadingProduct
                                ? 'Fiyat yükleniyor...'
                                : 'App Store fiyatı bekleniyor'),
                        style: GoogleFonts.outfit(
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF704C00),
                        ),
                      ),
                      const Text(
                        'Tek seferlik • Abonelik değildir',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7B6B49),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (service.message != null) ...[
                const SizedBox(height: 12),
                Text(
                  service.message!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            if (service.isAdFree)
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tamam'),
              )
            else ...[
              TextButton(
                onPressed: service.purchasing || !service.storeAvailable
                    ? null
                    : service.restorePurchases,
                child: const Text('Satın alımı geri yükle'),
              ),
              FilledButton.icon(
                onPressed: product == null || service.purchasing
                    ? null
                    : service.purchaseAdFree,
                icon: service.purchasing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.lock_open_rounded),
                label: Text(product == null ? 'Hazırlanıyor' : 'Satın al'),
              ),
            ],
          ],
        );
      },
    );
  }
}
