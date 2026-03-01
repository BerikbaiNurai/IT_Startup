# Установка старой версии Flutter для macOS 13.0

## Решение без обновления macOS

Вы можете использовать **Flutter 3.16.9** - последнюю версию, которая поддерживает macOS 13.0 (Ventura).

---

## Способ 1: Использование FVM (Рекомендуется) ⭐

FVM (Flutter Version Manager) позволяет легко переключаться между версиями Flutter.

### Шаг 1: Установите FVM

```bash
brew tap leoafarias/fvm
brew install fvm
```

### Шаг 2: Установите Flutter 3.16.9

```bash
fvm install 3.16.9
fvm use 3.16.9 --global
```

### Шаг 3: Используйте FVM в вашем проекте

```bash
cd /Users/aliyanurkaldybai/development/figma_to_flutter_app
fvm use 3.16.9
fvm flutter pub get
fvm flutter run
```

**Примечание:** Вместо `flutter` используйте `fvm flutter` для всех команд.

---

## Способ 2: Ручная установка старой версии Flutter

### Шаг 1: Скачайте Flutter 3.16.9

```bash
cd ~/development
git clone -b stable https://github.com/flutter/flutter.git flutter_3.16
cd flutter_3.16
git checkout 3.16.9
```

### Шаг 2: Добавьте в PATH

Откройте файл `~/.zshrc` и добавьте в конец:

```bash
export PATH="$HOME/development/flutter_3.16/bin:$PATH"
```

Затем выполните:

```bash
source ~/.zshrc
```

### Шаг 3: Проверьте установку

```bash
flutter --version
```

Должно показать Flutter 3.16.9

### Шаг 4: Запустите проект

```bash
cd /Users/aliyanurkaldybai/development/figma_to_flutter_app
flutter pub get
flutter run
```

---

## Способ 3: Использование существующего Flutter SDK

Если у вас уже есть Flutter SDK в `/Users/aliyanurkaldybai/development/flutter/`, можно попробовать использовать его напрямую:

```bash
export PATH="/Users/aliyanurkaldybai/development/flutter/bin:$PATH"
cd /Users/aliyanurkaldybai/development/figma_to_flutter_app
flutter --version
flutter pub get
flutter run
```

---

## Обновление зависимостей для Flutter 3.16.x

Если возникнут проблемы с зависимостями, может потребоваться обновить `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  go_router: ^12.0.0  # Более старая версия для совместимости
  provider: ^6.1.1
```

---

## Проверка после установки

```bash
# Проверьте версию Flutter
flutter --version

# Проверьте доступные устройства
flutter devices

# Установите зависимости
flutter pub get

# Запустите приложение
flutter run
```

---

## Важные замечания

1. **Flutter 3.16.9** - последняя версия, поддерживающая macOS 13.0
2. Некоторые новые функции Flutter могут быть недоступны
3. Рекомендуется обновить macOS до 14.0+ для использования последних версий Flutter
4. При использовании FVM всегда используйте `fvm flutter` вместо `flutter`

---

## Если ничего не помогает

Попробуйте запустить только на веб-платформе (может обойти некоторые проверки):

```bash
flutter run -d chrome
```

