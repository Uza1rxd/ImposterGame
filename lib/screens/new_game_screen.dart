import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/categories_provider.dart';
import '../providers/game_provider.dart';
import 'player_names_screen.dart';

class NewGameScreen extends StatefulWidget {
  const NewGameScreen({super.key});

  @override
  State<NewGameScreen> createState() => _NewGameScreenState();
}

class _NewGameScreenState extends State<NewGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade400,
              Colors.deepPurple.shade800,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'New Game',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: Consumer2<GameProvider, CategoriesProvider>(
                  builder: (context, gameProvider, categoriesProvider, child) {
          if (categoriesProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (categoriesProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${categoriesProvider.error}',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => categoriesProvider.loadCategories(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Players Section
                _buildSectionTitle('Players'),
                const SizedBox(height: 12),
                _buildPlayerCountSelector(gameProvider),
                const SizedBox(height: 24),

                // Imposters Section
                _buildSectionTitle('Imposters'),
                const SizedBox(height: 12),
                _buildImposterCountSelector(gameProvider),
                const SizedBox(height: 24),

                // Category Section
                _buildSectionTitle('Category'),
                const SizedBox(height: 12),
                _buildCategorySelector(gameProvider, categoriesProvider),
                const SizedBox(height: 24),

                // Game Options Section
                _buildSectionTitle('Options'),
                const SizedBox(height: 12),
                _buildGameOptions(gameProvider),
                const SizedBox(height: 40),

                // Start Game Button
                _buildStartGameButton(gameProvider, categoriesProvider),
              ],
            ),
          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildPlayerCountSelector(GameProvider gameProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Number of Players',
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: gameProvider.playerCount > 3
                    ? () => gameProvider.setPlayerCount(gameProvider.playerCount - 1)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
                color: Colors.white,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Text(
                  '${gameProvider.playerCount}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: gameProvider.playerCount < 20
                    ? () => gameProvider.setPlayerCount(gameProvider.playerCount + 1)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImposterCountSelector(GameProvider gameProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Number of Imposters',
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: gameProvider.imposterCount > 1
                    ? () => gameProvider.setImposterCount(gameProvider.imposterCount - 1)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
                color: Colors.white,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.5)),
                ),
                child: Text(
                  '${gameProvider.imposterCount}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: gameProvider.imposterCount < gameProvider.playerCount - 1
                    ? () => gameProvider.setImposterCount(gameProvider.imposterCount + 1)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(GameProvider gameProvider, CategoriesProvider categoriesProvider) {
    final selectedCategory = gameProvider.selectedCategoryId != null
        ? categoriesProvider.getCategoryById(gameProvider.selectedCategoryId!)
        : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Word Category',
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: gameProvider.selectedCategoryId,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
            ),
            hint: const Text(
              'Select a category',
              style: TextStyle(color: Colors.white70),
            ),
            dropdownColor: Colors.deepPurple.shade700,
            style: const TextStyle(color: Colors.white),
            items: categoriesProvider.categories.map((category) {
              return DropdownMenuItem<String>(
                value: category.id,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        category.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${category.words.length})',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                gameProvider.setSelectedCategory(value);
              }
            },
          ),
          if (selectedCategory != null) ...[
            const SizedBox(height: 8),
            Text(
              selectedCategory.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGameOptions(GameProvider gameProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text(
              'Shuffle Player Order',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'Randomize the order players reveal cards',
              style: TextStyle(color: Colors.white70),
            ),
            value: gameProvider.shuffleWords,
            onChanged: gameProvider.setShuffleWords,
            activeColor: Colors.white,
            contentPadding: EdgeInsets.zero,
          ),
          Divider(color: Colors.white.withOpacity(0.2)),
          SwitchListTile(
            title: const Text(
              'Similar Word Mode',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'Imposters get a similar word instead of "IMPOSTER"',
              style: TextStyle(color: Colors.white70),
            ),
            value: gameProvider.similarWordMode,
            onChanged: gameProvider.setSimilarWordMode,
            activeColor: Colors.white,
            contentPadding: EdgeInsets.zero,
          ),
          Divider(color: Colors.white.withOpacity(0.2)),
          SwitchListTile(
            title: const Text(
              'Show Hints',
              style: TextStyle(color: Colors.white54, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'Show hints instead of full words (coming soon)',
              style: TextStyle(color: Colors.white38),
            ),
            value: gameProvider.showHints,
            onChanged: null, // Disabled for now
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildStartGameButton(GameProvider gameProvider, CategoriesProvider categoriesProvider) {
    final canStart = gameProvider.selectedCategoryId != null &&
        gameProvider.playerCount >= 3 &&
        gameProvider.imposterCount < gameProvider.playerCount;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: canStart ? () => _startGame(gameProvider, categoriesProvider) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.3),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_arrow, size: 24),
            SizedBox(width: 8),
            Text(
              'Start Game',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _startGame(GameProvider gameProvider, CategoriesProvider categoriesProvider) {
    final category = categoriesProvider.getCategoryById(gameProvider.selectedCategoryId!);
    if (category != null) {
      // Navigate to player names screen first
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PlayerNamesScreen()),
      );
    }
  }
}
