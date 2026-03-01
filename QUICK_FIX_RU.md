# Быстрое решение без обновления macOS

## ✅ Простое решение за 3 шага

### Шаг 1: Установите FVM и Flutter 3.16.9

Выполните в терминале:

```bash
brew tap leoafarias/fvm
brew install fvm
fvm install 3.16.9
fvm use 3.16.9 --global
```

**Или используйте автоматический скрипт:**

```bash
cd /Users/aliyanurkaldybai/development/figma_to_flutter_app
./setup_flutter.sh
```

### Шаг 2: Перейдите в проект и используйте FVM

```bash
cd /Users/aliyanurkaldybai/development/figma_to_flutter_app
fvm use 3.16.9
```

### Шаг 3: Установите зависимости и запустите

```bash
fvm flutter pub get
fvm flutter devices
fvm flutter run
```

---

## ⚠️ Важно!

**Всегда используйте `fvm flutter` вместо `flutter`** для команд в этом проекте.

Например:
- ✅ `fvm flutter pub get`
- ✅ `fvm flutter run`
- ✅ `fvm flutter build apk`
- ❌ `flutter pub get` (не будет работать)

---

## Альтернатива: Использовать существующий Flutter SDK

Если у вас уже есть Flutter в `/Users/aliyanurkaldybai/development/flutter/`, попробуйте:

```bash
export PATH="/Users/aliyanurkaldybai/development/flutter/bin:$PATH"
cd /Users/aliyanurkaldybai/development/figma_to_flutter_app
flutter pub get
flutter run
```

Но это может не сработать, если этот Flutter тоже требует macOS 14.0+.

---

## Проверка

После установки проверьте:

```bash
fvm flutter --version
```

Должно показать: `Flutter 3.16.9`

---

## Готово! 🎉

Теперь вы можете разрабатывать Flutter приложения на macOS 13.0 без обновления системы.

