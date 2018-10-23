import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/background_widget.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/components/menu_controller.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/components/menu_list_item_widget.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/model/menu_model.dart';

final menuScreenKey = new GlobalKey(debugLabel: 'MenuScreen');

class MenuScreen extends StatefulWidget {
  final Menu menu;
  final int selectedItemId;
  final Function(int) onMenuItemSelected;
  final MenuController menuController;

  MenuScreen({
    this.menu,
    this.selectedItemId,
    this.onMenuItemSelected,
    this.menuController
  }) : super(key: menuScreenKey);

  @override
  _MenuScreenState createState() => new _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {

  AnimationController animationController;
  Animation<double> _animationReveal;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    );

    _animationReveal = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.decelerate));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    switch (widget.menuController.state) {
      case MenuState.open:
      case MenuState.opening:
      print('_MenuScreenState.build');
      animationController.forward();
        break;
      case MenuState.closed:
      case MenuState.closing:
      animationController.reverse();
        break;
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: new Material(
        color: Colors.transparent,
        child: new Stack(
          fit: StackFit.expand,
          children: [
            BackgroundWidget(),
            new Opacity(
              opacity: _animationReveal.value,
              child: Center(
                  child: ListView.builder(
                    itemCount: widget.menu.items.length,
                    padding: const EdgeInsets.all(0.0),
                    shrinkWrap: true,
                    primary: true,
                    itemBuilder: (context, index) {
                      return MenuListItemWidget(
                        animationReveal: _animationReveal,
                        title: widget.menu.items[index].title,
                        isSelected: widget.selectedItemId == widget.menu.items[index].id,
                        onTap: () {
                          widget.onMenuItemSelected(widget.menu.items[index].id);
                        },
                      );
                    },
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}



