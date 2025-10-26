import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_round.dart';
import '../models/category.dart' as models;

class GameProvider extends ChangeNotifier {
  GameRound? _currentGame;
  
  // Game settings
  int _playerCount = 5;
  int _imposterCount = 1;
  String? _selectedCategoryId;
  bool _shuffleWords = true;
  bool _showHints = false;
  bool _similarWordMode = false;

  // Getters
  GameRound? get currentGame => _currentGame;
  int get playerCount => _playerCount;
  int get imposterCount => _imposterCount;
  String? get selectedCategoryId => _selectedCategoryId;
  bool get shuffleWords => _shuffleWords;
  bool get showHints => _showHints;
  bool get similarWordMode => _similarWordMode;
  
  bool get hasActiveGame => _currentGame != null;
  bool get isGameComplete => _currentGame?.isComplete ?? false;

  // Initialize provider and load settings
  Future<void> initialize() async {
    await _loadSettings();
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _playerCount = prefs.getInt('player_count') ?? 5;
      _imposterCount = prefs.getInt('imposter_count') ?? 1;
      _selectedCategoryId = prefs.getString('selected_category_id');
      _shuffleWords = prefs.getBool('shuffle_words') ?? true;
      _showHints = prefs.getBool('show_hints') ?? false;
      _similarWordMode = prefs.getBool('similar_word_mode') ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('player_count', _playerCount);
      await prefs.setInt('imposter_count', _imposterCount);
      if (_selectedCategoryId != null) {
        await prefs.setString('selected_category_id', _selectedCategoryId!);
      }
      await prefs.setBool('shuffle_words', _shuffleWords);
      await prefs.setBool('show_hints', _showHints);
      await prefs.setBool('similar_word_mode', _similarWordMode);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  // Update game settings
  void setPlayerCount(int count) {
    if (count >= 3 && count <= 20) {
      _playerCount = count;
      // Ensure imposter count doesn't exceed player count - 1
      if (_imposterCount >= count) {
        _imposterCount = count - 1;
      }
      _saveSettings();
      notifyListeners();
    }
  }

  void setImposterCount(int count) {
    if (count >= 1 && count < _playerCount) {
      _imposterCount = count;
      _saveSettings();
      notifyListeners();
    }
  }

  void setSelectedCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    _saveSettings();
    notifyListeners();
  }

  void setShuffleWords(bool shuffle) {
    _shuffleWords = shuffle;
    _saveSettings();
    notifyListeners();
  }

  void setShowHints(bool hints) {
    _showHints = hints;
    _saveSettings();
    notifyListeners();
  }

  void setSimilarWordMode(bool similarMode) {
    _similarWordMode = similarMode;
    _saveSettings();
    notifyListeners();
  }

  // Start a new game
  void startNewGame(models.Category category, List<String> playerNames) {
    _currentGame = GameRound.create(
      players: _playerCount,
      imposters: _imposterCount,
      categoryId: category.id,
      categoryTitle: category.title,
      words: category.words,
      playerNames: playerNames,
      shuffleWords: _shuffleWords,
      showHints: _showHints,
      similarWordMode: _similarWordMode,
    );
    notifyListeners();
  }

  // Advance to next player
  void nextPlayer() {
    if (_currentGame != null && !_currentGame!.isComplete) {
      _currentGame!.nextPlayer();
      notifyListeners();
    }
  }

  // End current game
  void endGame() {
    _currentGame = null;
    notifyListeners();
  }

  // Reset to specific player (for testing/debugging)
  void resetToPlayer(int playerIndex) {
    if (_currentGame != null && playerIndex >= 0 && playerIndex < _currentGame!.players) {
      _currentGame = _currentGame!.copyWith(currentIndex: playerIndex);
      notifyListeners();
    }
  }
}
