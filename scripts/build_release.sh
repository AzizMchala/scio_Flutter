#!/bin/bash

# Script de build de production pour Scio Flutter
# Ce script génère les builds pour Android et iOS prêts pour les stores

echo "🚀 Début du processus de build de production pour Scio Flutter"
echo "================================================================"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Vérification des prérequis
echo -e "${BLUE}📋 Vérification des prérequis...${NC}"

# Vérifier Flutter
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter n'est pas installé ou pas dans le PATH${NC}"
    exit 1
fi

# Vérifier la version de Flutter
FLUTTER_VERSION=$(flutter --version | head -n 1 | cut -d ' ' -f 2)
echo -e "${GREEN}✅ Flutter $FLUTTER_VERSION détecté${NC}"

# Nettoyer le projet
echo -e "${BLUE}🧹 Nettoyage du projet...${NC}"
flutter clean
flutter pub get

# Analyser le code
echo -e "${BLUE}🔍 Analyse du code...${NC}"
flutter analyze
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Erreurs d'analyse détectées. Veuillez les corriger avant de continuer.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Analyse du code réussie${NC}"

# Exécuter les tests
echo -e "${BLUE}🧪 Exécution des tests...${NC}"
flutter test
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Tests échoués. Veuillez les corriger avant de continuer.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Tests réussis${NC}"

# Créer le dossier de builds
mkdir -p builds/release

# Build Android
echo -e "${BLUE}🤖 Build Android en cours...${NC}"
echo -e "${YELLOW}   Génération de l'APK...${NC}"
flutter build apk --release --split-per-abi
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ APK généré avec succès${NC}"
    cp build/app/outputs/flutter-apk/*.apk builds/release/
else
    echo -e "${RED}❌ Échec de la génération de l'APK${NC}"
fi

echo -e "${YELLOW}   Génération de l'App Bundle (AAB)...${NC}"
flutter build appbundle --release
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ App Bundle généré avec succès${NC}"
    cp build/app/outputs/bundle/release/app-release.aab builds/release/
else
    echo -e "${RED}❌ Échec de la génération de l'App Bundle${NC}"
fi

# Build iOS (seulement sur macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${BLUE}🍎 Build iOS en cours...${NC}"
    flutter build ios --release --no-codesign
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Build iOS réussi${NC}"
        echo -e "${YELLOW}📝 Note: Vous devrez signer l'application dans Xcode pour la distribution${NC}"
    else
        echo -e "${RED}❌ Échec du build iOS${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Build iOS ignoré (disponible seulement sur macOS)${NC}"
fi

# Build Web
echo -e "${BLUE}🌐 Build Web en cours...${NC}"
flutter build web --release
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Build Web réussi${NC}"
    cp -r build/web builds/release/web
else
    echo -e "${RED}❌ Échec du build Web${NC}"
fi

# Résumé
echo -e "\n${GREEN}🎉 Processus de build terminé !${NC}"
echo -e "${BLUE}📁 Fichiers générés dans le dossier 'builds/release/':${NC}"
ls -la builds/release/

echo -e "\n${BLUE}📱 Étapes suivantes pour la publication :${NC}"
echo -e "${YELLOW}Android (Google Play Store):${NC}"
echo -e "   1. Utilisez app-release.aab pour la publication"
echo -e "   2. Configurez la signature de l'application"
echo -e "   3. Téléchargez sur Google Play Console"

echo -e "\n${YELLOW}iOS (App Store):${NC}"
echo -e "   1. Ouvrez le projet iOS dans Xcode"
echo -e "   2. Configurez les certificats et profils de provisioning"
echo -e "   3. Archivez et téléchargez sur App Store Connect"

echo -e "\n${YELLOW}Web:${NC}"
echo -e "   1. Déployez le dossier 'web' sur votre serveur"
echo -e "   2. Configurez HTTPS et les headers de sécurité"

echo -e "\n${GREEN}✨ Build de production terminé avec succès !${NC}" 