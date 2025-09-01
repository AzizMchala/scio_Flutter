import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void navigateToTab(int index) {
    if (index != _currentIndex && index >= 0 && index < 5) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void navigateToHome() => navigateToTab(0);
  void navigateToScanner() => navigateToTab(1);
  void navigateToHistory() => navigateToTab(2);
  void navigateToFavorites() => navigateToTab(3);
  void navigateToSearch() => navigateToTab(4);
}

// Instance globale du contrôleur
final NavigationController navigationController = NavigationController(); 