@echo off
flutter clean
flutter pub get
flutter build web --release
pause
