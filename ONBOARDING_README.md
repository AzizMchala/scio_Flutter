# 🚀 Système d'Onboarding - Scio Flutter

## Vue d'ensemble

L'application Scio dispose d'un système d'onboarding professionnel qui s'affiche uniquement lors de la première ouverture de l'application. Le système utilise le splash screen natif existant.

## Fonctionnalités

### 🎯 Initialisation de l'App
- **Fichier**: `lib/widgets/app_initializer.dart`
- Initialise les services de l'application après le splash natif
- Vérifie si c'est la première ouverture
- Navigation automatique vers l'onboarding ou l'écran principal

### 📱 Écran d'Onboarding
- **Fichier**: `lib/screens/onboarding_screen.dart`
- **3 pages interactives** :
  1. **Analyses médicales** - Centralisation des documents
  2. **Suivi personnalisé** - Évolution de la santé
  3. **Rappels intelligents** - Notifications et recommandations

### ✨ Animations
- Transitions fluides entre les pages
- Animations d'échelle et de fondu
- Indicateurs de page animés
- Boutons avec feedback visuel

### 🎨 Design Responsive
- Adaptation automatique à toutes les tailles d'écran
- Icônes et textes proportionnels
- Interface Material Design 3

## Architecture

```
lib/
├── widgets/
│   ├── app_initializer.dart    # Point d'entrée avec initialisation
│   └── debug_panel.dart        # Panneau de debug (dev uniquement)
├── screens/
│   ├── onboarding_screen.dart  # Écran d'onboarding 3 pages
│   └── main_screen.dart        # Écran principal de l'app
└── services/
    └── preferences_service.dart # Gestion première ouverture
```

## Utilisation

### Première ouverture
1. **Splash natif** (Android/iOS)
2. **AppInitializer** (initialisation rapide)
3. **Onboarding** (3 pages interactives)
4. **Écran principal**

### Ouvertures suivantes
1. **Splash natif** (Android/iOS)
2. **AppInitializer** (initialisation rapide)
3. **Écran principal** (direct)

## Développement

### Panneau de Debug
Un panneau de debug est disponible sur l'écran principal pour :
- Réinitialiser le statut de première ouverture
- Tester l'onboarding à nouveau

**⚠️ Important**: Supprimer le `DebugPanel` en production !

### Réinitialiser l'onboarding
```dart
// Méthode programmatique
await PreferencesService.resetFirstLaunch();

// Ou via le panneau de debug
```

## Configuration

### Personnaliser les pages d'onboarding
Modifiez la liste `_onboardingData` dans `onboarding_screen.dart` :

```dart
final List<OnboardingData> _onboardingData = [
  OnboardingData(
    icon: Icons.medical_services_outlined,
    title: "Titre personnalisé",
    subtitle: "Sous-titre",
    description: "Description détaillée...",
  ),
  // Ajoutez d'autres pages...
];
```

### Splash Screen Natif
Le système utilise le splash screen natif configuré dans :
- **Android**: `android/app/src/main/res/drawable/launch_background.xml`
- **iOS**: `ios/Runner/Assets.xcassets/LaunchImage.imageset/`

Aucune configuration supplémentaire n'est nécessaire côté Flutter.

## Dépendances

- `shared_preferences: ^2.5.3` - Stockage des préférences
- `smooth_page_indicator: ^1.1.0` - Indicateurs de page animés

## Production

Avant de publier sur les stores :

1. **Supprimer le panneau de debug** :
   ```dart
   // Dans main_screen.dart, supprimer :
   const DebugPanel(),
   ```

2. **Tester le flow complet** :
   - Désinstaller l'app
   - Réinstaller
   - Vérifier l'onboarding après le splash natif
   - Fermer/rouvrir → vérifier que l'onboarding ne s'affiche plus

3. **Optimiser les assets** si nécessaire

## Support

- ✅ iOS
- ✅ Android
- ✅ Responsive design
- ✅ Mode sombre (si activé)
- ✅ Animations fluides
- ✅ Compatible avec splash natif 