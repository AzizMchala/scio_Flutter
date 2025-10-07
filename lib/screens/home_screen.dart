import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/action_card.dart';
import '../widgets/recent_product_card.dart';
import '../models/product.dart';
import '../models/history_entry.dart';
import '../models/scanned_product.dart';
import '../services/history_service.dart';
import '../utils/colors.dart';
import '../controllers/navigation_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<HistoryEntry> _recentScans = [];

  @override
  void initState() {
    super.initState();
    _loadRecentScans();
  }

  Future<void> _loadRecentScans() async {
    try {
      final allScans = await HistoryService.getAll();
      // Trier par date et prendre les 3 plus récents
      allScans.sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
      setState(() {
        _recentScans = allScans.take(3).toList();
      });
    } catch (e) {
      // En cas d'erreur, garder la liste vide
      setState(() {
        _recentScans = [];
      });
    }
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
    navigationController.navigateToHistory();
  }

  void _onProductTap(BuildContext context, HistoryEntry entry) {
    // Navigue vers la page des détails du produit (pas encore implémentée)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Détails de ${entry.name}')),
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
            if (_recentScans.isEmpty)
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
                children: _recentScans
                    .map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _RecentScanCard(
                            entry: entry,
                            onTap: () => _onProductTap(context, entry),
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

class _RecentScanCard extends StatelessWidget {
  final HistoryEntry entry;
  final VoidCallback onTap;

  const _RecentScanCard({required this.entry, required this.onTap});

  Color _getCategoryColor(ScioCategory category) {
    switch (category) {
      case ScioCategory.alimentaire:
        return const Color(0xFF4CAF50);
      case ScioCategory.cosmetique:
        return const Color(0xFFE91E63);
      case ScioCategory.complementAlimentaire:
        return const Color(0xFF2196F3);
      case ScioCategory.entretienMenager:
        return const Color(0xFFFF9800);
    }
  }

  String _getCategoryName(ScioCategory category) {
    switch (category) {
      case ScioCategory.alimentaire:
        return 'Alimentaire';
      case ScioCategory.cosmetique:
        return 'Cosmétique';
      case ScioCategory.complementAlimentaire:
        return 'Complément';
      case ScioCategory.entretienMenager:
        return 'Entretien';
    }
  }

  Color _getScoreColor() {
    if (entry.scoreNumeric != null) {
      final score = entry.scoreNumeric!;
      if (score >= 85) return AppColors.success;
      if (score >= 65) return AppColors.historyBlue;
      if (score >= 40) return AppColors.searchOrange;
      return AppColors.error;
    }
    
    final label = (entry.scoreLabel ?? '').toLowerCase();
    if (label.contains('excellent') || label.contains('très bon')) return AppColors.success;
    if (label.contains('bon')) return AppColors.historyBlue;
    if (label.contains('moyen') || label.contains('médiocre')) return AppColors.searchOrange;
    if (label.contains('dangereux') || label.contains('risqué') || label.contains('mauvais')) return AppColors.error;
    return AppColors.lightGray;
  }

  String _getScoreText() {
    if (entry.scoreNumeric != null) {
      return '${entry.scoreNumeric}';
    }
    return entry.scoreLabel ?? '-';
  }

  String _getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(entry.scannedAt);
    
    if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes}min';
    } else {
      return 'À l\'instant';
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(entry.category);
    final categoryName = _getCategoryName(entry.category);
    final scoreColor = _getScoreColor();
    final scoreText = _getScoreText();
    final timeAgo = _getTimeAgo();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lightGray.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image du produit
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  'assets/images/SCIO.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.shopping_bag,
                      color: categoryColor,
                      size: 24,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Informations du produit
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGray,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: categoryColor.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          categoryName,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: categoryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeAgo,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Score
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: scoreColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: scoreColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                scoreText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: scoreColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 