import '../models/scanned_product.dart';

class HistoryEntry {
  final String barcode;
  final String name;
  final String brand;
  final ScioCategory category;
  final bool? verified; // null for alimentaires
  final int? scoreNumeric; // when numeric scoring exists
  final String? scoreLabel; // when label-based scoring exists
  final DateTime scannedAt;

  HistoryEntry({
    required this.barcode,
    required this.name,
    required this.brand,
    required this.category,
    required this.verified,
    required this.scoreNumeric,
    required this.scoreLabel,
    required this.scannedAt,
  });

  Map<String, dynamic> toJson() => {
    'barcode': barcode,
    'name': name,
    'brand': brand,
    'category': category.name,
    'verified': verified,
    'scoreNumeric': scoreNumeric,
    'scoreLabel': scoreLabel,
    'scannedAt': scannedAt.toIso8601String(),
  };

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      barcode: json['barcode'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      category: ScioCategory.values.firstWhere((e) => e.name == json['category']),
      verified: json['verified'] as bool?,
      scoreNumeric: json['scoreNumeric'] as int?,
      scoreLabel: json['scoreLabel'] as String?,
      scannedAt: DateTime.parse(json['scannedAt'] as String),
    );
  }
} 