# 🎭 Guess the Imposter Game

A Flutter-based party game where players try to identify imposters among them. One or more players receive different cards while others get the same word, creating an engaging social deduction experience.

## 🎮 How to Play

1. **Setup**: Choose the number of players (3-20) and imposters (1 to player count - 1)
2. **Category**: Select a word category (Animals, Food, Movies, Sports, Countries, Professions)
3. **Names**: Enter player names
4. **Reveal**: Players take turns revealing their cards privately
5. **Discuss**: After all cards are revealed, players discuss and vote to identify the imposters
6. **Reveal**: The game shows who the imposters were

## ✨ Features

- **Customizable Game Settings**
  - 3-20 players supported
  - Adjustable number of imposters
  - Multiple word categories with 20 words each
  - Optional player order shuffling
  - Similar word mode (imposters get different words from same category)

- **Beautiful UI**
  - Modern Material Design 3 interface
  - Gradient backgrounds and smooth animations
  - Intuitive navigation and controls
  - Responsive design for different screen sizes

- **Game Modes**
  - **Classic Mode**: Imposters get "IMPOSTER" cards
  - **Similar Word Mode**: Imposters get different words from the same category
  - **Shuffle Mode**: Randomize player reveal order

- **Persistent Settings**
  - Game preferences saved automatically
  - Quick restart with same settings
  - Settings screen for customization

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android device/emulator or iOS simulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/imposter-game.git
   cd imposter-game
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Release

**Android APK:**
```bash
flutter build apk --release
```

**iOS App:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS  
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── category.dart        # Category model
│   └── game_round.dart      # Game state model
├── providers/               # State management
│   ├── categories_provider.dart
│   └── game_provider.dart
├── screens/                 # UI screens
│   ├── new_game_screen.dart
│   ├── player_names_screen.dart
│   ├── reveal_screen.dart
│   ├── pass_screen.dart
│   ├── summary_screen.dart
│   └── settings_screen.dart
└── widgets/                 # Reusable widgets
    └── card_reveal.dart
```

## 🎯 Game Categories

The app includes 6 pre-loaded categories with 20 words each:

- **Animals**: lion, tiger, elephant, kangaroo, panda, etc.
- **Food & Drinks**: pizza, sushi, burger, pasta, taco, etc.
- **Movies**: action, comedy, drama, horror, romance, etc.
- **Sports**: football, basketball, tennis, soccer, baseball, etc.
- **Countries**: USA, Canada, Mexico, Brazil, France, etc.
- **Professions**: doctor, teacher, engineer, artist, chef, etc.

## 🔧 Dependencies

- **flutter**: Core Flutter framework
- **provider**: State management
- **shared_preferences**: Local storage for settings
- **flutter_staggered_animations**: Smooth animations
- **cupertino_icons**: iOS-style icons

## 🎨 Customization

### Adding New Categories

1. Edit `assets/categories.json`
2. Add your category with the following structure:
   ```json
   {
     "id": "your_category",
     "title": "Your Category",
     "description": "Description of your category",
     "words": ["word1", "word2", "word3", ...]
   }
   ```

### Modifying Game Rules

The game logic can be customized in:
- `lib/models/game_round.dart` - Core game mechanics
- `lib/providers/game_provider.dart` - Game state management

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by popular social deduction games
- Built with Flutter and Material Design
- Icons by Material Design Icons


**Have fun playing! 🎉**

*Perfect for parties, family gatherings, and social events where you want to add some mystery and excitement to your game night.*
