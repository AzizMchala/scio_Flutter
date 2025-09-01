import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'scanner_screen.dart';
import 'history_screen.dart';
import 'favorites_screen.dart';
import 'search_screen.dart';
import '../controllers/navigation_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ScannerScreen(),
    const HistoryScreen(),
    const FavoritesScreen(),
    const SearchScreen(),
  ];

  final List<IconData> _navIcons = [
    Icons.home,
    Icons.qr_code_scanner,
    Icons.history,
    Icons.favorite,
    Icons.search,
  ];

  final List<String> _navLabels = [
    'Accueil',
    'Scanner',
    'Historique',
    'Favoris',
    'Recherche',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Écouter les changements du contrôleur de navigation
    navigationController.addListener(_onNavigationChanged);
  }

  @override
  void dispose() {
    navigationController.removeListener(_onNavigationChanged);
    _animationController.dispose();
    super.dispose();
  }

  void _onNavigationChanged() {
    if (navigationController.currentIndex != navigationController.currentIndex) {
      _onItemTapped(navigationController.currentIndex);
    }
  }

  void _onItemTapped(int index) {
    if (index != navigationController.currentIndex) {
      _animationController.forward().then((_) {
        navigationController.navigateToTab(index);
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: navigationController,
      builder: (context, child) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                    child: _screens[navigationController.currentIndex],
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
            top: 8,
            bottom: MediaQuery.of(context).padding.bottom + 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navIcons.length, (index) {
              final isSelected = navigationController.currentIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onItemTapped(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? Colors.black 
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(
                                color: Colors.black,
                                width: 2,
                              )
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedScale(
                            scale: isSelected ? 1.1 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              _navIcons[index],
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _navLabels[index],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 10,
                              fontWeight: isSelected 
                                  ? FontWeight.w600 
                                  : FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
        );
      },
    );
  }
} 