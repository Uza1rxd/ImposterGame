import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'pass_screen.dart';
import 'summary_screen.dart';

class RevealScreen extends StatefulWidget {
  const RevealScreen({super.key});

  @override
  State<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends State<RevealScreen>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isRevealed = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          final game = gameProvider.currentGame;
          
          if (game == null) {
            return const Center(
              child: Text('No active game'),
            );
          }

          if (game.isComplete) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SummaryScreen()),
              );
            });
            return const Center(child: CircularProgressIndicator());
          }

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.indigo.shade400,
                  Colors.indigo.shade800,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Progress indicator
                    _buildProgressIndicator(game),
                    const SizedBox(height: 40),
                    
                    // Player instruction
                    _buildPlayerInstruction(game),
                    const SizedBox(height: 40),
                    
                    // Card area
                    Expanded(
                      child: Center(
                        child: _buildCard(game),
                      ),
                    ),
                    
                    // Action button
                    _buildActionButton(gameProvider, game),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressIndicator(game) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Player ${game.currentIndex + 1} of ${game.players}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPlayerInstruction(game) {
    return Column(
      children: [
        Text(
          _isRevealed 
              ? '${game.currentPlayerName}\'s card is revealed!'
              : 'Hand the phone to ${game.currentPlayerName}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        if (!_isRevealed)
          const Text(
            'Tap the card below to reveal your role',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  Widget _buildCard(game) {
    return GestureDetector(
      onTap: _isRevealed ? null : _revealCard,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          return Container(
            width: 280,
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Back of card
                  AnimatedOpacity(
                    opacity: _isRevealed ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_flipAnimation.value * 1.57079), // 90 degrees max
                      child: _buildCardBack(),
                    ),
                  ),
                  // Front of card
                  AnimatedOpacity(
                    opacity: _isRevealed ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY((_flipAnimation.value - 1.0) * 1.57079), // Start from -90 degrees
                      child: _buildCardFront(game),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepPurple.shade300,
            Colors.deepPurple.shade700,
          ],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.touch_app,
              size: 60,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              'TAP TO\nREVEAL',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFront(game) {
    final isImposter = game.currentPlayerIsImposter;
    final cardText = game.currentPlayerCard;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isImposter
              ? [Colors.red.shade400, Colors.red.shade800]
              : [Colors.green.shade400, Colors.green.shade800],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isImposter ? Icons.masks : Icons.lightbulb,
              size: 60,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                cardText,
                style: TextStyle(
                  fontSize: isImposter ? 32 : 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: isImposter ? 3 : 1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (!isImposter) ...[
              const SizedBox(height: 12),
              const Text(
                'This is your secret word',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(GameProvider gameProvider, game) {
    if (!_isRevealed) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => _nextPlayer(gameProvider),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.indigo.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Done - Pass to Next Player',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 24),
          ],
        ),
      ),
    );
  }

  void _revealCard() {
    if (_isRevealed) return;
    
    setState(() {
      _isRevealed = true;
    });
    
    // Add haptic feedback
    HapticFeedback.mediumImpact();
    
    // Start flip animation
    _flipController.forward();
  }

  void _nextPlayer(GameProvider gameProvider) {
    // Reset for next player
    setState(() {
      _isRevealed = false;
    });
    _flipController.reset();
    
    // Navigate to pass screen first
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassScreen(
          onContinue: () {
            Navigator.pop(context); // Close pass screen
            gameProvider.nextPlayer(); // Advance to next player
          },
        ),
      ),
    );
  }
}

