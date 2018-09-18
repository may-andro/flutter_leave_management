


import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/ui/add_project_page/model/AddProjectBloc.dart';

class AddProjectBlocProvider extends InheritedWidget {
  final AddProjectBloc bloc;
  final Widget child;
  AddProjectBlocProvider({this.bloc, this.child}) : super(child: child);

  static AddProjectBlocProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(AddProjectBlocProvider);
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}