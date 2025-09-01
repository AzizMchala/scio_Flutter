# Guide de Déploiement - Scio Flutter App

Ce guide vous accompagne étape par étape pour publier votre application Flutter sur Google Play Store et Apple App Store.

## 📋 Prérequis

### Outils requis
- Flutter SDK (>=3.9.0)
- Android Studio avec Android SDK
- Xcode (pour iOS, macOS uniquement)
- Comptes développeur :
  - Google Play Console (25$ une fois)
  - Apple Developer Program (99$/an)

### Préparation des assets
- Icônes de l'application (toutes les tailles)
- Captures d'écran pour les stores
- Description de l'application
- Politique de confidentialité
- Conditions d'utilisation

## 🤖 Déploiement Android (Google Play Store)

### 1. Configuration de la signature

#### Créer un keystore
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

#### Configurer la signature dans `android/key.properties`
```properties
storePassword=<mot_de_passe_du_store>
keyPassword=<mot_de_passe_de_la_clé>
keyAlias=upload
storeFile=<chemin_vers_le_keystore>
```

#### Modifier `android/app/build.gradle.kts`
```kotlin
android {
    ...
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

### 2. Build de production
```bash
# Nettoyer le projet
flutter clean
flutter pub get

# Analyser et tester
flutter analyze
flutter test

# Build App Bundle (recommandé)
flutter build appbundle --release

# Ou build APK
flutter build apk --release --split-per-abi
```

### 3. Upload sur Google Play Console

1. **Créer une nouvelle application**
   - Connectez-vous à Google Play Console
   - Créez une nouvelle app
   - Remplissez les informations de base

2. **Configuration de l'application**
   - Nom de l'application : "Scio"
   - Description courte et longue
   - Catégorie : Outils ou Productivité
   - Tags et mots-clés

3. **Assets graphiques**
   - Icône de l'application (512x512 PNG)
   - Bannière de fonctionnalité (1024x500 PNG)
   - Captures d'écran (téléphone, tablette, TV)
   - Vidéo de présentation (optionnel)

4. **Upload de l'AAB**
   - Allez dans "Version de production"
   - Uploadez `build/app/outputs/bundle/release/app-release.aab`
   - Ajoutez les notes de version

5. **Politique de confidentialité et contenu**
   - URL de la politique de confidentialité
   - Classification du contenu
   - Public cible

6. **Publication**
   - Examinez tous les éléments
   - Soumettez pour révision
   - Attendre l'approbation (2-3 jours)

## 🍎 Déploiement iOS (Apple App Store)

### 1. Configuration Xcode

#### Ouvrir le projet iOS
```bash
open ios/Runner.xcworkspace
```

#### Configuration dans Xcode
1. **Team et Bundle ID**
   - Sélectionnez votre équipe de développement
   - Configurez un Bundle ID unique : `com.scio.app.scio_flutter`

2. **Signing & Capabilities**
   - Activez "Automatically manage signing"
   - Sélectionnez votre équipe

3. **Deployment Info**
   - Version minimum iOS : 12.0
   - Orientations supportées
   - Statut bar style

### 2. Build et Archive

#### Via Xcode
1. **Schéma de build**
   - Sélectionnez "Runner" > "Any iOS Device"
   - Choisissez le schéma "Release"

2. **Archive**
   - Menu : Product > Archive
   - Attendez la compilation
   - L'Organizer s'ouvre automatiquement

3. **Distribution**
   - Sélectionnez "Distribute App"
   - Choisissez "App Store Connect"
   - Suivez l'assistant

#### Via ligne de commande
```bash
# Build iOS
flutter build ios --release

# Archive avec xcodebuild
cd ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Release archive -archivePath build/Runner.xcarchive

# Export vers App Store
xcodebuild -exportArchive -archivePath build/Runner.xcarchive -exportOptionsPlist ExportOptions.plist -exportPath build/
```

### 3. App Store Connect

1. **Créer une nouvelle app**
   - Connectez-vous à App Store Connect
   - "Mes apps" > "+" > "Nouvelle app"
   - Remplissez les informations

2. **Informations de l'app**
   - Nom : "Scio"
   - Sous-titre (optionnel)
   - Catégorie : Utilitaires ou Productivité
   - Description
   - Mots-clés
   - URL de support
   - URL marketing (optionnel)

3. **Assets et captures d'écran**
   - Captures iPhone (6.5", 5.5")
   - Captures iPad (12.9", 11")
   - Icône App Store (1024x1024 PNG)
   - Aperçu app (vidéos optionnelles)

4. **Informations de version**
   - Numéro de version : 1.0.0
   - Notes de version
   - Classification par âge

5. **Révision et soumission**
   - Vérifiez toutes les sections
   - Soumettez pour révision
   - Attendre l'approbation (1-7 jours)

## 🌐 Déploiement Web

### Build et déploiement
```bash
# Build Web
flutter build web --release

# Déployer sur votre serveur
# Exemple avec Firebase Hosting
firebase deploy

# Exemple avec Netlify
# Glissez-déposez le dossier build/web sur Netlify
```

### Configuration serveur
- Configurez HTTPS
- Headers de sécurité appropriés
- Compression Gzip
- Cache des assets statiques

## 📱 Tests avant publication

### Tests essentiels
- [ ] Fonctionnalités principales
- [ ] Navigation entre écrans
- [ ] Responsive design
- [ ] Mode sombre/clair
- [ ] Performance sur appareils bas de gamme
- [ ] Rotation d'écran
- [ ] Tests sur différentes tailles d'écran

### Tests spécifiques aux plateformes
- [ ] **Android** : Bouton retour système, notifications
- [ ] **iOS** : Gestes système, Safe Area, notch

## 🔄 Mises à jour

### Process de mise à jour
1. Incrémenter la version dans `pubspec.yaml`
2. Mettre à jour `CHANGELOG.md`
3. Build et test complets
4. Upload nouvelle version
5. Notes de version claires

### Versioning
- **Patch** (1.0.1) : Corrections de bugs
- **Minor** (1.1.0) : Nouvelles fonctionnalités
- **Major** (2.0.0) : Changements majeurs

## 🚨 Checklist finale

### Avant soumission
- [ ] Tests complets sur appareils réels
- [ ] Performance optimisée
- [ ] Taille de l'app raisonnable
- [ ] Politique de confidentialité à jour
- [ ] Conditions d'utilisation
- [ ] Assets graphiques conformes
- [ ] Descriptions traduites (si multilingue)
- [ ] Conformité aux guidelines des stores

### Après publication
- [ ] Surveiller les métriques
- [ ] Répondre aux avis utilisateurs
- [ ] Planifier les prochaines mises à jour
- [ ] Analyser les crashs et erreurs

## 🆘 Résolution de problèmes

### Erreurs communes Android
- **Signature** : Vérifier le keystore et les mots de passe
- **Permissions** : Déclarer dans AndroidManifest.xml
- **API Level** : Vérifier la compatibilité

### Erreurs communes iOS
- **Certificats** : Renouveler si expirés
- **Provisioning** : Vérifier les profils
- **Archive** : Nettoyer et rebuild si échec

## 📞 Support

Pour toute question sur le déploiement :
- Documentation officielle Flutter
- Forums des développeurs Google/Apple
- Stack Overflow avec tag #flutter

---

**Bonne chance pour votre déploiement ! 🚀** 