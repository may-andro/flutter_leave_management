
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:flutter_mm_hrmangement/model/PublicHoliday.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:meta/meta.dart';

class FetchEmployeeListAction {}

class RefreshEmployeeListAction {}

class ClearEmployeeListAction{}

class ErrorFetchEmployeeListAction {
  ErrorFetchEmployeeListAction({@required this.errorStr});
  final String errorStr;
}

class SetEmployeeListAction {
  SetEmployeeListAction({@required this.employeeList});
  final List<User> employeeList;
}

class AddEmployeeAction {
  AddEmployeeAction({@required this.user, @required this.password});
  final User user;
  final String password;
}

class DeleteEmployeeAction {
  DeleteEmployeeAction({@required this.user});
  final User user;
}