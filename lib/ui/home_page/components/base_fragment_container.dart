import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/background_widget.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/model/menu_item_model.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/model/menu_model.dart';

class BaseFragmentContainerWidget extends StatefulWidget {
  final bool isDrawerOpen;
  final Widget contentScreen;
  final Widget fabButton;
  final Function() refreshCallback;
  final Function() menuToggleCallback;

  BaseFragmentContainerWidget({
    this.isDrawerOpen,
    this.contentScreen,
    this.fabButton,
    this.refreshCallback,
    this.menuToggleCallback,
  });

  @override
  _BaseFragmentContainerWidgetState createState() =>
      _BaseFragmentContainerWidgetState();
}

class _BaseFragmentContainerWidgetState
    extends State<BaseFragmentContainerWidget> with TickerProviderStateMixin {
  @override
  AnimationController _screenController;
  Animation<double> _animationReval;
  double _fraction = 0.0;
  int state = 0;

  @override
  void initState() {
    super.initState();

    _screenController = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
  }

  @override
  void dispose() {
    _screenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(color: Colors.transparent, child: widget.contentScreen),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.deepPurple,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: widget.isDrawerOpen
                  ? Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
              onPressed: () {
                widget.menuToggleCallback();
              },
            ),

            CustomPaint(
              painter: RevealProgressButtonPainter(
                  _fraction, MediaQuery.of(context).size),
              child: IconButton(
                icon: Icon(
                  state == 0 ? Icons.settings : Icons.clear,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (state == 0) {
                    reveal();
                  } else {
                    _screenController.reverse();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: widget.fabButton,
    );
  }

  void reveal() {
    _animationReval = Tween(begin: 0.0, end: 1.0).animate(_screenController)
      ..addListener(() {
        setState(() {
          _fraction = _animationReval.value;
        });
      })
      ..addStatusListener((AnimationStatus state) {
        if (state == AnimationStatus.completed) {
          setState(() {
            this.state = 1;
          });
        }

        if (state == AnimationStatus.dismissed) {
          setState(() {
            this.state = 0;
          });
        }
      });

    _screenController.forward();
  }

  Menu getMenu() {
    var list = [
      MenuItem(
        id: 0,
        title: 'Setting',
      ),
      MenuItem(
        id: 1,
        title: 'About',
      ),
    ];
    return Menu(
      items: list,
    );
  }

  Widget getSettingList() {
    if (state == 0) {
      return Container();
    } else {

      return ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Map'),
          ),
          ListTile(
            leading: Icon(Icons.photo_album),
            title: Text('Album'),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Phone'),
          ),
        ],
      );
    }
  }
}

class RevealProgressButtonPainter extends CustomPainter {

  RevealProgressButtonPainter(this._fraction, this._screenSize): textPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.rtl,
  ),
        textStyle= const TextStyle(
          color: Colors.white,
          fontFamily: 'Times New Roman',
          fontSize: 25.0,
        );

  Size _screenSize;

  double _fraction;

  final TextPainter textPainter;
  final TextStyle textStyle;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.fill;

    var finalRadius = sqrt(pow(_screenSize.width / 2, 2) +
        pow(_screenSize.height - 32.0 - 48.0, 2));

    var radius = 24.0 + finalRadius * _fraction;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);


    /*canvas.save();

    textPainter.text= new TextSpan(
      text: 'Setting',
      style: textStyle,
    );
    textPainter.layout();

    textPainter.paint(canvas, new Offset(-(textPainter.width/2), -(textPainter.height/2)));

    canvas.restore();*/

  }

  @override
  bool shouldRepaint(RevealProgressButtonPainter oldDelegate) {
    return oldDelegate._fraction != _fraction;
  }
}
