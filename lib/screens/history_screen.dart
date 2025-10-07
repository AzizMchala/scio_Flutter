import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/colors.dart';
import '../services/history_service.dart';
import '../services/favorites_service.dart';
import '../models/history_entry.dart';
import '../models/favorite_entry.dart';
import '../models/scanned_product.dart';
import '../widgets/score_widgets.dart';
import '../controllers/navigation_controller.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryEntry> _all = [];
  String _typeFilter = 'Tous'; // Tous, Vérifié, Non vérifié
  String _sort = 'Plus récent'; // Plus récent/ancien/score croissant/décroissant

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await HistoryService.getAll();
    setState(() {
      _all = items;
    });
  }

  Future<void> _confirmClear() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Effacer l\'historique', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkGray)),
        content: const Text("Voulez-vous vraiment effacer l'historique des scans ?", style: TextStyle(color: AppColors.gray)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler', style: TextStyle(color: AppColors.gray)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );
    if (result == true) {
      await HistoryService.clear();
      await _load();
    }
  }

  List<HistoryEntry> get _filteredSorted {
    List<HistoryEntry> items = List.of(_all);

    // Filter by verification
    if (_typeFilter == 'Vérifié') {
      items = items.where((e) => e.verified == true).toList();
    } else if (_typeFilter == 'Non vérifié') {
      items = items.where((e) => e.verified == false).toList();
    }

    // Sort
    switch (_sort) {
      case 'Plus récent':
        items.sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
        break;
      case 'Plus ancien':
        items.sort((a, b) => a.scannedAt.compareTo(b.scannedAt));
        break;
      case 'Score croissant':
        items.sort((a, b) => _scoreComparable(a).compareTo(_scoreComparable(b)));
        break;
      case 'Score décroissant':
        items.sort((a, b) => _scoreComparable(b).compareTo(_scoreComparable(a)));
        break;
    }

    return items;
  }

  int _scoreComparable(HistoryEntry e) {
    if (e.scoreNumeric != null) return e.scoreNumeric!; // 0..100
    // Map label to order for qualitative
    final label = (e.scoreLabel ?? '').toLowerCase();
    if (label.contains('excellent') || label.contains('très bon')) return 90;
    if (label.contains('bon')) return 70;
    if (label.contains('moyen') || label.contains('médiocre')) return 50;
    if (label.contains('dangereux') || label.contains('risqué') || label.contains('mauvais')) return 20;
    return 0;
  }

  Color _scoreColor(HistoryEntry e) {
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

  String _categoryLabel(ScioCategory c) {
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
    final items = _filteredSorted;

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
                        child: Text(
                          'Historique des scans',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkGray),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.lightGray.withValues(alpha: 0.4)),
                        ),
                        child: Text('${items.length} produit(s)', style: const TextStyle(color: AppColors.gray, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: items.isEmpty ? null : _confirmClear,
                        child: const Text('Effacer l\'historique', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Filters
                  Row(
                    children: [
                      Expanded(
                        child: _Dropdown(
                          label: 'Type',
                          value: _typeFilter,
                          items: const ['Tous', 'Vérifié', 'Non vérifié'],
                          onChanged: (v) => setState(() => _typeFilter = v ?? 'Tous'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _Dropdown(
                          label: 'Tri',
                          value: _sort,
                          items: const ['Plus récent', 'Plus ancien', 'Score croissant', 'Score décroissant'],
                          onChanged: (v) => setState(() => _sort = v ?? 'Plus récent'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

            const SizedBox(height: 16),

            if (items.isEmpty)
              Center(
                child: _EmptyState(onScan: () => navigationController.navigateToScanner()),
              )
            else
              ...items.asMap().entries.map((entry) {
                final index = entry.key;
                final e = entry.value;
                final color = _scoreColor(e);
                final isLast = index == items.length - 1;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timeline column
                      Column(
                        children: [
                          // Dot
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                          ),
                          // Line
                          if (!isLast)
                            Container(
                              width: 2,
                              height: 64,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              color: color.withValues(alpha: 0.3),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // Card
                      Expanded(child: _HistoryCard(entry: e, accent: color)),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _Dropdown({required this.label, required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.gray, fontSize: 12)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.lightGray.withValues(alpha: 0.4)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              items: items.map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryCard extends StatefulWidget {
  final HistoryEntry entry;
  final Color accent;

  const _HistoryCard({required this.entry, required this.accent});

  @override
  State<_HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<_HistoryCard> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final isFavorite = await FavoritesService.isFavorite(widget.entry.barcode);
    if (mounted) {
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      if (_isFavorite) {
        await FavoritesService.removeByBarcode(widget.entry.barcode);
      } else {
        final favoriteEntry = FavoriteEntry(
          barcode: widget.entry.barcode,
          name: widget.entry.name,
          brand: widget.entry.brand,
          category: widget.entry.category,
          verified: widget.entry.verified,
          scoreNumeric: widget.entry.scoreNumeric,
          scoreLabel: widget.entry.scoreLabel,
        );
        await FavoritesService.add(favoriteEntry);
      }
      
      setState(() {
        _isFavorite = !_isFavorite;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isFavorite ? 'Ajouté aux favoris' : 'Retiré des favoris'),
            backgroundColor: widget.accent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la modification des favoris'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(widget.entry.scannedAt);
    final timeStr = _formatTime(widget.entry.scannedAt);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: widget.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset('assets/images/SCIO.png', fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.entry.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.darkGray),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('$dateStr • $timeStr', style: const TextStyle(fontSize: 12, color: AppColors.gray)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${widget.entry.brand} • ${_cat(widget.entry.category)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, color: AppColors.gray),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (widget.entry.verified != null)
                      (widget.entry.verified! ? const VerifiedBadge() : const NonVerifiedBadge()),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: widget.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: widget.accent.withValues(alpha: 0.5)),
                      ),
                      child: Text(
                        _scoreText(widget.entry),
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: widget.accent),
                      ),
                    ),
                    const Spacer(),
                    // Bouton cœur
                    GestureDetector(
                      onTap: _toggleFavorite,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: widget.accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.red : widget.accent,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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

  String _scoreText(HistoryEntry e) => e.scoreNumeric != null ? '${e.scoreNumeric}' : (e.scoreLabel ?? '-');

  String _formatDate(DateTime d) {
    return '${_pad(d.day)}/${_pad(d.month)}/${d.year}';
  }

  String _formatTime(DateTime d) {
    return '${_pad(d.hour)}:${_pad(d.minute)}';
  }

  String _pad(int v) => v.toString().padLeft(2, '0');
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onScan;
  const _EmptyState({required this.onScan});

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
          Icon(Icons.history, size: 48, color: AppColors.lightGray),
          const SizedBox(height: 12),
          const Text('Aucun scan pour le moment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.gray)),
          const SizedBox(height: 6),
          const Text('Votre historique apparaîtra ici après vos premiers scans.', style: TextStyle(fontSize: 14, color: AppColors.lightGray), textAlign: TextAlign.center),
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