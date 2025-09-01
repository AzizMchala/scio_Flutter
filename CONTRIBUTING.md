# Guide de Contribution

Merci de votre intérêt pour contribuer au projet Scio Flutter ! 🚀

## 📋 Prérequis

Avant de commencer, assurez-vous d'avoir :

- Flutter SDK (>=3.9.0)
- Dart SDK
- Git
- Un éditeur de code (VS Code ou Android Studio recommandés)

## 🛠️ Configuration de l'environnement de développement

1. **Cloner le projet**
   ```bash
   git clone https://github.com/AzizMchala/scio_Flutter.git
   cd scio_flutter
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Vérifier l'installation**
   ```bash
   flutter doctor
   flutter analyze
   flutter test
   ```

## 🎯 Standards de Code

### Architecture
- Suivre l'architecture modulaire existante
- Séparer les widgets, écrans, services et utilitaires
- Utiliser des widgets réutilisables

### Style de Code
- Respecter les conventions Dart/Flutter
- Utiliser `flutter format` avant chaque commit
- Passer `flutter analyze` sans erreurs
- Maintenir une couverture de tests élevée

### Structure des Fichiers
```
lib/
├── main.dart
├── screens/          # Écrans de l'application
├── widgets/          # Widgets réutilisables
├── services/         # Services et logique métier
└── utils/           # Utilitaires et constantes
```

## 🔄 Processus de Contribution

1. **Créer une branche**
   ```bash
   git checkout -b feature/nom-de-votre-fonctionnalite
   ```

2. **Développer votre fonctionnalité**
   - Écrire du code propre et documenté
   - Ajouter des tests si nécessaire
   - Suivre les conventions existantes

3. **Tester votre code**
   ```bash
   flutter test
   flutter analyze
   flutter build apk --debug  # Test Android
   flutter build ios --debug  # Test iOS (sur macOS)
   ```

4. **Commit et Push**
   ```bash
   git add .
   git commit -m "feat: description de votre fonctionnalité"
   git push origin feature/nom-de-votre-fonctionnalite
   ```

5. **Créer une Pull Request**
   - Description claire des changements
   - Captures d'écran si applicable
   - Tests passants

## 📝 Types de Commits

Utilisez des messages de commit conventionnels :

- `feat:` Nouvelle fonctionnalité
- `fix:` Correction de bug
- `docs:` Documentation
- `style:` Formatage, style
- `refactor:` Refactoring du code
- `test:` Tests
- `chore:` Maintenance

## 🐛 Signaler des Bugs

Utilisez les issues GitHub avec :
- Description claire du problème
- Étapes pour reproduire
- Captures d'écran si applicable
- Informations sur l'environnement

## 💡 Proposer des Fonctionnalités

- Créer une issue avec le label `enhancement`
- Décrire clairement la fonctionnalité souhaitée
- Expliquer les cas d'usage

## 📱 Tests sur Appareils

Testez sur :
- Différentes tailles d'écran
- iOS et Android
- Mode sombre et clair
- Différentes orientations

## ✅ Checklist avant Soumission

- [ ] Code formaté avec `flutter format`
- [ ] Aucune erreur avec `flutter analyze`
- [ ] Tests passants avec `flutter test`
- [ ] Documentation mise à jour si nécessaire
- [ ] Testé sur iOS et Android
- [ ] Responsive design vérifié

## 🤝 Code de Conduite

- Soyez respectueux et professionnel
- Aidez les autres contributeurs
- Maintenez un environnement accueillant

## 📞 Contact

Pour toute question, n'hésitez pas à ouvrir une issue ou contacter l'équipe de développement.

Merci pour vos contributions ! 🙏 