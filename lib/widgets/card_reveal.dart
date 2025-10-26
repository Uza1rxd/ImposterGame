import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardReveal extends StatefulWidget {
  final String cardText;
  final bool isImposter;
  final VoidCallback? onRevealed;

  const CardReveal({
    super.key,
    required this.cardText,
    required this.isImposter,
    this.onRevealed,
  });

  @override
  State<CardReveal> createState() => _CardRevealState();
}

class _CardRevealState extends State<CardReveal>
    with SingleTickerProviderStateMixin {
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
    return GestureDetector(
      onTap: _isRevealed ? null : _revealCard,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          // Use a simple opacity-based transition instead of 3D flip to avoid text mirroring
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
                      child: _buildCardFront(),
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

  Widget _buildCardFront() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.isImposter
              ? [Colors.red.shade400, Colors.red.shade800]
              : [Colors.green.shade400, Colors.green.shade800],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.isImposter ? Icons.masks : Icons.lightbulb,
              size: 60,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.cardText,
                style: TextStyle(
                  fontSize: widget.isImposter ? 32 : 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: widget.isImposter ? 3 : 1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (!widget.isImposter) ...[
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

  void _revealCard() {
    if (_isRevealed) return;
    
    setState(() {
      _isRevealed = true;
    });
    
    // Add haptic feedback
    HapticFeedback.mediumImpact();
    
    // Start flip animation
    _flipController.forward();
    
    // Call callback when revealed
    widget.onRevealed?.call();
  }

  // Public method to reset the card
  void reset() {
    setState(() {
      _isRevealed = false;
    });
    _flipController.reset();
  }
}

