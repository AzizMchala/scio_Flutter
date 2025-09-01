import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/action_card.dart';
import '../widgets/recent_product_card.dart';
import '../models/product.dart';
import '../utils/colors.dart';
import '../controllers/navigation_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Données d'exemple pour les produits récents
  List<Product> _getRecentProducts() {
    return [
      Product(
        id: '1',
        name: 'Nutella Original',
        scanDate: DateTime.now().subtract(const Duration(days: 0)),
        score: ProductScore.D,
        isNew: true,
      ),
      Product(
        id: '2',
        name: 'Yaourt Bio Nature',
        scanDate: DateTime.now().subtract(const Duration(days: 1)),
        score: ProductScore.A,
      ),
      Product(
        id: '3',
        name: 'Huile d\'Olive Extra',
        scanDate: DateTime.now().subtract(const Duration(days: 2)),
        score: ProductScore.A,
      ),
    ];
  }

  void _navigateToScanner(BuildContext context) {
    navigationController.navigateToScanner();
  }

  void _navigateToHistory(BuildContext context) {
    navigationController.navigateToHistory();
  }

  void _navigateToSearch(BuildContext context) {
    navigationController.navigateToSearch();
  }

  void _navigateToFavorites(BuildContext context) {
    navigationController.navigateToFavorites();
  }

  void _viewAllScans(BuildContext context) {
    // TODO: Navigation vers tous les scans
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voir tous les scans')),
    );
  }

  void _onProductTap(BuildContext context, Product product) {
    // TODO: Navigation vers les détails du produit
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Détails de ${product.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recentProducts = _getRecentProducts();
    
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
                gradient: AppColors.blackGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bonjour,',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Bienvenue sur SCIO',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Scannez et analysez vos produits en toute simplicité',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),

            // Section "Actions rapides"
            const Text(
              'Actions rapides',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 16),
            
            // Grille 2x2 des actions rapides
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                ActionCard(
                  icon: Icons.qr_code_scanner,
                  title: 'Scanner produit',
                  subtitle: 'Analyser un produit',
                  color: AppColors.scannerGreen,
                  onTap: () => _navigateToScanner(context),
                ),
                ActionCard(
                  icon: Icons.history,
                  title: 'Historique',
                  subtitle: 'Voir les scans',
                  color: AppColors.historyBlue,
                  onTap: () => _navigateToHistory(context),
                ),
                ActionCard(
                  icon: Icons.search,
                  title: 'Recherche',
                  subtitle: 'Trouver un produit',
                  color: AppColors.searchOrange,
                  onTap: () => _navigateToSearch(context),
                ),
                ActionCard(
                  icon: Icons.favorite,
                  title: 'Favoris',
                  subtitle: 'Mes produits',
                  color: AppColors.favoritePurple,
                  onTap: () => _navigateToFavorites(context),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Section "Scans récents"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Scans récents',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGray,
                  ),
                ),
                GestureDetector(
                  onTap: () => _viewAllScans(context),
                  child: const Text(
                    'Voir tout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Liste des produits récents
            if (recentProducts.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.lightGray.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.qr_code_scanner_outlined,
                      size: 48,
                      color: AppColors.lightGray,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Aucun scan récent',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Commencez par scanner votre premier produit',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.lightGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              Column(
                children: recentProducts
                    .map((product) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: RecentProductCard(
                            product: product,
                            onTap: () => _onProductTap(context, product),
                          ),
                        ))
                    .toList(),
              ),

            // Espacement en bas pour éviter que le contenu soit collé
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
} 