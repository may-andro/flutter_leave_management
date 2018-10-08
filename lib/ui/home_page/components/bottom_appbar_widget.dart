import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/ui/dashboard_page/components/CustomDrawer.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/components/drawer_widget.dart';

class BottomBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.deepPurple,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              _modalBottomSheetMenu(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              setingsView(context);
            },
          ),
        ],
      ),
    );
  }

  void _modalBottomSheetMenu(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return DrawerWidget();
        }
    );
  }

  void setingsView(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return CustomDrawer();
        }
    );
  }
}
