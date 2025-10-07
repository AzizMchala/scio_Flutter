import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/colors.dart';
import '../services/favorites_service.dart';
import '../models/favorite_entry.dart';
import '../models/scanned_product.dart';
import '../widgets/score_widgets.dart';
import '../controllers/navigation_controller.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<FavoriteEntry> _all = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await FavoritesService.getAll();
    setState(() {
      _all = items;
    });
  }

  Future<void> _confirmRemove(String barcode) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Retirer des favoris', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkGray)),
        content: const Text('Voulez-vous retirer ce produit des favoris ?', style: TextStyle(color: AppColors.gray)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler', style: TextStyle(color: AppColors.gray))),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Retirer'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await FavoritesService.removeByBarcode(barcode);
      await _load();
    }
  }

  Future<void> _confirmClearAll() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Effacer tous les favoris', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkGray)),
        content: const Text('Voulez-vous effacer tous les favoris ?', style: TextStyle(color: AppColors.gray)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler', style: TextStyle(color: AppColors.gray))),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Effacer tout'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await FavoritesService.clear();
      await _load();
    }
  }

  Color _scoreColor(FavoriteEntry e) {
    if (e.scoreNumeric != null) {
      final v = e.scoreNumeric!;
      if (v >= 85) return AppColors.success;
      if (v >= 65) return AppColors.historyBlue;
      if (v >= 40) return AppColors.searchOrange;
      return AppColors.error;
    }
    final label = (e.scoreLabel ?? '').toLowerCase();
    if (label.contains('excellent') || label.contains('très bon')) return AppColors.success;
    if (label.contains('bon')) return AppColors.historyBlue;
    if (label.contains('moyen') || label.contains('médiocre')) return AppColors.searchOrange;
    if (label.contains('dangereux') || label.contains('risqué') || label.contains('mauvais')) return AppColors.error;
    return AppColors.lightGray;
  }

  String _cat(ScioCategory c) {
    switch (c) {
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
    final items = _all;

    return MainLayout(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Expanded(
                  child: Text('Vos favoris', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkGray)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.lightGray.withValues(alpha: 0.4)),
                  ),
                  child: Text('${items.length} produit(s) favori(s)', style: const TextStyle(color: AppColors.gray, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: items.isEmpty ? null : _confirmClearAll,
                  child: const Text('Tout effacer', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (items.isEmpty)
              _EmptyFavorites(onScan: () => navigationController.navigateToScanner())
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final e = items[index];
                  final accent = _scoreColor(e);
                  return _FavoriteCard(
                    entry: e,
                    accent: accent,
                    onRemove: () => _confirmRemove(e.barcode),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final FavoriteEntry entry;
  final Color accent;
  final VoidCallback onRemove;

  const _FavoriteCard({required this.entry, required this.accent, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + heart overlay
          Stack(
            children: [
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset('assets/images/SCIO.png', fit: BoxFit.cover),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 6, offset: const Offset(0, 2))],
                    ),
                    child: const Icon(Icons.favorite, color: Colors.red, size: 18),
                  ),
                ),
              ),
            ],
          ),

          // Texts
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.darkGray),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${entry.brand} • ${_cat(entry.category)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: AppColors.gray),
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (entry.verified != null)
                        (entry.verified! ? const VerifiedBadge() : const NonVerifiedBadge()),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: accent.withValues(alpha: 0.5)),
                        ),
                        child: Text(
                          _scoreText(entry),
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: accent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _cat(ScioCategory c) {
    switch (c) {
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

  String _scoreText(FavoriteEntry e) => e.scoreNumeric != null ? '${e.scoreNumeric}' : (e.scoreLabel ?? '-');
}

class _EmptyFavorites extends StatelessWidget {
  final VoidCallback onScan;
  const _EmptyFavorites({required this.onScan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGray.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 48, color: AppColors.lightGray),
          const SizedBox(height: 12),
          const Text('Aucun favori pour le moment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.gray)),
          const SizedBox(height: 6),
          const Text('Ajoutez des produits à vos favoris pour les retrouver rapidement.', style: TextStyle(fontSize: 14, color: AppColors.lightGray), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onScan,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.qr_code_scanner, size: 18),
                SizedBox(width: 8),
                Text('Scanner un produit', style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 