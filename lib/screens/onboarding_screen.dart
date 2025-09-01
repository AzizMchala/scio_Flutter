import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../utils/colors.dart';
import '../services/preferences_service.dart';
import 'main_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      icon: Icons.medical_services_outlined,
      title: "Vos analyses médicales",
      subtitle: "Centralisées en un seul endroit",
      description:
          "Gardez toutes vos analyses médicales organisées et facilement accessibles. Plus besoin de chercher dans vos documents papier.",
    ),
    OnboardingData(
      icon: Icons.timeline_outlined,
      title: "Suivi personnalisé",
      subtitle: "Évolution de votre santé",
      description:
          "Visualisez l'évolution de vos indicateurs de santé avec des graphiques clairs et des analyses personnalisées.",
    ),
    OnboardingData(
      icon: Icons.notifications_active_outlined,
      title: "Rappels intelligents",
      subtitle: "Ne manquez plus rien",
      description:
          "Recevez des rappels pour vos prochains examens et des recommandations personnalisées pour votre santé.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() async {
    await PreferencesService.setFirstLaunchCompleted();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MainScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _onboardingData.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header avec bouton "Passer"
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!isLastPage)
                    TextButton(
                      onPressed: _skipOnboarding,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.gray,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text(
                        "Passer",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Contenu principal
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                  _fadeController.reset();
                  _scaleController.reset();
                  _fadeController.forward();
                  _scaleController.forward();
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                                                      child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width * 0.08,
                              ),
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icône avec gradient
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.width * 0.25,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.black87, Colors.black54],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    data.icon,
                                    size: MediaQuery.of(context).size.width * 0.12,
                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(height: 48),

                                // Titre principal
                                Text(
                                  data.title,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkGray,
                                    height: 1.2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 16),

                                // Sous-titre
                                Text(
                                  data.subtitle,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                    height: 1.3,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 24),

                                // Description
                                Text(
                                  data.description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.gray,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Indicateurs de page et boutons de navigation
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  // Indicateurs de page animés
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _onboardingData.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Colors.black,
                      dotColor: AppColors.lightGray,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                      spacing: 8,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Boutons de navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Bouton Précédent
                      if (_currentPage > 0)
                        OutlinedButton(
                          onPressed: _previousPage,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.darkGray,
                            side: const BorderSide(color: AppColors.lightGray),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Précédent",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 100),

                      // Bouton Suivant/Commencer
                      ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          isLastPage ? "Commencer" : "Suivant",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }
}

/// Modèle de données pour les pages d'onboarding
class OnboardingData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
  });
} 