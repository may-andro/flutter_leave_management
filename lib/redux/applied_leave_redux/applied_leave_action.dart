
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:meta/meta.dart';

class FetchAppliedLeaveAction {
  FetchAppliedLeaveAction({@required this.mmid});
  final String mmid;
}

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
  AddLeaveAction({@required this.leave,
    @required this.leaveId,
    @required this.user,
    @required this.fcmtokenIdList
  });
  final Leave leave;
  final String leaveId;
  final User user;
  final List<String> fcmtokenIdList;
}

class DeleteLeaveAction {
  DeleteLeaveAction({@required this.leave});
  final Leave leave;
}

class UpdateLeaveAction {
  UpdateLeaveAction({@required this.leave, @required this.index});
  final Leave leave;
  final int index;
}