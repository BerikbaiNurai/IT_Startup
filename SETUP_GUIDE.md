# Figma to Flutter Conversion Guide

## Project Structure

Your Flutter project has been created with the following structure:

```
figma_to_flutter_app/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── config/
│   │   └── theme.dart               # Theme configuration (colors, typography, etc.)
│   ├── screens/
│   │   ├── home_screen.dart         # Home screen example
│   │   └── example_screen.dart      # Example screen with form
│   ├── widgets/
│   │   ├── custom_button.dart       # Reusable button widget
│   │   ├── custom_card.dart         # Reusable card widget
│   │   └── custom_text_field.dart   # Reusable text field widget
│   ├── models/                      # Data models (add your models here)
│   ├── services/                    # Business logic services
│   └── utils/                       # Utility functions
├── pubspec.yaml                     # Dependencies
└── README.md                        # Project documentation
```

## Next Steps to Convert Your Figma Design

### 1. Extract Design Tokens from Figma

From your Figma design, extract:
- **Colors**: Primary, secondary, background, text colors
- **Typography**: Font families, sizes, weights
- **Spacing**: Padding, margins, gaps
- **Border Radius**: Button, card, input field radius
- **Shadows**: Elevation values

### 2. Update Theme Configuration

Edit `lib/config/theme.dart` and update:
- Color constants (primaryColor, secondaryColor, etc.)
- Text styles (font sizes, weights, families)
- Component themes (buttons, cards, inputs)

Example:
```dart
static const Color primaryColor = Color(0xFF6200EE); // Replace with your Figma color
```

### 3. Create Screens Based on Figma

For each screen in your Figma design:
1. Create a new file in `lib/screens/`
2. Use the existing widgets or create new ones
3. Match the layout, spacing, and styling from Figma

Example:
```dart
// lib/screens/login_screen.dart
class LoginScreen extends StatelessWidget {
  // Implement your login screen based on Figma
}
```

### 4. Create Custom Widgets

If your Figma design has unique components:
1. Create reusable widgets in `lib/widgets/`
2. Follow the pattern of existing widgets (CustomButton, CustomCard, etc.)
3. Make them configurable with parameters

### 5. Set Up Navigation

Update `lib/main.dart` to add routing if you have multiple screens:
```dart
// Use go_router or Navigator for navigation
```

### 6. Add Assets

If your Figma design includes images, icons, or fonts:
1. Add them to `assets/` folder
2. Update `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/images/
  fonts:
    - family: YourFont
      fonts:
        - asset: assets/fonts/YourFont-Regular.ttf
```

## Running the App

1. Install dependencies:
```bash
cd figma_to_flutter_app
flutter pub get
```

2. Run on your device/emulator:
```bash
flutter run
```

## Tips for Figma Conversion

1. **Use Figma Dev Mode**: Open your Figma file in Dev Mode to see exact measurements, colors, and spacing
2. **Component Mapping**: Map Figma components to Flutter widgets:
   - Frame → Container/Column/Row
   - Text → Text widget
   - Button → ElevatedButton/TextButton
   - Input → TextField
   - Image → Image widget
3. **Responsive Design**: Use MediaQuery and LayoutBuilder for responsive layouts
4. **Spacing**: Use consistent spacing values (8, 16, 24, 32, etc.)
5. **Colors**: Extract hex colors from Figma and use them in your theme

## Common Flutter Widgets for Figma Elements

- **Frame/Container** → `Container`, `SizedBox`, `Padding`
- **Auto Layout** → `Row`, `Column`, `Flex`
- **Text** → `Text`, `RichText`
- **Button** → `ElevatedButton`, `TextButton`, `OutlinedButton`
- **Input** → `TextField`, `TextFormField`
- **Image** → `Image`, `Image.network`, `Image.asset`
- **Icon** → `Icon`, `IconButton`
- **Card** → `Card`, `Container` with decoration

## Need Help?

- Check Flutter documentation: https://flutter.dev/docs
- Flutter Widget catalog: https://docs.flutter.dev/ui/widgets
- Material Design: https://material.io/design

