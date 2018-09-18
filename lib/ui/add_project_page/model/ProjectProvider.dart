import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/ui/add_project_page/model/AddProjectBloc.dart';

class ProjectProvider extends InheritedWidget {
  final AddProjectBloc addProjectBloc;

  ProjectProvider({this.addProjectBloc, child}) : super(child: child);

  static ProjectProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(ProjectProvider);

  @override
  bool updateShouldNotify(ProjectProvider oldWidget) {
    return addProjectBloc != oldWidget.addProjectBloc;
  }
}