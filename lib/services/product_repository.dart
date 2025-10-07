import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/scanned_product.dart';

class SearchResult {
  final String barcode;
  final String name;
  final ScioCategory category;
  final ScannedProductBase product;

  SearchResult({
    required this.barcode,
    required this.name,
    required this.category,
    required this.product,
  });
}

class ProductRepository {
  static const String _assetPath = 'assets/mock/products_mock.json';

  static Future<Map<String, dynamic>> _loadJson() async {
    final raw = await rootBundle.loadString(_assetPath);
    return json.decode(raw) as Map<String, dynamic>;
  }

  // Recherche de produits par nom ou code-barres
  static Future<List<SearchResult>> searchProducts(String query) async {
    if (query.trim().isEmpty) return [];
    
    final data = await _loadJson();
    final results = <SearchResult>[];
    final lowerQuery = query.toLowerCase();

    // Recherche dans les produits alimentaires
    final alimentaires = (data['alimentaires'] as List<dynamic>? ?? []);
    for (final item in alimentaires.cast<Map<String, dynamic>>()) {
      final name = (item['nom'] as String? ?? '').toLowerCase();
      final barcode = item['code_barres'] as String? ?? '';
      
      if (name.contains(lowerQuery) || barcode.contains(query)) {
        results.add(SearchResult(
          barcode: barcode,
          name: item['nom'] as String? ?? '',
          category: ScioCategory.alimentaire,
          product: FoodProduct.fromJson(item),
        ));
      }
    }

    // Recherche dans les cosmétiques vérifiés
    final cosmetiquesObj = (data['cosmetiques'] as Map<String, dynamic>?);
    if (cosmetiquesObj != null) {
      final cosmetiquesVerified = (cosmetiquesObj['verifie'] as List<dynamic>? ?? []);
      for (final item in cosmetiquesVerified.cast<Map<String, dynamic>>()) {
        final name = (item['nom'] as String? ?? '').toLowerCase();
        final barcode = item['code_barres'] as String? ?? '';
        
        if (name.contains(lowerQuery) || barcode.contains(query)) {
          results.add(SearchResult(
            barcode: barcode,
            name: item['nom'] as String? ?? '',
            category: ScioCategory.cosmetique,
            product: CosmeticProductVerified.fromJson(item),
          ));
        }
      }

      // Recherche dans les cosmétiques non vérifiés
      final cosmetiquesUnverified = (cosmetiquesObj['non_verifie'] as List<dynamic>? ?? []);
      for (final item in cosmetiquesUnverified.cast<Map<String, dynamic>>()) {
        final name = (item['nom'] as String? ?? '').toLowerCase();
        final barcode = item['code_barres'] as String? ?? '';
        
        if (name.contains(lowerQuery) || barcode.contains(query)) {
          results.add(SearchResult(
            barcode: barcode,
            name: item['nom'] as String? ?? '',
            category: ScioCategory.cosmetique,
            product: CosmeticProductUnverified.fromJson(item),
          ));
        }
      }
    }

    // Recherche dans les compléments alimentaires
    final complementsObj = (data['complements_alimentaires'] as Map<String, dynamic>?);
    if (complementsObj != null) {
      final complementsVerified = (complementsObj['verifie'] as List<dynamic>? ?? []);
      for (final item in complementsVerified.cast<Map<String, dynamic>>()) {
        final name = (item['nom'] as String? ?? '').toLowerCase();
        final barcode = item['code_barres'] as String? ?? '';
        
        if (name.contains(lowerQuery) || barcode.contains(query)) {
          results.add(SearchResult(
            barcode: barcode,
            name: item['nom'] as String? ?? '',
            category: ScioCategory.complementAlimentaire,
            product: SupplementProduct.fromJson(item),
          ));
        }
      }

      final complementsUnverified = (complementsObj['non_verifie'] as List<dynamic>? ?? []);
      for (final item in complementsUnverified.cast<Map<String, dynamic>>()) {
        final name = (item['nom'] as String? ?? '').toLowerCase();
        final barcode = item['code_barres'] as String? ?? '';
        
        if (name.contains(lowerQuery) || barcode.contains(query)) {
          results.add(SearchResult(
            barcode: barcode,
            name: item['nom'] as String? ?? '',
            category: ScioCategory.complementAlimentaire,
            product: SupplementProduct.fromJson(item),
          ));
        }
      }
    }

    // Recherche dans les produits d'entretien ménager
    final entretienObj = (data['entretien_menager'] as Map<String, dynamic>?);
    if (entretienObj != null) {
      final entretienVerified = (entretienObj['verifie'] as List<dynamic>? ?? []);
      for (final item in entretienVerified.cast<Map<String, dynamic>>()) {
        final name = (item['nom'] as String? ?? '').toLowerCase();
        final barcode = item['code_barres'] as String? ?? '';
        
        if (name.contains(lowerQuery) || barcode.contains(query)) {
          results.add(SearchResult(
            barcode: barcode,
            name: item['nom'] as String? ?? '',
            category: ScioCategory.entretienMenager,
            product: HouseholdProductVerified.fromJson(item),
          ));
        }
      }

      final entretienUnverified = (entretienObj['non_verifie'] as List<dynamic>? ?? []);
      for (final item in entretienUnverified.cast<Map<String, dynamic>>()) {
        final name = (item['nom'] as String? ?? '').toLowerCase();
        final barcode = item['code_barres'] as String? ?? '';
        
        if (name.contains(lowerQuery) || barcode.contains(query)) {
          results.add(SearchResult(
            barcode: barcode,
            name: item['nom'] as String? ?? '',
            category: ScioCategory.entretienMenager,
            product: HouseholdProductUnverified.fromJson(item),
          ));
        }
      }
    }

    return results.take(10).toList(); // Limite à 10 résultats
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