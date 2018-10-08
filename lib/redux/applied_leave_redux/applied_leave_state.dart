
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/model/loading_status.dart';
import 'package:meta/meta.dart';

@immutable
class AppliedLeaveState {
  AppliedLeaveState({this.leaveList,
    this.loadingStatus,
    this.errorMessage});

  @required final List<Leave> leaveList;
  final LoadingStatus loadingStatus;
  final String errorMessage;

  factory AppliedLeaveState.initial() {
    return AppliedLeaveState(
        loadingStatus: LoadingStatus.loading,
        leaveList: [],
      errorMessage: null,
    );
  }

  AppliedLeaveState setLeaveList({List<Leave> receivedList, LoadingStatus status, String errorMessage})
  {
    leaveList.addAll(receivedList);
    return AppliedLeaveState(leaveList: leaveList, loadingStatus: status, errorMessage: errorMessage);
  }

  AppliedLeaveState clearAppliedLeaveList()
  {
    print('AppliedLeaveState.clearAppliedLeaveList ${leaveList.length}');
    leaveList.clear();
    return AppliedLeaveState(loadingStatus: LoadingStatus.loading, leaveList: leaveList, errorMessage: '');
  }

  AppliedLeaveState deleteLeave({Leave leave})
  {
    leaveList.remove(leave);
    return AppliedLeaveState(leaveList: leaveList,);
  }

  AppliedLeaveState addLeave({Leave leave})
  {
    leaveList.add(leave);
    return AppliedLeaveState(leaveList: leaveList,);
  }

}