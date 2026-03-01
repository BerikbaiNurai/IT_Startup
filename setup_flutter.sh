#!/bin/bash

# Скрипт для установки Flutter 3.16.9 для macOS 13.0

echo "🚀 Установка Flutter 3.16.9 для macOS 13.0..."
echo ""

# Проверка наличия Homebrew
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew не установлен. Установите его с https://brew.sh"
    exit 1
fi

# Установка FVM
echo "📦 Установка FVM (Flutter Version Manager)..."
brew tap leoafarias/fvm
brew install fvm

# Установка Flutter 3.16.9
echo ""
echo "📥 Установка Flutter 3.16.9..."
fvm install 3.16.9
fvm use 3.16.9 --global

# Проверка установки
echo ""
echo "✅ Проверка установки..."
fvm flutter --version

echo ""
echo "✨ Установка завершена!"
echo ""
echo "📝 Использование:"
echo "   cd /Users/aliyanurkaldybai/development/figma_to_flutter_app"
echo "   fvm use 3.16.9"
echo "   fvm flutter pub get"
echo "   fvm flutter run"
echo ""

