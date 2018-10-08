import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/ui/dashboard_page/components/landscape_home_page.dart';
import 'package:flutter_mm_hrmangement/ui/dashboard_page/components/portrait_home_page.dart';

class DashBoardPage extends StatefulWidget {
  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> with TickerProviderStateMixin{
  AnimationController _screenController;
  Animation<double> _animationReveal;

  @override
  void initState() {
    super.initState();

    _screenController = new AnimationController(
        duration: new Duration(seconds: 1), vsync: this);

    _animationReveal = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _screenController, curve: Curves.decelerate));

    _screenController.forward();
  }

  @override
  void dispose() {
    _screenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _screenController,
        builder: (BuildContext context, Widget child) {
          return _buildUI();
        });
  }

  Widget _buildUI() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    bool isLandscape = orientation == Orientation.landscape;
    if (isLandscape) {
      return LandscapeHomePage(_animationReveal);
    } else {
      return PortraitHomePage(_animationReveal);
    }
  }
}
