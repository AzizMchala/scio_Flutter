import 'package:shared_preferences/shared_preferences.dart';

/// Service pour gérer les préférences utilisateur
class PreferencesService {
  static const String _firstLaunchKey = 'first_launch';
  static SharedPreferences? _prefs;

  /// Initialise le service des préférences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Vérifie si c'est la première ouverture de l'application
  static bool get isFirstLaunch {
    return _prefs?.getBool(_firstLaunchKey) ?? true;
  }

  /// Marque l'application comme ayant été ouverte
  static Future<void> setFirstLaunchCompleted() async {
    await _prefs?.setBool(_firstLaunchKey, false);
  }

  /// Réinitialise le statut de première ouverture (pour les tests)
  static Future<void> resetFirstLaunch() async {
    await _prefs?.setBool(_firstLaunchKey, true);
  }
} 