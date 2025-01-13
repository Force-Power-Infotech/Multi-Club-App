import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/themes.dart';

class PulsatingButton extends StatefulWidget {
  final VoidCallback onPressed;

  const PulsatingButton({super.key, required this.onPressed});

  @override
  _PulsatingButtonState createState() => _PulsatingButtonState();
}

class _PulsatingButtonState extends State<PulsatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  bool _showText = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Slower transition
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut, // Smoother transition
      ),
    );
    _colorAnimation = ColorTween(
      begin: AppThemes.getBackground(),
      end: Colors.green,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut, // Smoother transition
      ),
    );

    // Add a listener to the animation controller to toggle between showing text and icon
    _animationController.addListener(() {
      setState(() {
        _showText = _animationController.value <
            0.5; // Show text when animation is less than 50%
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              backgroundColor: WidgetStateProperty.all(_colorAnimation.value),
              elevation: WidgetStateProperty.all(0),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
            child: Ink(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: _showText
                  ? SizedBox(
                      width: 80, // Adjust width as needed
                      height: 48, // Adjust height as needed
                      child: const Center(
                        child: Text(
                          'Wish Them',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 80, // Adjust width as needed
                      height: 48, // Adjust height as needed
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/wpicon.webp', // Replace 'your_image.png' with your image asset path
                          // color: Colors.white,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
