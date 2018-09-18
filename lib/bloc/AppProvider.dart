import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';

class AppProviderInheritedWidget extends InheritedWidget {
  final User loggedInUser;

  AppProviderInheritedWidget({
    Key key,
    this.loggedInUser,
    Widget child}) : super(key: key, child: child);

  static AppProviderInheritedWidget of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(AppProviderInheritedWidget);

  @override
  bool updateShouldNotify(AppProviderInheritedWidget oldWidget) {
    return loggedInUser != oldWidget.loggedInUser;
  }
}