import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/themes.dart';

class TermAndCondition extends StatefulWidget {
  const TermAndCondition({Key? key}) : super(key: key);

  @override
  _TermAndConditionState createState() => _TermAndConditionState();
}

class _TermAndConditionState extends State<TermAndCondition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: Offset(0, 0.5), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.getBackground(),
        title: const Text(
          'Term & Condition',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppThemes.brc_textcolor,
          ),
        ),
      ),
      body: Container(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _opacityAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Text(
                      "Coming soon...",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppThemes.brc_spotsbooking_hint_text,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
