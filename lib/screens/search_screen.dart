import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/colors.dart';
import '../services/product_repository.dart';
import '../models/product_category.dart';
import '../models/scanned_product.dart';
import '../screens/scan_result_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await ProductRepository.searchProducts(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  void _onProductTap(SearchResult result) {
    final category = _mapScioToProductCategory(result.category);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScanResultScreen(
          barcode: result.barcode,
          category: category,
        ),
      ),
    );
  }

  ProductCategory _mapScioToProductCategory(ScioCategory scioCategory) {
    switch (scioCategory) {
      case ScioCategory.alimentaire:
        return ProductCategory(type: ProductCategoryType.alimentaires);
      case ScioCategory.cosmetique:
        return ProductCategory(type: ProductCategoryType.cosmetiques);
      case ScioCategory.complementAlimentaire:
        return ProductCategory(type: ProductCategoryType.complementsAlimentaires);
      case ScioCategory.entretienMenager:
        return ProductCategory(type: ProductCategoryType.entretienMenager);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            const Text(
              'Recherche de produits',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Recherchez par nom de produit ou code-barres',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.gray,
              ),
            ),
            const SizedBox(height: 20),

            // Barre de recherche
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _performSearch,
                decoration: InputDecoration(
                  hintText: 'Nom du produit ou code-barres...',
                  hintStyle: const TextStyle(color: AppColors.gray),
                  prefixIcon: const Icon(Icons.search, color: AppColors.searchOrange),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.gray),
                          onPressed: () {
                            _searchController.clear();
                            _performSearch('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Résultats de recherche
            if (_isSearching)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: AppColors.searchOrange),
                ),
              )
            else if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: AppColors.lightGray,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Aucun produit trouvé',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Essayez avec un autre terme de recherche',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.lightGray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else if (_searchResults.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_searchResults.length} résultat(s) trouvé(s)',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...(_searchResults.map((result) => _buildSearchResultCard(result)).toList()),
                ],
              )
            else
              Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.searchOrange.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.search,
                          size: 40,
                          color: AppColors.searchOrange,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Commencez votre recherche',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGray,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tapez le nom d\'un produit ou son code-barres\npour voir les résultats',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.gray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultCard(SearchResult result) {
    final categoryColor = _getCategoryColor(result.category);
    final categoryName = _getCategoryName(result.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
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
        title: Text(
          result.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGray,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: categoryColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    categoryName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: categoryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Code: ${result.barcode}',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.gray,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.gray,
        ),
        onTap: () => _onProductTap(result),
      ),
    );
  }
} 