import 'dart:math';

class GameRound {
  final int players;
  final int imposters;
  final String categoryId;
  final String categoryTitle;
  final List<String> assignedCards;
  final List<int> revealOrder;
  final List<String> playerNames;
  final List<bool> imposterFlags;
  int currentIndex;
  final bool shuffleWords;
  final bool showHints;
  final bool similarWordMode;
  final String? secretWord;

  GameRound({
    required this.players,
    required this.imposters,
    required this.categoryId,
    required this.categoryTitle,
    required this.assignedCards,
    required this.revealOrder,
    required this.playerNames,
    required this.imposterFlags,
    this.currentIndex = 0,
    this.shuffleWords = true,
    this.showHints = false,
    this.similarWordMode = false,
    this.secretWord,
  });

  factory GameRound.create({
    required int players,
    required int imposters,
    required String categoryId,
    required String categoryTitle,
    required List<String> words,
    required List<String> playerNames,
    bool shuffleWords = true,
    bool showHints = false,
    bool similarWordMode = false,
  }) {
    // Use a time-based seed for better randomization
    final random = Random(DateTime.now().millisecondsSinceEpoch);
    
    // Select a random word from the category
    final secretWord = words[random.nextInt(words.length)];
    
    // Create list of all possible imposter combinations and pick randomly
    final allPlayerIndices = List.generate(players, (index) => index);
    allPlayerIndices.shuffle(random);
    
    // Assign imposter indices from shuffled list
    final imposterIndices = allPlayerIndices.take(imposters).toSet();
    
    // Create imposter flags
    final imposterFlags = List.generate(players, (index) => imposterIndices.contains(index));
    
    // Create assigned cards
    final assignedCards = List.generate(players, (index) {
      if (imposterIndices.contains(index)) {
        if (similarWordMode) {
          // Get a different word from the same category for imposters
          final availableWords = words.where((word) => word != secretWord).toList();
          if (availableWords.isNotEmpty) {
            return availableWords[random.nextInt(availableWords.length)];
          }
          return 'IMPOSTER'; // Fallback if no other words available
        } else {
          return 'IMPOSTER';
        }
      } else {
        return secretWord;
      }
    });
    
    // Create reveal order (can be shuffled or sequential)
    final revealOrder = List.generate(players, (index) => index);
    if (shuffleWords) {
      revealOrder.shuffle(random);
    }
    
    return GameRound(
      players: players,
      imposters: imposters,
      categoryId: categoryId,
      categoryTitle: categoryTitle,
      assignedCards: assignedCards,
      revealOrder: revealOrder,
      playerNames: playerNames,
      imposterFlags: imposterFlags,
      shuffleWords: shuffleWords,
      showHints: showHints,
      similarWordMode: similarWordMode,
      secretWord: secretWord,
    );
  }

  bool get isComplete => currentIndex >= players;
  
  int get currentPlayerIndex => isComplete ? -1 : revealOrder[currentIndex];
  
  String get currentPlayerCard => isComplete ? '' : assignedCards[currentPlayerIndex];
  
  String get currentPlayerName => isComplete ? '' : playerNames[currentPlayerIndex];
  
  bool get currentPlayerIsImposter => isComplete ? false : imposterFlags[currentPlayerIndex];
  
  List<String> get imposterNames {
    final names = <String>[];
    for (int i = 0; i < players; i++) {
      if (imposterFlags[i]) {
        names.add(playerNames[i]);
      }
    }
    return names;
  }
  
  void nextPlayer() {
    if (!isComplete) {
      currentIndex++;
    }
  }
  
  GameRound copyWith({
    int? currentIndex,
  }) {
    return GameRound(
      players: players,
      imposters: imposters,
      categoryId: categoryId,
      categoryTitle: categoryTitle,
      assignedCards: assignedCards,
      revealOrder: revealOrder,
      playerNames: playerNames,
      imposterFlags: imposterFlags,
      currentIndex: currentIndex ?? this.currentIndex,
      shuffleWords: shuffleWords,
      showHints: showHints,
      similarWordMode: similarWordMode,
      secretWord: secretWord,
    );
  }
}

