import 'package:flutter/material.dart';

enum ScioCategory {
  alimentaire,
  cosmetique,
  complementAlimentaire,
  entretienMenager,
}

ScioCategory parseCategory(String value) {
  switch (value) {
    case 'alimentaire':
      return ScioCategory.alimentaire;
    case 'cosmetique':
      return ScioCategory.cosmetique;
    case 'complement_alimentaire':
      return ScioCategory.complementAlimentaire;
    case 'entretien_menager':
      return ScioCategory.entretienMenager;
    default:
      return ScioCategory.alimentaire;
  }
}

class ScannedProductBase {
  final String barcode;
  final String name;
  final ScioCategory category;

  const ScannedProductBase({
    required this.barcode,
    required this.name,
    required this.category,
  });
}

class FoodProduct extends ScannedProductBase {
  final String finalScore; // Très bon, Bon, Moyen, Mauvais, Très mauvais
  final NutritionAnalysis nutrition;
  final List<Additive> additives;
  final String processingDegree; // Peu transformé, ...

  FoodProduct({
    required super.barcode,
    required super.name,
    required super.category,
    required this.finalScore,
    required this.nutrition,
    required this.additives,
    required this.processingDegree,
  });

  factory FoodProduct.fromJson(Map<String, dynamic> json) {
    return FoodProduct(
      barcode: json['code_barres'] as String,
      name: json['nom'] as String,
      category: parseCategory(json['categorie'] as String),
      finalScore: json['score_final'] as String,
      nutrition: NutritionAnalysis.fromJson(json['analyse_nutritionnelle'] as Map<String, dynamic>),
      additives: ((json['additifs'] as List<dynamic>? ?? [])
              .map((e) => Additive.fromJson(e as Map<String, dynamic>))
              .toList()),
      processingDegree: json['degre_transformation'] as String,
    );
  }
}

class CosmeticProductBase extends ScannedProductBase {
  final bool verified;

  const CosmeticProductBase({
    required super.barcode,
    required super.name,
    required super.category,
    required this.verified,
  });
}

class CosmeticProductVerified extends CosmeticProductBase {
  final int finalScore; // 0..100
  final int composition; // ranges per spec
  final int environmentalImpact;
  final int conformityTests;
  final int packaging; // 0/5

  CosmeticProductVerified({
    required super.barcode,
    required super.name,
    required super.category,
    required super.verified,
    required this.finalScore,
    required this.composition,
    required this.environmentalImpact,
    required this.conformityTests,
    required this.packaging,
  });

  factory CosmeticProductVerified.fromJson(Map<String, dynamic> json) {
    return CosmeticProductVerified(
      barcode: json['code_barres'] as String,
      name: json['nom'] as String,
      category: parseCategory(json['categorie'] as String),
      verified: (json['verifie'] as bool? ?? true),
      finalScore: json['score_final'] as int,
      composition: json['composition'] as int,
      environmentalImpact: json['impact_env'] as int,
      conformityTests: json['tests_conformite'] as int,
      packaging: json['emballage'] as int,
    );
  }
}

class CosmeticProductUnverified extends CosmeticProductBase {
  final String finalScore; // Excellent, Bon, Médiocre, Risqué
  final int composition; // 0..85 per spec
  final int environmentalImpact; // 0..10 per spec
  final int packaging; // 0/5

  CosmeticProductUnverified({
    required super.barcode,
    required super.name,
    required super.category,
    required super.verified,
    required this.finalScore,
    required this.composition,
    required this.environmentalImpact,
    required this.packaging,
  });

  factory CosmeticProductUnverified.fromJson(Map<String, dynamic> json) {
    return CosmeticProductUnverified(
      barcode: json['code_barres'] as String,
      name: json['nom'] as String,
      category: parseCategory(json['categorie'] as String),
      verified: (json['verifie'] as bool? ?? false),
      finalScore: json['score_final'] as String,
      composition: json['composition'] as int,
      environmentalImpact: json['impact_env'] as int,
      packaging: json['emballage'] as int,
    );
  }
}

class HouseholdProductBase extends ScannedProductBase {
  final bool verified;

