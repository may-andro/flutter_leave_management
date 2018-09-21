import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/progress_button.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/home_page.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/components/reveal_progress_button_painter.dart';

class CircularRevelButton extends StatefulWidget {
  final Function callback;
  CircularRevelButton(this.callback, Function onPress);
  @override
  _CircularRevelState createState() => _CircularRevelState();
}



class _CircularRevelState extends State<CircularRevelButton> with TickerProviderStateMixin {

  Animation<double> _animation;
  AnimationController _controller;
  double _fraction = 0.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: RevealProgressButtonPainter(_fraction, MediaQuery.of(context).size),
        child: ProgressButton(reveal),
      ),
    );
  }

  void reveal() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _fraction = _animation.value;
        });
      })
      ..addStatusListener((AnimationStatus state) {
        if (state == AnimationStatus.completed) {
          print("Animation completd");
          var router = MaterialPageRoute(builder: (BuildContext context){
            return HomePage();
          });
          Navigator.of(context).push(router);
        }
      });
    _controller.forward();
  }
}
