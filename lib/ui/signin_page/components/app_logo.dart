import 'package:flutter/material.dart';

class AppLogoWidget extends StatelessWidget {
  AppLogoWidget({@required AnimationController controller})
      : animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.100, 0.400, curve: Curves.elasticInOut)));

  final Animation animation;

  @override
  Widget build(BuildContext context) {
    return Transform(
        transform:
            new Matrix4.diagonal3Values(animation.value, animation.value, 1.0),
        alignment: Alignment.center,
        child: new Container(
          width: 150.0,
          height: 150.0,
          alignment: Alignment.center,
          decoration: new BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/mutualmobile.png'),
              fit: BoxFit.scaleDown,
            ),
          ),
        ));
  }
}
