import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/category_card.dart';
import '../models/product_category.dart';
import '../utils/colors.dart';
import 'barcode_scanner_screen.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  Future<void> _onCategorySelected(BuildContext context, ProductCategory category) async {
    // Vérifier les permissions de caméra
    final permission = await Permission.camera.status;
    
    if (permission.isDenied) {
      final result = await Permission.camera.request();
      if (result.isDenied) {
        if (context.mounted) {
          _showPermissionDialog(context);
        }
        return;
      }
    }

    if (permission.isPermanentlyDenied) {
      if (context.mounted) {
        _showPermissionDialog(context, isPermanent: true);
      }
      return;
    }

    // Navigation vers le scanner
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BarcodeScannerScreen(category: category),
        ),
      );
    }
  }

  void _showPermissionDialog(BuildContext context, {bool isPermanent = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Permission requise',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),
          content: Text(
            isPermanent
                ? 'L\'accès à la caméra a été refusé de façon permanente. Veuillez l\'autoriser dans les paramètres de l\'application.'
                : 'Cette application a besoin d\'accéder à la caméra pour scanner les codes-barres.',
            style: const TextStyle(color: AppColors.gray),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Annuler',
                style: TextStyle(color: AppColors.gray),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (isPermanent) {
                  openAppSettings();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(isPermanent ? 'Paramètres' : 'Autoriser'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête de bienvenue
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.scannerGreen,
                    AppColors.scannerGreen.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Scanner Produit',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sélectionnez la catégorie de votre produit\npour commencer le scan',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),

            // Section "Catégories de produits"
            const Text(
              'Catégories de produits',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 16),
            
            // Grille 2x2 des catégories
            SizedBox(
              height: 280,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
                children: productCategories.map((category) {
                  return CategoryCard(
                    category: category,
                    onTap: () => _onCategorySelected(context, category),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Information en bas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Choisissez la catégorie correspondant à votre produit pour une analyse optimisée.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.gray,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
} 