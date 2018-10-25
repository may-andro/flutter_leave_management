import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/model/menu_item_model.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/model/menu_model.dart';

class BaseFragmentContainerWidget extends StatefulWidget {
  final bool isDrawerOpen;
  final bool isSettingOpen;
  final Widget contentScreen;
  final Widget fabButton;
  final Function() refreshCallback;
  final Function() menuToggleCallback;

  BaseFragmentContainerWidget({
    this.isDrawerOpen,
    this.isSettingOpen,
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

            IconButton(
              icon: widget.isSettingOpen
                  ? Icon(
                Icons.clear,
                color: Colors.white,
              )
                  : Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                widget.refreshCallback();
              },
            ),


            /*CustomPaint(
              painter: RevealProgressButtonPainter(
                  _fraction, MediaQuery.of(context).size),
              child: IconButton(
                icon: Icon(
                  state == 0 ? Icons.settings : Icons.clear,
                  color: Colors.white,
                ),
                onPressed: () {
                  widget.refreshCallback();
                  if (state == 0) {
                    reveal();
                  } else {
                    _screenController.reverse();
                  }
                },
              ),
            ),
*/


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

          widget.refreshCallback();
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
  Size _screenSize;
  double _fraction;

  RevealProgressButtonPainter(this._fraction, this._screenSize);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.fill;

    var finalRadius =
        sqrt(pow(_screenSize.width, 2) + pow(_screenSize.height, 2));
    var radius = 24.0 + finalRadius * _fraction;

    canvas.drawCircle(Offset(size.width, size.height), radius, paint);

    if (_fraction > 0.9) {
      TextSpan textSpanMenu = new TextSpan(
          style: new TextStyle(color: Colors.white, fontSize: 34.0),
          text: 'Menu');
      TextPainter textPainterMenu = new TextPainter(
          text: textSpanMenu,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      textPainterMenu.layout();
      textPainterMenu.paint(
          canvas, Offset(-_screenSize.width / 2, -_screenSize.height / 2 - 75));

      TextSpan textSpanTheme = TextSpan(
          style: TextStyle(color: Colors.white, fontSize: 24.0),
          text: 'Theme',
          children: [
            TextSpan(
                style: new TextStyle(color: Colors.white, fontSize: 24.0),
                text: 'Change',
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    print(' iiii pressed');
                  }),
          ],
          );
      TextPainter textPainterTheme = new TextPainter(
          text: textSpanTheme,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      textPainterTheme.layout();
      textPainterTheme.paint(
          canvas, Offset(-_screenSize.width / 2, -_screenSize.height / 2));

      TextSpan textSpanLanguage = new TextSpan(
          style: new TextStyle(color: Colors.white, fontSize: 24.0),
          text: 'Language',
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              print(' iiii pressed');
            });
      TextPainter textPainterLanguage = new TextPainter(
          text: textSpanLanguage,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      textPainterLanguage.layout();
      textPainterLanguage.paint(
          canvas, Offset(-_screenSize.width / 2, -_screenSize.height / 2 + 75));

      TextSpan textSpanSetting = new TextSpan(
          style: TextStyle(color: Colors.white,
              fontSize: 24.0,
              letterSpacing: 1.2),
          text: 'Setting',
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              print(' iiii pressed');
            });
      TextPainter textPainterSetting = new TextPainter(
          text: textSpanSetting,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      textPainterSetting.layout();
      textPainterSetting.paint(canvas,
          Offset(-_screenSize.width / 2, -_screenSize.height / 2 + 150)
      );




    }
  }

  @override
  bool shouldRepaint(RevealProgressButtonPainter oldDelegate) {
    return oldDelegate._fraction != _fraction;
  }
}
