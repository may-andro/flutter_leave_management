import 'package:flutter/material.dart';
import 'dart:math';

class RevealProgressButtonPainter extends CustomPainter {

  RevealProgressButtonPainter(this._fraction, this._screenSize);

  Size _screenSize;

  double _fraction;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.fill;

    var finalRadius = sqrt(pow(_screenSize.width / 2, 2) +
        pow(_screenSize.height - 32.0 - 48.0, 2));

    var radius = 24.0 + finalRadius * _fraction;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
  }

  @override
  bool shouldRepaint(RevealProgressButtonPainter oldDelegate) {
    return oldDelegate._fraction != _fraction;
  }
}