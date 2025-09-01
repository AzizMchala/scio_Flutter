import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../screens/onboarding_screen.dart';

/// Widget de debug pour les tests de développement
/// À supprimer en production
class DebugPanel extends StatelessWidget {
  const DebugPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // N'afficher le panneau de debug qu'en mode debug
    return Visibility(
      visible: true, // Changez à false pour désactiver
      child: Positioned(
        top: 50,
        right: 20,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "DEBUG",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  await PreferencesService.resetFirstLaunch();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const OnboardingScreen(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(80, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: const Text(
                  "Reset\nOnboarding",
                  style: TextStyle(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 