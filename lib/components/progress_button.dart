import 'dart:async';

import 'package:flutter/material.dart';

class ProgressButton extends StatefulWidget {
  final Function callback;
  ProgressButton(this.callback);
  @override
  _ProgressButtonState createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> with TickerProviderStateMixin {

  static final int BUTTON_IDLE_STATE = 0;
  static final int BUTTON_PROGRESS_STATE = 1;
  static final int BUTTON_REVEAL_STATE = 2;


  var _isPressed = false, _animatingReveal = false;
  int _state = BUTTON_IDLE_STATE;
  double _width = double.infinity;
  Animation _animation;
  GlobalKey _globalKey = GlobalKey();
  AnimationController _controller;

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
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - 48.0) * _animation.value);
        });
      });
    _controller.forward();

    setState(() {
      _state = BUTTON_PROGRESS_STATE;
    });

    Timer(Duration(milliseconds: 3300), () {
      setState(() {
        _state = BUTTON_REVEAL_STATE;
      });
    });

    Timer(Duration(milliseconds: 3600), () {
      _animatingReveal = true;
      widget.callback();
    });
  }

  Widget buildButtonChild() {
    if (_state == BUTTON_IDLE_STATE) {
      return Text(
        'Login',
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
