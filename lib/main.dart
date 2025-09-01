import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/app_initializer.dart';
import 'utils/colors.dart';

void main() {
  runApp(const ScioApp());
}

class ScioApp extends StatelessWidget {
  const ScioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.darkGray,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.white,
          unselectedItemColor: AppColors.gray,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1E293B),
          selectedItemColor: Colors.white,
          unselectedItemColor: AppColors.gray,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      ),
      home: const AppInitializer(),
    );
  }
}
