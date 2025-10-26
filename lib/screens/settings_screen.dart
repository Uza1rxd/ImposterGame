import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Game Defaults Section
              _buildSectionHeader('Game Defaults'),
              const SizedBox(height: 8),
              
              _buildSettingsTile(
                icon: Icons.group,
                title: 'Default Players',
                subtitle: '${gameProvider.playerCount} players',
                onTap: () => _showPlayerCountDialog(context, gameProvider),
              ),
              
              _buildSettingsTile(
                icon: Icons.masks,
                title: 'Default Imposters',
                subtitle: '${gameProvider.imposterCount} imposter(s)',
                onTap: () => _showImposterCountDialog(context, gameProvider),
              ),
              
              const SizedBox(height: 24),
              
              // Game Options Section
              _buildSectionHeader('Game Options'),
              const SizedBox(height: 8),
              
              SwitchListTile(
                secondary: const Icon(Icons.shuffle, color: Colors.deepPurple),
                title: const Text('Shuffle Player Order'),
                subtitle: const Text('Randomize the order players reveal cards'),
                value: gameProvider.shuffleWords,
                onChanged: gameProvider.setShuffleWords,
                activeColor: Colors.deepPurple,
              ),
              
              SwitchListTile(
                secondary: const Icon(Icons.help_outline, color: Colors.grey),
                title: const Text('Show Hints'),
                subtitle: const Text('Show hints instead of full words (coming soon)'),
                value: gameProvider.showHints,
                onChanged: null, // Disabled for now
              ),
              
              const SizedBox(height: 24),
              
              // About Section
              _buildSectionHeader('About'),
              const SizedBox(height: 8),
              
              _buildSettingsTile(
                icon: Icons.info,
                title: 'App Version',
                subtitle: '1.0.0',
                onTap: () => _showAboutDialog(context),
              ),
              
              _buildSettingsTile(
                icon: Icons.help,
                title: 'How to Play',
                subtitle: 'Learn the game rules',
                onTap: () => _showHowToPlayDialog(context),
              ),
              
              _buildSettingsTile(
                icon: Icons.feedback,
                title: 'Feedback',
                subtitle: 'Send us your thoughts',
                onTap: () => _showFeedbackDialog(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showPlayerCountDialog(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default Player Count'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Choose the default number of players for new games:'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: gameProvider.playerCount > 3
                          ? () {
                              gameProvider.setPlayerCount(gameProvider.playerCount - 1);
                              setState(() {});
                            }
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${gameProvider.playerCount}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: gameProvider.playerCount < 20
                          ? () {
                              gameProvider.setPlayerCount(gameProvider.playerCount + 1);
                              setState(() {});
                            }
                          : null,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Range: 3-20 players',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showImposterCountDialog(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default Imposter Count'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Choose the default number of imposters for new games:'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: gameProvider.imposterCount > 1
                          ? () {
                              gameProvider.setImposterCount(gameProvider.imposterCount - 1);
                              setState(() {});
                            }
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${gameProvider.imposterCount}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: gameProvider.imposterCount < gameProvider.playerCount - 1
                          ? () {
                              gameProvider.setImposterCount(gameProvider.imposterCount + 1);
                              setState(() {});
                            }
                          : null,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Range: 1-${gameProvider.playerCount - 1} imposters',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Guess the Imposter'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('A fun pass-and-reveal party game for friends and family.'),
            SizedBox(height: 16),
            Text('Created with Flutter'),
            SizedBox(height: 8),
            Text('© 2024 Imposter Game'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHowToPlayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Play'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🎯 Objective',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('Find the imposter(s) among your group!'),
              SizedBox(height: 16),
              
              Text(
                '📱 Setup',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('1. Choose number of players (3-20)\n2. Set number of imposters\n3. Select a word category\n4. Start the game'),
              SizedBox(height: 16),
              
              Text(
                '🔄 Gameplay',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('1. Pass the phone to each player\n2. Each player taps to reveal their card\n3. Regular players see the secret word\n4. Imposters see "IMPOSTER"\n5. After everyone has seen their card, discuss and vote!'),
              SizedBox(height: 16),
              
              Text(
                '🏆 Winning',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('• Regular players win by identifying all imposters\n• Imposters win by staying hidden'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Feedback'),
        content: const Text(
          'We\'d love to hear your thoughts about the game!\n\n'
          'Please share your feedback, suggestions, or report any issues you encounter.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}