  const HouseholdProductBase({
    required super.barcode,
    required super.name,
    required super.category,
    required this.verified,
  });
}

class HouseholdProductVerified extends HouseholdProductBase {
  final int finalScore; // 0..100
  final int composition;
  final int conformityTests;
  final int environmentalImpact; // 0..10

  HouseholdProductVerified({
    required super.barcode,
    required super.name,
    required super.category,
    required super.verified,
    required this.finalScore,
    required this.composition,
    required this.conformityTests,
    required this.environmentalImpact,
  });

  factory HouseholdProductVerified.fromJson(Map<String, dynamic> json) {
    return HouseholdProductVerified(
      barcode: json['code_barres'] as String,
      name: json['nom'] as String,
      category: parseCategory(json['categorie'] as String),
      verified: (json['verifie'] as bool? ?? true),
      finalScore: json['score_final'] as int,
      composition: json['composition'] as int,
      conformityTests: json['tests_conformite'] as int,
      environmentalImpact: json['impact_env'] as int,
    );
  }
}

class HouseholdProductUnverified extends HouseholdProductBase {
  final String finalScore; // Excellent, Bon, Médiocre, Dangereux
  final int composition; // 0..60
  final int environmentalImpact; // 0..40

  HouseholdProductUnverified({
    required super.barcode,
    required super.name,
    required super.category,
    required super.verified,
    required this.finalScore,
    required this.composition,
    required this.environmentalImpact,
  });

  factory HouseholdProductUnverified.fromJson(Map<String, dynamic> json) {
    return HouseholdProductUnverified(
      barcode: json['code_barres'] as String,
      name: json['nom'] as String,
      category: parseCategory(json['categorie'] as String),
      verified: (json['verifie'] as bool? ?? false),
      finalScore: json['score_final'] as String,
      composition: json['composition'] as int,
      environmentalImpact: json['impact_env'] as int,
    );
  }
}

class SupplementProductBase extends ScannedProductBase {
  final bool verified;

  const SupplementProductBase({
    required super.barcode,
    required super.name,
    required super.category,
    required this.verified,
  });
}

class SupplementProduct extends SupplementProductBase {
  final int finalScore; // 0..100
  final int composition; // 0..60
  final int traceability; // 0..30
  final int usageMode; // 0..9
  final int packaging; // 0..10

  SupplementProduct({
    required super.barcode,
    required super.name,
    required super.category,
    required super.verified,
    required this.finalScore,
    required this.composition,
    required this.traceability,
    required this.usageMode,
    required this.packaging,
  });

  factory SupplementProduct.fromJson(Map<String, dynamic> json) {
    return SupplementProduct(
      barcode: json['code_barres'] as String,
      name: json['nom'] as String,
      category: parseCategory(json['categorie'] as String),
      verified: (json['verifie'] as bool? ?? false),
      finalScore: json['score_final'] as int,
      composition: json['composition'] as int,
      traceability: json['tracabilite'] as int,
      usageMode: json['mode_emploi'] as int,
      packaging: json['emballage'] as int,
    );
  }
}

class NutritionAnalysis {
  final int calories;
  final double fat;
  final int saltMg;
  final int sugar;
  final int proteins;
  final int fibers;

  NutritionAnalysis({
    required this.calories,
    required this.fat,
    required this.saltMg,
    required this.sugar,
    required this.proteins,
    required this.fibers,
  });

  factory NutritionAnalysis.fromJson(Map<String, dynamic> json) {
    return NutritionAnalysis(
      calories: (json['calories'] as num).toInt(),
      fat: (json['matieres_grasses'] as num).toDouble(),
      saltMg: (json['sel'] as num).toInt(),
      sugar: (json['sucre'] as num).toInt(),
      proteins: (json['proteines'] as num).toInt(),
      fibers: (json['fibres'] as num).toInt(),
    );
  }
}

class Additive {
  final String name;
  final String risk; // Sans risque, Risque modéré, Risque élevé

  Additive({required this.name, required this.risk});

  factory Additive.fromJson(Map<String, dynamic> json) {
    return Additive(
      name: json['nom'] as String,
      risk: json['risque'] as String,
    );
  }
} 