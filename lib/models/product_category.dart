import 'package:flutter/material.dart';
import '../utils/colors.dart';

enum ProductCategoryType {
  alimentaires,
  cosmetiques,
  complementsAlimentaires,
  entretienMenager;

  String get displayName {
    switch (this) {
      case ProductCategoryType.alimentaires:
        return 'Produits\nAlimentaires';
      case ProductCategoryType.cosmetiques:
        return 'Produits\nCosmétiques';
      case ProductCategoryType.complementsAlimentaires:
        return 'Compléments\nAlimentaires';
      case ProductCategoryType.entretienMenager:
        return 'Produits D\'entretien\nMénager';
    }
  }

  String get shortName {
    switch (this) {
      case ProductCategoryType.alimentaires:
        return 'Alimentaires';
      case ProductCategoryType.cosmetiques:
        return 'Cosmétiques';
      case ProductCategoryType.complementsAlimentaires:
        return 'Compléments';
      case ProductCategoryType.entretienMenager:
        return 'Entretien';
    }
  }

  IconData get icon {
    switch (this) {
      case ProductCategoryType.alimentaires:
        return Icons.restaurant;
      case ProductCategoryType.cosmetiques:
        return Icons.face_retouching_natural;
      case ProductCategoryType.complementsAlimentaires:
        return Icons.medication;
      case ProductCategoryType.entretienMenager:
        return Icons.cleaning_services;
    }
  }

  Color get color {
    switch (this) {
      case ProductCategoryType.alimentaires:
        return AppColors.scannerGreen;
      case ProductCategoryType.cosmetiques:
        return AppColors.favoritePurple;
      case ProductCategoryType.complementsAlimentaires:
        return AppColors.historyBlue;
      case ProductCategoryType.entretienMenager:
        return AppColors.searchOrange;
    }
  }
}

class ProductCategory {
  final ProductCategoryType type;
  
  ProductCategory({required this.type});
  
  String get displayName => type.displayName;
  String get shortName => type.shortName;
  IconData get icon => type.icon;
  Color get color => type.color;
}

// Liste des catégories disponibles
final List<ProductCategory> productCategories = [
  ProductCategory(type: ProductCategoryType.alimentaires),
  ProductCategory(type: ProductCategoryType.cosmetiques),
  ProductCategory(type: ProductCategoryType.complementsAlimentaires),
  ProductCategory(type: ProductCategoryType.entretienMenager),
]; 