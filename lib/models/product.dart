class Product {
  final String id;
  final String name;
  final DateTime scanDate;
  final ProductScore score;
  final bool isNew;

  Product({
    required this.id,
    required this.name,
    required this.scanDate,
    required this.score,
    this.isNew = false,
  });

  // Formatage de la date pour l'affichage
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(scanDate);

    if (difference.inDays == 0) {
      return 'Aujourd\'hui';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} jours';
    } else {
      return '${scanDate.day}/${scanDate.month}/${scanDate.year}';
    }
  }
}

enum ProductScore {
  A,
  B,
  C,
  D;

  String get letter => name;
  
  String get description {
    switch (this) {
      case ProductScore.A:
        return 'Excellent';
      case ProductScore.B:
        return 'Bon';
      case ProductScore.C:
        return 'Moyen';
      case ProductScore.D:
        return 'Mauvais';
    }
  }
} 