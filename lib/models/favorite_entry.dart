import '../models/scanned_product.dart';

class FavoriteEntry {
  final String barcode;
  final String name;
  final String brand;
  final ScioCategory category;
  final bool? verified; // null for alimentaires
  final int? scoreNumeric; // when numeric scoring exists
  final String? scoreLabel; // when label-based scoring exists

  FavoriteEntry({
    required this.barcode,
    required this.name,
    required this.brand,
    required this.category,
    required this.verified,
    required this.scoreNumeric,
    required this.scoreLabel,
  });

  Map<String, dynamic> toJson() => {
    'barcode': barcode,
    'name': name,
    'brand': brand,
    'category': category.name,
    'verified': verified,
    'scoreNumeric': scoreNumeric,
    'scoreLabel': scoreLabel,
  };

  factory FavoriteEntry.fromJson(Map<String, dynamic> json) {
    return FavoriteEntry(
      barcode: json['barcode'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      category: ScioCategory.values.firstWhere((e) => e.name == json['category']),
      verified: json['verified'] as bool?,
      scoreNumeric: json['scoreNumeric'] as int?,
      scoreLabel: json['scoreLabel'] as String?,
    );
  }
} 