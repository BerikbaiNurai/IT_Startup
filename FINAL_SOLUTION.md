# Финальное решение для macOS 13.0

## Проблема
Даже Flutter 3.16.9 требует macOS 14.0+. Нужна более старая версия.

## Решение: Flutter 3.10.6 или 3.12.x

Эти версии должны работать с macOS 13.0 (Ventura).

### Шаг 1: Установите Flutter 3.10.6

```bash
fvm install 3.10.6
fvm use 3.10.6
```

### Шаг 2: Проверьте версию

```bash
fvm flutter --version
```

Если все еще показывает ошибку macOS, попробуйте еще более старую версию:

```bash
fvm install 3.7.12
fvm use 3.7.12
fvm flutter --version
```

### Шаг 3: Установите зависимости

```bash
cd /Users/aliyanurkaldybai/development/figma_to_flutter_app
fvm flutter pub get
```

### Шаг 4: Запустите приложение

```bash
fvm flutter run
```

---

## Альтернативное решение: Использовать существующий Flutter SDK

Если у вас уже есть Flutter SDK в `/Users/aliyanurkaldybai/development/flutter/`, попробуйте использовать его напрямую:

```bash
# Проверьте версию существующего Flutter
/Users/aliyanurkaldybai/development/flutter/bin/flutter --version
```

Если версия старая (например, 3.7.x или 3.10.x), используйте ее:

```bash
export PATH="/Users/aliyanurkaldybai/development/flutter/bin:$PATH"
cd /Users/aliyanurkaldybai/development/figma_to_flutter_app
flutter pub get
flutter run
```

---

## Если ничего не работает

### Вариант 1: Использовать Docker (если установлен)

Можно запустить Flutter в Docker контейнере с более новой версией macOS.

### Вариант 2: Использовать GitHub Codespaces или другую облачную среду

Разрабатывайте в облаке, где доступна более новая версия macOS.

### Вариант 3: Обновить macOS (если возможно)

Если ваш Mac поддерживает macOS 14.0+, обновление - самое простое решение.

---

## Проверка совместимости версий

| Flutter Version | Dart SDK | macOS Minimum |
|----------------|----------|---------------|
| 3.16.x | 3.2.x | macOS 14.0+ |
| 3.13.x | 3.1.x | macOS 14.0+ |
| 3.12.x | 3.0.x | macOS 13.0+ ✅ |
| 3.10.x | 2.19.x | macOS 13.0+ ✅ |
| 3.7.x | 2.18.x | macOS 13.0+ ✅ |

**Рекомендуется:** Flutter 3.10.6 или 3.12.5 для macOS 13.0

