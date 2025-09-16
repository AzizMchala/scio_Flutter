import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/scanned_product.dart';

class ProductRepository {
  static const String _assetPath = 'assets/mock/products_mock.json';

  static Future<Map<String, dynamic>> _loadJson() async {
    final raw = await rootBundle.loadString(_assetPath);
    return json.decode(raw) as Map<String, dynamic>;
  }

  static Future<ScannedProductBase?> findByBarcode({
    required String barcode,
    required ScioCategory category,
  }) async {
    final data = await _loadJson();

    switch (category) {
      case ScioCategory.alimentaire:
        final list = (data['alimentaires'] as List<dynamic>? ?? []);
        final match = list.cast<Map<String, dynamic>?>().firstWhere(
              (e) => e != null && e['code_barres'] == barcode,
              orElse: () => null,
            );
        if (match == null) return null;
        return FoodProduct.fromJson(match);

      case ScioCategory.cosmetique:
        final obj = (data['cosmetiques'] as Map<String, dynamic>?);
        if (obj == null) return null;
        // verified
        final verified = (obj['verifie'] as List<dynamic>? ?? [])
            .cast<Map<String, dynamic>>()
            .where((e) => e['code_barres'] == barcode)
            .toList();
        if (verified.isNotEmpty) {
          return CosmeticProductVerified.fromJson(verified.first);
        }
        // non verified
        final unv = (obj['non_verifie'] as List<dynamic>? ?? [])
            .cast<Map<String, dynamic>>()
            .where((e) => e['code_barres'] == barcode)
            .toList();
        if (unv.isNotEmpty) {
          return CosmeticProductUnverified.fromJson(unv.first);
        }
        return null;

      case ScioCategory.complementAlimentaire:
        final obj = (data['complements_alimentaires'] as Map<String, dynamic>?);
        if (obj == null) return null;
        final verified = (obj['verifie'] as List<dynamic>? ?? [])
            .cast<Map<String, dynamic>>()
            .where((e) => e['code_barres'] == barcode)
            .toList();
        if (verified.isNotEmpty) {
          return SupplementProduct.fromJson(verified.first);
        }
        final unv = (obj['non_verifie'] as List<dynamic>? ?? [])
            .cast<Map<String, dynamic>>()
            .where((e) => e['code_barres'] == barcode)
            .toList();
        if (unv.isNotEmpty) {
          return SupplementProduct.fromJson(unv.first);
        }
        return null;

      case ScioCategory.entretienMenager:
        final obj = (data['entretien_menager'] as Map<String, dynamic>?);
        if (obj == null) return null;
        final verified = (obj['verifie'] as List<dynamic>? ?? [])
            .cast<Map<String, dynamic>>()
            .where((e) => e['code_barres'] == barcode)
            .toList();
        if (verified.isNotEmpty) {
          return HouseholdProductVerified.fromJson(verified.first);
        }
        final unv = (obj['non_verifie'] as List<dynamic>? ?? [])
            .cast<Map<String, dynamic>>()
            .where((e) => e['code_barres'] == barcode)
            .toList();
        if (unv.isNotEmpty) {
          return HouseholdProductUnverified.fromJson(unv.first);
        }
        return null;
    }
  }
} 