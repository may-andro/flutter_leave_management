import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/progress_button.dart';
import 'package:flutter_mm_hrmangement/components/reveal_functions.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/components/reveal_progress_button_painter.dart';

class CircularRevelButton extends StatefulWidget {
  final BaseRevealAndAnimateFunction baseRevealAndAnimateFunction;
  final String label;
  Function() param2;
  CircularRevelButton(this.baseRevealAndAnimateFunction, this.label,this.param2);
  @override
  _CircularRevelState createState() => _CircularRevelState();
}

class _CircularRevelState extends State<CircularRevelButton> with TickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;
  double _fraction = 0.0;

  @override
  Widget build(BuildContext context) {
    print('_CircularRevelState.build');
    return Center(
      child: CustomPaint(
        painter: RevealProgressButtonPainter(_fraction, MediaQuery.of(context).size),
        child: ProgressButton(widget.baseRevealAndAnimateFunction, reveal, widget.label, widget.param2),
      ),
    );
  }

  void reveal() {
    print('_CircularRevelState.reveal');
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _fraction = _animation.value;
        });
      })
      ..addStatusListener((AnimationStatus state) {
        if (state == AnimationStatus.completed) {
          print("Animation completd");
          widget.baseRevealAndAnimateFunction.revealProgress();
        }
      });
    _controller.forward();
  }
}
