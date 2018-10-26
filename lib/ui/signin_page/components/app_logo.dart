import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/utility/text_theme.dart';

class AppLogoWidget extends StatelessWidget {
  AppLogoWidget({@required AnimationController controller})
      : animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 1.0, curve: Curves.decelerate)));

  final Animation animation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: 150.0,
          height: 150.0,
          child: CustomPaint(
              foregroundPainter: CircularPainter(
                fraction: animation.value,
              ),
              child: Transform(
                  transform: Matrix4.diagonal3Values(animation.value, animation.value, 1.0),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/logo.jpg')
                  )
              ),
          )
      ),
    );
  }
}

class CircularPainter extends CustomPainter {

  final double fraction;
  CircularPainter({
    this.fraction
  });

  @override
  void paint(Canvas canvas, Size size) {
    Offset center  = new Offset(size.width/2, size.height/2);
    double radius  = min(size.width/2,size.height/2);
    Paint complete = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    double arcAngle = 2*pi* (fraction);
    canvas.drawArc(
        new Rect.fromCircle(center: center,radius: radius),
        -pi/2,
        arcAngle,
        false,
        complete
    );
  }

  @override
  bool shouldRepaint(CircularPainter oldDelegate) {
    return true;
  }
}