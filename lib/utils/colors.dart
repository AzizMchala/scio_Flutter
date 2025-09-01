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
} 