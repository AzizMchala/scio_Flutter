# Scio Flutter App

Une application Flutter moderne et professionnelle avec un système de navigation par onglets.

## ✨ Fonctionnalités

### 🏠 Écran d'accueil
- **AppBar personnalisé** : Titre "Accueil" centré, fond transparent, couleur de texte gris foncé (#111827)
- **Interface utilisateur moderne** : Design épuré avec conteneurs stylisés
- **Texte placeholder** : "Home Screen - À implémenter"

### 📱 Navigation par onglets
La navigation en bas contient 5 onglets avec des icônes interactives :

1. **🏠 Accueil** (sélectionné par défaut)
   - Icône : `Icons.home`
   - Style sélectionné : Fond noir avec icône blanche

2. **📱 Scanner**
   - Icône : `Icons.qr_code_scanner`
   - Fonctionnalité de scan QR (à implémenter)

3. **📋 Historique**
   - Icône : `Icons.history`
   - Historique des scans (à implémenter)

4. **❤️ Favoris**
   - Icône : `Icons.favorite`
   - Éléments favoris (à implémenter)

5. **🔍 Recherche**
   - Icône : `Icons.search`
   - Fonction de recherche (à implémenter)

## 🎨 Design

### Couleurs principales
- **Indigo moderne** : `#6366F1` (couleur principale)
- **Gris foncé** : `#111827` (texte)
- **Surface claire** : `#F8FAFC`
- **Surface sombre** : `#1E293B`

### Thèmes
- **Thème clair** : Par défaut
- **Mode sombre** : Compatible et optimisé
- **Typographie** : Moderne et épurée
- **Animations** : Transitions fluides avec effets visuels

### Animations
- L'onglet sélectionné a un effet visuel avec ombre et bordures arrondies
- Animations de transition entre les écrans
- Effets d'échelle lors de la sélection

## 🏗️ Architecture

```
lib/
├── main.dart                 # Point d'entrée de l'application
├── screens/
│   ├── main_screen.dart      # Écran principal avec navigation
│   ├── home_screen.dart      # Écran d'accueil
│   ├── scanner_screen.dart   # Écran scanner (placeholder)
│   ├── history_screen.dart   # Écran historique (placeholder)
│   ├── favorites_screen.dart # Écran favoris (placeholder)
│   └── search_screen.dart    # Écran recherche (placeholder)
├── widgets/
│   └── custom_app_bar.dart   # AppBar personnalisé réutilisable
└── utils/
    └── colors.dart           # Palette de couleurs centralisée
```

## 🚀 Installation et utilisation

### Prérequis
- Flutter SDK (>=3.9.0)
- Dart SDK
- Android Studio / VS Code
- Émulateur Android ou appareil physique

### Installation
```bash
# Cloner le projet
git clone <url-du-repo>
cd scio_flutter

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run
```

### Tests
```bash
# Exécuter tous les tests
flutter test

# Analyser le code
flutter analyze
```

### Build de production
```bash
# Android APK
flutter build apk --release

# Android App Bundle (pour Play Store)
flutter build appbundle --release

# iOS (sur macOS uniquement)
flutter build ios --release
```

## 📱 Compatibilité

### Plateformes supportées
- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12.0+)
- ✅ **Web** (PWA)
- ✅ **Windows** (Desktop)
- ✅ **macOS** (Desktop)
- ✅ **Linux** (Desktop)

### Appareils testés
- Smartphones Android & iOS
- Tablettes
- Applications de bureau

## 🔧 Configuration

### Nom de l'application
Pour changer le nom affiché de l'application :
- **Android** : `android/app/src/main/AndroidManifest.xml`
- **iOS** : `ios/Runner/Info.plist`

### Icônes de l'application
Les icônes sont situées dans :
- **Android** : `android/app/src/main/res/mipmap-*/`
- **iOS** : `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

## 🔮 Prochaines étapes

1. **Implémentation du scanner QR**
   - Intégration de `qr_code_scanner`
   - Interface de scan en temps réel

2. **Système d'historique**
   - Base de données locale (SQLite)
   - Liste des scans précédents

3. **Gestion des favoris**
   - Sauvegarde locale
   - Synchronisation cloud (optionnel)

4. **Fonction de recherche**
   - Recherche dans l'historique
   - Filtres avancés

5. **Fonctionnalités avancées**
   - Notifications push
   - Partage de contenu
   - Export de données

## 📄 Licence

Ce projet est développé pour Scio. Tous droits réservés.

## 👨‍💻 Développement

Application développée avec Flutter pour une expérience native sur toutes les plateformes, prête pour publication sur App Store et Google Play Store.

### Standards de code
- Code propre et professionnel
- Architecture modulaire
- Tests unitaires et d'intégration
- Documentation complète
- Optimisé pour la production
