import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/reveal_functions.dart';

class ProgressButton extends StatefulWidget {
  final BaseRevealAndAnimateFunction baseRevealAndAnimateFunction;
  final VoidCallback reveal;
  final String label;
  Function() param2;
  ProgressButton(this.baseRevealAndAnimateFunction, this.reveal, this.label,this.param2);

  @override
  _ProgressButtonState createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> with TickerProviderStateMixin {

  static final int BUTTON_IDLE_STATE = 0;
  static final int BUTTON_PROGRESS_STATE = 1;
  static final int BUTTON_REVEAL_STATE = 2;

  AnimationController _controller;
  Animation _animation;

  GlobalKey _globalKey = GlobalKey();

  var _isPressed = false;
  var _animatingReveal = false;
  int _state = BUTTON_IDLE_STATE;
  double _width = double.infinity;

  @override
  void deactivate() {
    reset();
    super.deactivate();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      key: _globalKey,
      height: 48.0,
      width: _width,
      child: RaisedButton(
        elevation: calculateElevation(),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        padding: EdgeInsets.all(0.0),
        color: _state == 2 ? Colors.deepPurple : Colors.black,
        child: buildButtonChild(),
        onPressed: () {
          setState(() {
            _isPressed = !_isPressed;
            if (_state == BUTTON_IDLE_STATE) {
              animateButton();
            }
          });
        },
      ),
    );
  }

  void animateButton() {
    double initialWidth = _globalKey.currentContext.size.width;

    _controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - 48.0) * _animation.value);
        });
      });
    _controller.forward();

    setState(() {
      _state = BUTTON_PROGRESS_STATE;
      print('_ProgressButtonState.animateButton $_state');
    });

    widget.baseRevealAndAnimateFunction.animateProgress().then((message) {
      print('_ProgressButtonState.animateButton $message');
      if((message as String).isNotEmpty) {
        widget.param2();
        _controller.reverse();
        reset();
      }  else {
        Timer(Duration(seconds: 1), () {
          setState(() {
            _state = BUTTON_REVEAL_STATE;
          });
        });

        Timer(Duration(seconds: 1), () {
          print('_ProgressButtonState.animateButton $_state');
          _animatingReveal = true;
          widget.reveal();
        });
      }
    });
  }


  Widget buildButtonChild() {
    if (_state == BUTTON_IDLE_STATE) {
      return Text(
        widget.label,
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      );
    } else if (_state == BUTTON_PROGRESS_STATE) {
      return SizedBox(
        height: 36.0,
        width: 36.0,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  double calculateElevation() {
    if (_animatingReveal) {
      return 0.0;
    } else {
      return _isPressed ? 6.0 : 4.0;
    }
  }

  void reset() {
    _width = double.infinity;
    _animatingReveal = false;
    _state = BUTTON_IDLE_STATE;
  }
}
