import 'package:flutter/material.dart';

class AppColors {
  // Couleur principale - Indigo moderne
  static const Color primary = Color(0xFF6366F1);
  
  // Couleurs de texte
  static const Color darkGray = Color(0xFF111827);
  static const Color gray = Color(0xFF6B7280);
  static const Color lightGray = Color(0xFF9CA3AF);
  
  // Couleurs d'accentuation
  static const Color accent = Color(0xFF8B5CF6);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  
  // Couleurs de surface
  static const Color surface = Color(0xFFF8FAFC);
  static const Color surfaceDark = Color(0xFF1E293B);
  
  // Gradient principal
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Couleurs pour les cartes d'actions rapides
  static const Color scannerGreen = Color(0xFF10B981);
  static const Color historyBlue = Color(0xFF3B82F6);
  static const Color searchOrange = Color(0xFFF59E0B);
  static const Color favoritePurple = Color(0xFF8B5CF6);

  // Couleurs pour les scores
  static const Color scoreA = Color(0xFF10B981); // Vert
  static const Color scoreB = Color(0xFF3B82F6); // Bleu
  static const Color scoreC = Color(0xFFF59E0B); // Orange
  static const Color scoreD = Color(0xFFEF4444); // Rouge

  // Arrière-plan principal
  static const Color background = Color(0xFFF8F9FA);

  // Noir pur pour les éléments sombres
  static const Color pureBlack = Color(0xFF000000);

  // Gradient noir pour l'en-tête
  static const LinearGradient blackGradient = LinearGradient(
    colors: [Color(0xFF000000), Color(0xFF1F1F1F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
} 