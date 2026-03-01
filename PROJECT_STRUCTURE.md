# TrustRent - Структура проекта

## Архитектура: Clean Architecture + MVVM (Provider)

```
lib/
├── main.dart                          # Точка входа приложения
│
├── core/                              # Ядро приложения
│   ├── constants/
│   │   └── app_constants.dart        # Константы приложения
│   ├── theme/
│   │   └── app_theme.dart            # Тема Material 3
│   └── utils/
│       └── format_utils.dart         # Утилиты форматирования
│
├── data/                              # Слой данных
│   ├── models/
│   │   ├── product.dart              # Модель продукта
│   │   ├── user.dart                 # Модель пользователя
│   │   ├── cart_item.dart            # Модель элемента корзины
│   │   └── order.dart                # Модель заказа
│   └── mock_data.dart                # Моковые данные
│
├── viewmodels/                        # ViewModels (State Management)
│   ├── auth_provider.dart            # Провайдер авторизации
│   ├── product_provider.dart         # Провайдер продуктов
│   ├── cart_provider.dart            # Провайдер корзины
│   └── order_provider.dart           # Провайдер заказов
│
├── views/                             # Экраны (Views)
│   ├── main_screen.dart              # Главный экран с bottom navigation
│   │
│   ├── home/                          # Главная страница
│   │   └── home_screen.dart
│   │
│   ├── search/                       # Поиск
│   │   └── search_screen.dart
│   │
│   ├── catalog/                      # Каталог
│   │   └── catalog_screen.dart
│   │
│   ├── product_detail/                # Детали продукта
│   │   └── product_detail_screen.dart
│   │
│   ├── cart/                         # Корзина
│   │   └── cart_screen.dart
│   │
│   ├── checkout/                     # Оформление заказа
│   │   └── checkout_screen.dart
│   │
│   ├── payment/                       # Оплата
│   │   └── payment_screen.dart
│   │
│   ├── order_success/                 # Успешный заказ
│   │   └── order_success_screen.dart
│   │
│   ├── orders/                       # История заказов
│   │   └── orders_screen.dart
│   │
│   ├── profile/                       # Профиль
│   │   └── profile_screen.dart
│   │
│   ├── settings/                      # Настройки
│   │   └── settings_screen.dart
│   │
│   └── auth/                         # Авторизация
│       └── auth_screen.dart
│
└── widgets/                           # Переиспользуемые виджеты
    ├── product_card.dart              # Карточка продукта
    ├── category_chip.dart            # Чип категории
    ├── custom_button.dart            # Кастомная кнопка
    ├── custom_card.dart              # Кастомная карточка
    └── custom_text_field.dart        # Кастомное поле ввода
```

## Особенности реализации

### State Management
- **Provider** для управления состоянием
- Разделение на логические провайдеры (Auth, Product, Cart, Order)

### Архитектура
- **Clean Architecture** - разделение на слои (data, viewmodels, views)
- **MVVM** - Model-View-ViewModel паттерн
- **Null Safety** - все модели используют null safety

### UI/UX
- **Material 3** дизайн
- **Bottom Navigation Bar** с 4 вкладками
- **Responsive** layout
- **Hero animations** для переходов
- **Rounded corners** (16px для карточек)
- **Soft shadows** для глубины

### Функциональность
- ✅ Поиск товаров
- ✅ Фильтрация по категориям
- ✅ Корзина с управлением количеством
- ✅ Оформление заказа
- ✅ Выбор дат аренды
- ✅ Система депозитов
- ✅ История заказов
- ✅ Избранное
- ✅ Профиль пользователя

## Запуск

```bash
cd /Users/aliyanurkaldybai/development/figma_to_flutter_app
fvm flutter pub get
fvm flutter run -d chrome  # или -d macos
```

## Зависимости

- `provider` - State management
- `intl` - Форматирование дат и чисел
- `flutter` - Flutter SDK

