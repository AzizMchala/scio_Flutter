import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product_category.dart';
import '../utils/colors.dart';
import '../widgets/custom_app_bar.dart';
import '../models/scanned_product.dart';
import '../services/product_repository.dart';
import '../widgets/score_widgets.dart';

class ScanResultScreen extends StatefulWidget {
  final String barcode;
  final ProductCategory category;

  const ScanResultScreen({
    super.key,
    required this.barcode,
    required this.category,
  });

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  Future<ScannedProductBase?>? _future;

  @override
  void initState() {
    super.initState();
    _future = ProductRepository.findByBarcode(
      barcode: widget.barcode,
      category: _mapCategory(widget.category.type),
    );
  }

  ScioCategory _mapCategory(ProductCategoryType type) {
    switch (type) {
      case ProductCategoryType.alimentaires:
        return ScioCategory.alimentaire;
      case ProductCategoryType.cosmetiques:
        return ScioCategory.cosmetique;
      case ProductCategoryType.complementsAlimentaires:
        return ScioCategory.complementAlimentaire;
      case ProductCategoryType.entretienMenager:
        return ScioCategory.entretienMenager;
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Code-barres copié dans le presse-papiers'),
        backgroundColor: widget.category.color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<ScannedProductBase?>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return _buildNotFound(context);
            }
            final product = snapshot.data!;
            return _buildContent(context, product);
          },
        ),
      ),
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildHeader(null),
        const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
          child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(
                'Aucun résultat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkGray,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Le produit n\'a pas été trouvé dans les données mockées.',
                style: TextStyle(color: AppColors.gray),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(ScannedProductBase? product) {
    final scoreText = _scoreHeaderText(product);
    final scoreColor = _scoreHeaderColor(product);
    final bool? isVerified = _isVerified(product);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.category.color,
            widget.category.color.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
            width: 72,
            height: 72,
                        decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              'assets/images/SCIO.png',
              fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                Text(
                  product?.name ?? 'Produit',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                            Text(
                  widget.category.shortName,
                              style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isVerified != null)
                    isVerified ? const VerifiedBadge() : const NonVerifiedBadge(),
                ],
              ),
              const SizedBox(height: 8),
                  const Text(
                'Score final',
                style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
                  Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                          child: Text(
                  scoreText,
                  style: TextStyle(
                    color: scoreColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }

  String _scoreHeaderText(ScannedProductBase? product) {
    if (product == null) return '-';
    if (product is FoodProduct) return product.finalScore;
    if (product is CosmeticProductVerified) return _bandScoreLabel(product.finalScore);
    if (product is CosmeticProductUnverified) return product.finalScore;
    if (product is HouseholdProductVerified) return _bandScoreLabel(product.finalScore);
    if (product is HouseholdProductUnverified) return product.finalScore;
    if (product is SupplementProduct) return _bandScoreLabel(product.finalScore);
    return '-';
  }

  Color _scoreHeaderColor(ScannedProductBase? product) {
    if (product == null) return Colors.white;
    if (product is FoodProduct) return _foodScoreColor(product.finalScore);
    if (product is CosmeticProductVerified) return _bandScoreColor(product.finalScore);
    if (product is CosmeticProductUnverified) return _scoreLabelToColorCosmeticHousehold(product.finalScore);
    if (product is HouseholdProductVerified) return _bandScoreColor(product.finalScore);
    if (product is HouseholdProductUnverified) return _scoreLabelToColorCosmeticHousehold(product.finalScore);
    if (product is SupplementProduct) return _bandScoreColor(product.finalScore);
    return Colors.white;
  }

  bool? _isVerified(ScannedProductBase? product) {
    if (product is CosmeticProductVerified) return true;
    if (product is CosmeticProductUnverified) return false;
    if (product is HouseholdProductVerified) return true;
    if (product is HouseholdProductUnverified) return false;
    if (product is SupplementProduct) return product.verified;
    return null; // alimentaires: pas de notion vérifié
  }

  Widget _buildContent(BuildContext context, ScannedProductBase product) {
    final List<Widget> sections = [];

    if (product is FoodProduct) {
      sections.addAll(_buildFoodSections(product));
    } else if (product is CosmeticProductVerified) {
      sections.addAll(_buildCosmeticVerifiedSections(product));
    } else if (product is CosmeticProductUnverified) {
      sections.addAll(_buildCosmeticUnverifiedSections(product));
    } else if (product is HouseholdProductVerified) {
      sections.addAll(_buildHouseholdVerifiedSections(product));
    } else if (product is HouseholdProductUnverified) {
      sections.addAll(_buildHouseholdUnverifiedSections(product));
    } else if (product is SupplementProduct) {
      sections.addAll(_buildSupplementSections(product));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(product),
        const SizedBox(height: 24),

        // Removed the barcode copy block as requested

        ...sections,

        const SizedBox(height: 32),
        Row(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                backgroundColor: widget.category.color,
                    foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  Icon(Icons.qr_code_scanner, size: 18),
                      SizedBox(width: 8),
                  Text('Scanner un autre produit', style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
            const SizedBox(width: 12),
                TextButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  child: const Text(
                    'Retour à l\'accueil',
                style: TextStyle(color: AppColors.gray, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
    );
  }

  List<Widget> _buildFoodSections(FoodProduct product) {
    final color = widget.category.color;
    return [
      SectionTile(
        title: 'Analyse nutritionnelle',
        accentColor: color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _metricCompact(
              title: 'Calories',
              valueText: '${product.nutrition.calories}',
              labelText: _foodCaloriesLabel(product.nutrition.calories),
              labelColor: _foodCaloriesColor(product.nutrition.calories),
            ),
            const SizedBox(height: 12),
            _metricCompact(
              title: 'Matières grasses (g)',
              valueText: product.nutrition.fat.toStringAsFixed(1),
              labelText: _foodFatLabel(product.nutrition.fat),
              labelColor: _foodFatColor(product.nutrition.fat),
            ),
            const SizedBox(height: 12),
            _metricCompact(
              title: 'Sel (mg)',
              valueText: '${product.nutrition.saltMg}',
              labelText: _foodSaltLabel(product.nutrition.saltMg),
              labelColor: _foodSaltColor(product.nutrition.saltMg),
            ),
            const SizedBox(height: 12),
            _metricCompact(
              title: 'Sucre (g)',
              valueText: '${product.nutrition.sugar}',
              labelText: _foodSugarLabel(product.nutrition.sugar),
              labelColor: _foodSugarColor(product.nutrition.sugar),
            ),
            const SizedBox(height: 12),
            _metricCompact(
              title: 'Protéines (g)',
              valueText: '${product.nutrition.proteins}',
              labelText: _foodProteinLabel(product.nutrition.proteins),
              labelColor: _foodProteinColor(product.nutrition.proteins),
            ),
            const SizedBox(height: 12),
            _metricCompact(
              title: 'Fibres (g)',
              valueText: '${product.nutrition.fibers}',
              labelText: _foodFiberLabel(product.nutrition.fibers),
              labelColor: _foodFiberColor(product.nutrition.fibers),
            ),
          ],
        ),
      ),
      SectionTile(
        title: 'Additifs',
        accentColor: color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: product.additives.map((a) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(child: Text(a.name, style: const TextStyle(color: AppColors.darkGray, fontWeight: FontWeight.w600))),
                const SizedBox(width: 8),
                _chip(a.risk, _riskColor(a.risk)),
              ],
            ),
          )).toList(),
        ),
      ),
      SectionTile(
        title: 'Degré de transformation',
        accentColor: color,
        child: _metricCompact(
          title: 'Transformation',
          valueText: product.processingDegree,
          labelText: product.processingDegree,
          labelColor: _processingColor(product.processingDegree),
        ),
      ),
    ];
  }

  List<Widget> _buildCosmeticUnverifiedSections(CosmeticProductUnverified p) {
    final color = widget.category.color;
    return [
      SectionTile(
        title: 'Composition',
        accentColor: color,
        child: _metricCompact(
          title: 'Composition',
          valueText: '${p.composition}',
          labelText: _cosmeticUnvCompositionLabel(p.composition),
          labelColor: _cosmeticUnvCompositionColor(p.composition),
        ),
      ),
      SectionTile(
        title: 'Impact environnemental',
        accentColor: color,
        child: _metricCompact(
          title: 'Impact env',
          valueText: '${p.environmentalImpact}',
          labelText: _cosmeticUnvImpactLabel(p.environmentalImpact),
          labelColor: _cosmeticUnvImpactColor(p.environmentalImpact),
        ),
      ),
      SectionTile(
        title: 'Emballage',
        accentColor: color,
        child: _metricCompact(
          title: 'Emballage',
          valueText: '${p.packaging}',
          labelText: _packagingLabel(p.packaging),
          labelColor: _packagingColor(p.packaging),
        ),
      ),
    ];
  }

  List<Widget> _buildCosmeticVerifiedSections(CosmeticProductVerified p) {
    final color = widget.category.color;
    return [
      SectionTile(
        title: 'Composition',
        accentColor: color,
        child: _metricCompact(
          title: 'Composition',
          valueText: '${p.composition}',
          labelText: _cosmeticVCompositionLabel(p.composition),
          labelColor: _cosmeticVCompositionColor(p.composition),
        ),
      ),
      SectionTile(
        title: 'Impact environnemental',
        accentColor: color,
        child: _metricCompact(
          title: 'Impact env',
          valueText: '${p.environmentalImpact}',
          labelText: _cosmeticVImpactLabel(p.environmentalImpact),
          labelColor: _cosmeticVImpactColor(p.environmentalImpact),
        ),
      ),
      SectionTile(
        title: 'Tests de conformité',
        accentColor: color,
        child: _metricCompact(
          title: 'Tests',
          valueText: '${p.conformityTests}',
          labelText: _cosmeticVTestsLabel(p.conformityTests),
          labelColor: _cosmeticVTestsColor(p.conformityTests),
        ),
      ),
      SectionTile(
        title: 'Emballage',
        accentColor: color,
        child: _metricCompact(
          title: 'Emballage',
          valueText: '${p.packaging}',
          labelText: _packagingLabel(p.packaging),
          labelColor: _packagingColor(p.packaging),
        ),
      ),
    ];
  }

  List<Widget> _buildHouseholdUnverifiedSections(HouseholdProductUnverified p) {
    final color = widget.category.color;
    return [
      SectionTile(
        title: 'Composition',
        accentColor: color,
        child: _metricCompact(
          title: 'Composition',
          valueText: '${p.composition}',
          labelText: _householdUnvCompositionLabel(p.composition),
          labelColor: _householdUnvCompositionColor(p.composition),
        ),
      ),
      SectionTile(
        title: 'Impact environnemental',
        accentColor: color,
        child: _metricCompact(
          title: 'Impact env',
          valueText: '${p.environmentalImpact}',
          labelText: _householdUnvImpactLabel(p.environmentalImpact),
          labelColor: _householdUnvImpactColor(p.environmentalImpact),
        ),
      ),
    ];
  }

  List<Widget> _buildHouseholdVerifiedSections(HouseholdProductVerified p) {
    final color = widget.category.color;
    return [
      SectionTile(
        title: 'Composition',
        accentColor: color,
        child: _metricCompact(
          title: 'Composition',
          valueText: '${p.composition}',
          labelText: _householdVCompositionLabel(p.composition),
          labelColor: _householdVCompositionColor(p.composition),
        ),
      ),
      SectionTile(
        title: 'Tests de conformité',
        accentColor: color,
        child: _metricCompact(
          title: 'Tests',
          valueText: '${p.conformityTests}',
          labelText: _householdVTestsLabel(p.conformityTests),
          labelColor: _householdVTestsColor(p.conformityTests),
        ),
      ),
      SectionTile(
        title: 'Impact environnemental',
        accentColor: color,
        child: _metricCompact(
          title: 'Impact env',
          valueText: '${p.environmentalImpact}',
          labelText: _householdVImpactLabel(p.environmentalImpact),
          labelColor: _householdVImpactColor(p.environmentalImpact),
        ),
      ),
    ];
  }

  List<Widget> _buildSupplementSections(SupplementProduct p) {
    final color = widget.category.color;
    return [
      SectionTile(
        title: 'Composition',
        accentColor: color,
        child: _metricCompact(
          title: 'Composition',
          valueText: '${p.composition}',
          labelText: _suppCompositionLabel(p.composition),
          labelColor: _suppCompositionColor(p.composition),
        ),
      ),
      SectionTile(
        title: 'Traçabilité',
        accentColor: color,
        child: _metricCompact(
          title: 'Traçabilité',
          valueText: '${p.traceability}',
          labelText: _suppTraceabilityLabel(p.traceability),
          labelColor: _suppTraceabilityColor(p.traceability),
        ),
      ),
      SectionTile(
        title: 'Mode d\'emploi',
        accentColor: color,
        child: _metricCompact(
          title: 'Mode d\'emploi',
          valueText: '${p.usageMode}',
          labelText: _suppUsageLabel(p.usageMode),
          labelColor: _suppUsageColor(p.usageMode),
        ),
      ),
      SectionTile(
        title: 'Emballage',
        accentColor: color,
        child: _metricCompact(
          title: 'Emballage',
          valueText: '${p.packaging}',
          labelText: _suppPackagingLabel(p.packaging),
          labelColor: _suppPackagingColor(p.packaging),
        ),
      ),
    ];
  }

  Widget _legend(List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }

  Widget _metric(String title, String value, List<RangeLegendItem> legend) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.darkGray),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.lightGray.withValues(alpha: 0.4)),
              ),
              child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.darkGray)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...legend,
      ],
    );
  }

  Widget _valueWithLegend(int value, List<RangeLegendItem> legend) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.lightGray.withValues(alpha: 0.4)),
          ),
          child: Text('$value', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.darkGray)),
        ),
        const SizedBox(height: 8),
        ...legend,
      ],
    );
  }

  Color _riskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'sans risque':
        return AppColors.success;
      case 'risque modéré':
        return AppColors.searchOrange;
      case 'risque élevé':
        return AppColors.error;
      default:
        return AppColors.lightGray;
    }
  }

  Color _scoreColorFromLabel(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('très bon')) return AppColors.success;
    if (lower.contains('bon')) return AppColors.historyBlue;
    if (lower.contains('moyen')) return AppColors.searchOrange;
    if (lower.contains('mauvais')) return AppColors.error;
    if (lower.contains('très mauvais')) return Colors.redAccent;
    return AppColors.lightGray;
  }

  Color _scoreLabelToColorCosmeticHousehold(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('excellent')) return AppColors.success;
    if (lower.contains('bon')) return AppColors.historyBlue;
    if (lower.contains('médiocre')) return AppColors.searchOrange;
    if (lower.contains('dangereux') || lower.contains('risqué')) return AppColors.error;
    return AppColors.lightGray;
  }

  Widget _metricCompact({
    required String title,
    required String valueText,
    required String labelText,
    required Color labelColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.darkGray),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.lightGray.withValues(alpha: 0.4)),
          ),
          child: Text(valueText, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.darkGray)),
        ),
        const SizedBox(width: 8),
        _chip(labelText, labelColor),
      ],
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 12),
      ),
    );
  }

  // Label & color mappings
  String _foodScoreLabel(String score) => score; // already qualitative
  Color _foodScoreColor(String score) => _scoreColorFromLabel(score);

  String _foodCaloriesLabel(int v) {
    if (v <= 100) return 'Pas calorique';
    if (v <= 220) return 'Modéré';
    if (v <= 340) return 'Élevé';
    return 'Très élevé';
  }
  Color _foodCaloriesColor(int v) {
    if (v <= 100) return AppColors.success;
    if (v <= 220) return AppColors.historyBlue;
    if (v <= 340) return AppColors.searchOrange;
    return AppColors.error;
  }

  String _foodFatLabel(double v) {
    if (v <= 1.2) return 'Faible';
    if (v <= 2.4) return 'Modérée';
    if (v <= 4.2) return 'Élevée';
    return 'Très élevée';
  }
  Color _foodFatColor(double v) {
    if (v <= 1.2) return AppColors.success;
    if (v <= 2.4) return AppColors.historyBlue;
    if (v <= 4.2) return AppColors.searchOrange;
    return AppColors.error;
  }

  String _foodSaltLabel(int v) {
    if (v <= 110) return 'Faible';
    if (v <= 215) return 'Modérée';
    if (v <= 380) return 'Élevée';
    return 'Très élevée';
  }
  Color _foodSaltColor(int v) {
    if (v <= 110) return AppColors.success;
    if (v <= 215) return AppColors.historyBlue;
    if (v <= 380) return AppColors.searchOrange;
    return AppColors.error;
  }

  String _foodSugarLabel(int v) {
    if (v <= 5.5) return 'Faible';
    if (v <= 11) return 'Modérée';
    if (v <= 18) return 'Élevée';
    return 'Très élevée';
  }
  Color _foodSugarColor(int v) {
    if (v <= 5.5) return AppColors.success;
    if (v <= 11) return AppColors.historyBlue;
    if (v <= 18) return AppColors.searchOrange;
    return AppColors.error;
  }

  String _foodProteinLabel(int v) => v <= 5 ? 'Faible' : 'Bon apport';
  Color _foodProteinColor(int v) => v <= 5 ? AppColors.error : AppColors.success;

  String _foodFiberLabel(int v) => v <= 3 ? 'Faible' : 'Riche';
  Color _foodFiberColor(int v) => v <= 3 ? AppColors.error : AppColors.success;

  Color _processingColor(String degree) {
    final d = degree.toLowerCase();
    if (d.contains('peu')) return AppColors.success;
    if (d.contains('moyenn')) return AppColors.historyBlue;
    if (d.contains('ultra')) return AppColors.error;
    return AppColors.searchOrange; // transformé
  }

  String _cosmeticUnvCompositionLabel(int v) {
    if (v >= 58) return 'Bonne';
    if (v >= 29) return 'Moyenne';
    return 'Mauvaise';
  }
  Color _cosmeticUnvCompositionColor(int v) {
    if (v >= 58) return AppColors.success;
    if (v >= 29) return AppColors.searchOrange;
    return AppColors.error;
  }
  String _cosmeticUnvImpactLabel(int v) => v >= 6 ? 'Faible' : 'Considérable';
  Color _cosmeticUnvImpactColor(int v) => v >= 6 ? AppColors.success : AppColors.error;

  String _packagingLabel(int v) => v >= 5 ? 'Conforme' : 'Non conforme';
  Color _packagingColor(int v) => v >= 5 ? AppColors.success : AppColors.error;

  String _bandScoreLabel(int v) {
    if (v >= 85) return 'Excellent';
    if (v >= 65) return 'Bon';
    if (v >= 40) return 'Médiocre';
    return 'Dangereux';
  }
  Color _bandScoreColor(int v) {
    if (v >= 85) return AppColors.success;
    if (v >= 65) return AppColors.historyBlue;
    if (v >= 40) return AppColors.searchOrange;
    return AppColors.error;
  }

  String _cosmeticVCompositionLabel(int v) {
    if (v >= 31) return 'Bonne';
    if (v >= 16) return 'Moyenne';
    return 'Mauvaise';
  }
  Color _cosmeticVCompositionColor(int v) {
    if (v >= 31) return AppColors.success;
    if (v >= 16) return AppColors.searchOrange;
    return AppColors.error;
  }
  String _cosmeticVImpactLabel(int v) => v >= 5 ? 'Faible' : 'Considérable';
  Color _cosmeticVImpactColor(int v) => v >= 5 ? AppColors.success : AppColors.error;
  String _cosmeticVTestsLabel(int v) {
    if (v >= 27) return 'Dans les normes';
    if (v >= 14) return 'Plus ou moins';
    return 'Non conforme';
  }
  Color _cosmeticVTestsColor(int v) {
    if (v >= 27) return AppColors.success;
    if (v >= 14) return AppColors.searchOrange;
    return AppColors.error;
  }

  String _householdUnvCompositionLabel(int v) {
    if (v >= 41) return 'Bonne';
    if (v >= 21) return 'Moyenne';
    return 'Mauvaise';
  }
  Color _householdUnvCompositionColor(int v) {
    if (v >= 41) return AppColors.success;
    if (v >= 21) return AppColors.searchOrange;
    return AppColors.error;
  }
  String _householdUnvImpactLabel(int v) => v >= 21 ? 'Faible' : 'Considérable';
  Color _householdUnvImpactColor(int v) => v >= 21 ? AppColors.success : AppColors.error;

  String _householdVCompositionLabel(int v) {
    if (v >= 28) return 'Bonne';
    if (v >= 16) return 'Moyenne';
    return 'Mauvaise';
  }
  Color _householdVCompositionColor(int v) {
    if (v >= 28) return AppColors.success;
    if (v >= 16) return AppColors.searchOrange;
    return AppColors.error;
  }
  String _householdVTestsLabel(int v) {
    if (v <= 15) return 'Dans les normes';
    if (v <= 30) return 'Plus ou moins';
    return 'Non conforme';
  }
  Color _householdVTestsColor(int v) {
    if (v <= 15) return AppColors.success;
    if (v <= 30) return AppColors.searchOrange;
    return AppColors.error;
  }
  String _householdVImpactLabel(int v) => v >= 6 ? 'Faible' : 'Considérable';
  Color _householdVImpactColor(int v) => v >= 6 ? AppColors.success : AppColors.error;

  String _suppCompositionLabel(int v) {
    if (v >= 41) return 'Bonne';
    if (v >= 21) return 'Moyenne';
    return 'Mauvaise';
  }
  Color _suppCompositionColor(int v) {
    if (v >= 41) return AppColors.success;
    if (v >= 21) return AppColors.searchOrange;
    return AppColors.error;
  }
  String _suppTraceabilityLabel(int v) {
    if (v >= 21) return 'Claire';
    if (v >= 11) return 'Moyenne';
    return 'Mauvaise';
  }
  Color _suppTraceabilityColor(int v) {
    if (v >= 21) return AppColors.success;
    if (v >= 11) return AppColors.searchOrange;
    return AppColors.error;
  }
  String _suppUsageLabel(int v) => v >= 6 ? 'Clair' : 'Ambigu';
  Color _suppUsageColor(int v) => v >= 6 ? AppColors.success : AppColors.error;
  String _suppPackagingLabel(int v) => v >= 6 ? 'Conforme' : 'Non conforme';
  Color _suppPackagingColor(int v) => v >= 6 ? AppColors.success : AppColors.error;
} 