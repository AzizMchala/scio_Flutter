# Script de build de production pour Scio Flutter (Windows PowerShell)
# Ce script génère les builds pour Android et Web prêts pour la production

Write-Host "🚀 Début du processus de build de production pour Scio Flutter" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green

# Vérification des prérequis
Write-Host "📋 Vérification des prérequis..." -ForegroundColor Blue

# Vérifier Flutter
try {
    $flutterVersion = flutter --version 2>$null | Select-String "Flutter" | ForEach-Object { $_.ToString() }
    Write-Host "✅ Flutter détecté: $flutterVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Flutter n'est pas installé ou pas dans le PATH" -ForegroundColor Red
    exit 1
}

# Nettoyer le projet
Write-Host "🧹 Nettoyage du projet..." -ForegroundColor Blue
flutter clean
flutter pub get

# Analyser le code
Write-Host "🔍 Analyse du code..." -ForegroundColor Blue
$analyzeResult = flutter analyze
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erreurs d'analyse détectées. Veuillez les corriger avant de continuer." -ForegroundColor Red
    exit 1
}
Write-Host "✅ Analyse du code réussie" -ForegroundColor Green

# Exécuter les tests
Write-Host "🧪 Exécution des tests..." -ForegroundColor Blue
flutter test
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Tests échoués. Veuillez les corriger avant de continuer." -ForegroundColor Red
    exit 1
}
Write-Host "✅ Tests réussis" -ForegroundColor Green

# Créer le dossier de builds
if (!(Test-Path "builds\release")) {
    New-Item -ItemType Directory -Path "builds\release" -Force
}

# Build Android
Write-Host "🤖 Build Android en cours..." -ForegroundColor Blue
Write-Host "   Génération de l'APK..." -ForegroundColor Yellow
flutter build apk --release --split-per-abi
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ APK généré avec succès" -ForegroundColor Green
    Copy-Item "build\app\outputs\flutter-apk\*.apk" "builds\release\" -Force
} else {
    Write-Host "❌ Échec de la génération de l'APK" -ForegroundColor Red
}

Write-Host "   Génération de l'App Bundle (AAB)..." -ForegroundColor Yellow
flutter build appbundle --release
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ App Bundle généré avec succès" -ForegroundColor Green
    Copy-Item "build\app\outputs\bundle\release\app-release.aab" "builds\release\" -Force
} else {
    Write-Host "❌ Échec de la génération de l'App Bundle" -ForegroundColor Red
}

# Build Web
Write-Host "🌐 Build Web en cours..." -ForegroundColor Blue
flutter build web --release
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Build Web réussi" -ForegroundColor Green
    Copy-Item "build\web" "builds\release\" -Recurse -Force
} else {
    Write-Host "❌ Échec du build Web" -ForegroundColor Red
}

# Build Windows Desktop
Write-Host "🪟 Build Windows Desktop en cours..." -ForegroundColor Blue
flutter build windows --release
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Build Windows réussi" -ForegroundColor Green
    Copy-Item "build\windows\runner\Release" "builds\release\windows" -Recurse -Force
} else {
    Write-Host "❌ Échec du build Windows" -ForegroundColor Red
}

# Résumé
Write-Host "`n🎉 Processus de build terminé !" -ForegroundColor Green
Write-Host "📁 Fichiers générés dans le dossier 'builds\release\':" -ForegroundColor Blue
Get-ChildItem "builds\release" -Recurse | Format-Table Name, Length, LastWriteTime

Write-Host "`n📱 Étapes suivantes pour la publication :" -ForegroundColor Blue
Write-Host "Android (Google Play Store):" -ForegroundColor Yellow
Write-Host "   1. Utilisez app-release.aab pour la publication"
Write-Host "   2. Configurez la signature de l'application"
Write-Host "   3. Téléchargez sur Google Play Console"

Write-Host "`nWeb:" -ForegroundColor Yellow
Write-Host "   1. Déployez le dossier 'web' sur votre serveur"
Write-Host "   2. Configurez HTTPS et les headers de sécurité"

Write-Host "`nWindows:" -ForegroundColor Yellow
Write-Host "   1. Distribuez le dossier 'windows' avec toutes ses dépendances"
Write-Host "   2. Créez un installeur si nécessaire"

Write-Host "`n✨ Build de production terminé avec succès !" -ForegroundColor Green 