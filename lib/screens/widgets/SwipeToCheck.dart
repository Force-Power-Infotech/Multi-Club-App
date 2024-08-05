import 'package:flutter/material.dart';
import 'package:multi_club_app/bases/themes.dart';

class SwipeToCheck extends StatefulWidget {
  @override
  _SwipeToCheckState createState() => _SwipeToCheckState();
}

class _SwipeToCheckState extends State<SwipeToCheck> {
  bool _isChecked = false;
  double _dragPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragPosition += details.delta.dx;
          if (_dragPosition < 0) _dragPosition = 0;
          if (_dragPosition > 200) _dragPosition = 200;
        });
      },
      onHorizontalDragEnd: (details) {
        if (_dragPosition >= 200) {
          setState(() {
            _isChecked = true;
          });
        } else {
          setState(() {
            _dragPosition = 0.0;
            _isChecked = false;
          });
        }
      },
      child: Container(
        width: 250,
        height: 50,
        decoration: BoxDecoration(
          border:
              Border.all(color: AppThemes.brc_helpdesk_text_color, width: 2),
          borderRadius: BorderRadius.circular(25),
          color: _isChecked ? AppThemes.brc_textcolor : Colors.transparent,
        ),
        child: Stack(
          children: [
            Positioned(
              left: 10,
              top: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: _dragPosition,
                decoration: BoxDecoration(
                  color: AppThemes.brc_textcolor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            Center(
              child: Text(
                _isChecked ? "Checked!" : "Swipe to check",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _isChecked
                      ? Colors.white
                      : AppThemes.brc_textcolor.withOpacity(0.6),
                ),
              ),
            ),
            Positioned(
              left: _dragPosition,
              top: 0,
              bottom: 0,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppThemes.brc_textcolor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
