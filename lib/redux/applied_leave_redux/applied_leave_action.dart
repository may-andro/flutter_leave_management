
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:meta/meta.dart';

class FetchAppliedLeaveAction {
  FetchAppliedLeaveAction({@required this.mmid});
  final String mmid;
}

class RefreshAppliedLeaveAction {}

class ClearAppliedLeaveAction{}

class ErrorAppliedLeaveAction {
  ErrorAppliedLeaveAction({@required this.errorStr});
  final String errorStr;
}

class SetAppliedLeaveAction {
  SetAppliedLeaveAction({@required this.leaveList});
  final List<Leave> leaveList;
}

class AddLeaveAction {
  AddLeaveAction({@required this.leave});
  final Leave leave;
}

class DeleteLeaveAction {
  DeleteLeaveAction({@required this.leave});
  final Leave leave;
}