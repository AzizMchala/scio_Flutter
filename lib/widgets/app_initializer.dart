import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../screens/onboarding_screen.dart';
import '../screens/main_screen.dart';

/// Widget qui initialise l'application et détermine l'écran de départ
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isLoading = true;
  bool _isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialiser les services
    await PreferencesService.init();
    
    // Vérifier si c'est la première ouverture
    final isFirstLaunch = PreferencesService.isFirstLaunch;
    
    setState(() {
      _isFirstLaunch = isFirstLaunch;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Afficher un indicateur de chargement minimal pendant l'initialisation
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Retourner l'écran approprié selon la première ouverture
    return _isFirstLaunch 
        ? const OnboardingScreen() 
        : const MainScreen();
  }
} 