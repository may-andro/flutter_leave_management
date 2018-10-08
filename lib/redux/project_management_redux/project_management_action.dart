
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:flutter_mm_hrmangement/model/ProjectModel.dart';
import 'package:flutter_mm_hrmangement/model/PublicHoliday.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:meta/meta.dart';

class FetchProjectListAction {}

class RefreshProjectListAction {}

class ClearProjectListAction{}

class ErrorFetchProjectListAction {
  ErrorFetchProjectListAction({@required this.errorStr});
  final String errorStr;
}

class SetProjectListAction {
  SetProjectListAction({@required this.projectList});
  final List<Project> projectList;
}

class AddProjectAction {
  AddProjectAction({@required this.project});
  final Project project;
}

class DeleteProjectAction {
  DeleteProjectAction({@required this.project});
  final Project project;
}

class AddSelectedEmployeeAction {
  AddSelectedEmployeeAction({@required this.user});
  final User user;
}

class ClearSelectedEmployeeListAction {}

class DeselectSelectEmployeeAction{
  final User user;
  DeselectSelectEmployeeAction(this.user);
}

class SetProjectNameAction {
  SetProjectNameAction({@required this.name});
  final String name;
}

class DeleteProjectNameAction {}



