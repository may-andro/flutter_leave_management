import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeaderPainter extends CustomPainter {
  HeaderPainter(this.animationValue, this.firstStarOffset);

  final double animationValue;
  final Offset firstStarOffset;

  @override
  paint(Canvas canvas, Size size) {
    DateTime now = DateTime.now();

    DateFormat dateFormat = DateFormat.Hm();

    DateTime morningTime = dateFormat.parse("06:30");
    morningTime = DateTime(
        now.year, now.month, now.day, morningTime.hour, morningTime.minute);

    DateTime eveningTime = dateFormat.parse("18:00");
    eveningTime = DateTime(
        now.year, now.month, now.day, eveningTime.hour, eveningTime.minute);

    _drawSky(canvas, size);

    _drawArc(canvas, size, 0.0, 30.0, 50.0, 1.0);
    _drawArc(canvas, size, 50.0, 145.0, 145.0, 0.35);
    _drawArc(canvas, size, 145.0, 80.0, 145.0, 0.35);
    _drawArc(canvas, size, 80.0, 50.0, 95.0, 0.35);

    _drawTree(canvas, size, -7.5, 35.0, 70.0);
    _drawTree(canvas, size, 12.0, 35.0, 56.5);
    _drawTree(canvas, size, 32.0, 40.0, 96.5);
    _drawTree(canvas, size, 57.0, 30.0, 55.0);
    _drawTree(canvas, size, size.width - 50.0, 17.5, 30.0);
    _drawTree(canvas, size, size.width - 35.0, 25.0, 60.0);
    _drawTree(canvas, size, size.width - 10.0, 10.0, 20.0);

    if (now.isAfter(morningTime) && now.isBefore(eveningTime)) {
      _drawSun(canvas, Colors.yellow);
    } else {
      _drawSun(canvas, Colors.white);

      _drawStar(canvas, 30.0, 35.0, 2.0, 0.35);
      _drawStar(canvas, 25.0, 150.0, 2.5, 0.6);
      _drawStar(canvas, 180.0, 75.0, 2.5, 0.9);
      _drawStar(canvas, 265.0, 80.0, 1.5, 0.4);
      _drawStar(canvas, 165.0, 150.0, 2.5, 0.75);
      _drawStar(canvas, 270.0, 155.0, 2.0, 0.35);
      _drawStar(canvas, 70.0, 215.0, 2.0, 0.35);
      _drawStar(canvas, 210.0, 233.0, 2.0, 0.35);

      var dx = firstStarOffset.dx;
      var dy = firstStarOffset.dy;

      _drawFallingStar(canvas, dx, dy, 100.0, 1.8, -35.0, 1.0);
      _drawFallingStar(canvas, dx + 140.0, dy - 30.0, 50.0, 1.5, -35.0, 0.3);
      _drawFallingStar(canvas, dx + 190.0, dy + 45.0, 50.0, 1.5, -35.0, 1.0);
    }
  }

  _getSkyColors() {
    DateTime now = DateTime.now();
    int timeAsMins = now.hour * 60 + now.minute;
    var lerpValue =
        (timeAsMins <= 720) ? timeAsMins / 720 : (2 - timeAsMins / 720);
    var topSkyColor = Color.lerp(
        Colors.indigo.shade700, Colors.lightBlueAccent.shade700, lerpValue);
    var bottomSkyColor = Color.lerp(
            Colors.indigo.shade100, Colors.lightBlueAccent.shade100, lerpValue)
        .withOpacity(0.8);
    return [topSkyColor, bottomSkyColor];
  }

  _drawSky(Canvas canvas, Size size) {
    var skyGradient = LinearGradient(
      colors: _getSkyColors(),
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    canvas.drawRect(
      Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      Paint()
        ..shader = skyGradient.createShader(
          Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        ),
    );
  }

  _drawArc(Canvas canvas, Size size, double pathLineToHeight,
      double endPointHeight, double controlPointHeight, double opacity) {
    var path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height - pathLineToHeight);

    var endPoint = Offset(0.0, size.height - endPointHeight);
    var controlPoint = Offset(size.width / 2, size.height - controlPointHeight);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.close();

    canvas.drawPath(
      path,
      Paint()..color = Colors.lightGreen.withOpacity(opacity),
    );
  }

  _drawTree(Canvas canvas, Size size, double dx, double width, double height) {
    var path = Path();
    path.addPolygon(
      [
        Offset(dx, size.height),
        Offset(dx + width, size.height),
        Offset(dx + width / 2, size.height - height),
      ],
      true,
    );
    path.close();

    canvas.drawPath(path, Paint()..color = Colors.green);
  }

  _drawStar(
      Canvas canvas, double dx, double dy, double radius, double opacity) {
    var starGradientRadius = radius * 1.8;
    var startCenter = Offset(dx, dy);

    var circleGradientShader = RadialGradient(colors: [
      Colors.white.withOpacity(opacity),
      Colors.white.withOpacity(0.0)
    ]).createShader(
      Rect.fromCircle(center: startCenter, radius: starGradientRadius),
    );

    canvas.drawCircle(startCenter, starGradientRadius,
        Paint()..shader = circleGradientShader);
    canvas.drawCircle(
      startCenter,
      radius,
      Paint()..color = Colors.white.withOpacity(opacity),
    );
  }

  _drawFallingStar(Canvas canvas, double dx, double dy, double h, double r,
      num alpha, double opacity) {
    var fallingStarGradient = LinearGradient(
      colors: [
        Colors.white.withOpacity(opacity),
        Colors.white.withOpacity(0.0),
      ],
    );

    var path = Path();

    var rad = alpha * pi / 180;
    var cx = dx + h * cos(rad);
    var cy = dy + h * sin(rad);
    var xDiff = r * cos(rad);
    var yDiff = r * sin(rad);

    path.addPolygon(
      [
        Offset(dx - xDiff, dy + yDiff),
        Offset(dx + xDiff, dy - yDiff),
        Offset(cx, cy),
      ],
      true,
    );
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = fallingStarGradient.createShader(
          Rect.fromLTRB(dx, dy, cx, cy),
        ),
    );
    canvas.drawCircle(
        Offset(dx, dy), r, Paint()..color = Colors.white.withOpacity(opacity));
    //_drawStar(canvas, dx, dy, r, opacity);
  }

  _drawSun(Canvas canvas, Color color) {
    var sunCenter = Offset(60.0, 90.0);

    var sunInnerGradientRadius = 35.0;
    var circleInnerGradientShader =
        RadialGradient(colors: [color.withOpacity(0.5), color.withOpacity(0.0)])
            .createShader(
      Rect.fromCircle(center: sunCenter, radius: sunInnerGradientRadius),
    );
    canvas.drawCircle(sunCenter, sunInnerGradientRadius,
        Paint()..shader = circleInnerGradientShader);

    var sunOuternGradientRadius = 50.0;
    var circleOuternGradientShader = RadialGradient(
        colors: [color.withOpacity(0.35), color.withOpacity(0.0)]).createShader(
      Rect.fromCircle(center: sunCenter, radius: sunOuternGradientRadius),
    );
    canvas.drawCircle(sunCenter, sunOuternGradientRadius,
        Paint()..shader = circleOuternGradientShader);

    canvas.drawCircle(sunCenter, 18.0, Paint()..color = color);
  }

  @override
  bool shouldRepaint(HeaderPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue ||
      oldDelegate.firstStarOffset != firstStarOffset;
}
