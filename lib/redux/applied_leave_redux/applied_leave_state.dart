import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
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

  AppliedLeaveState copyWith(
      {
        LoadingStatus loadingStatus,
        List<Leave> leaveList,
        String errorMessage,
      }) {
    return AppliedLeaveState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      leaveList: leaveList ?? this.leaveList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  AppliedLeaveState setLeaveList({List<Leave> receivedList, LoadingStatus status, String errorMessage})
  {
    leaveList.addAll(receivedList);
    return copyWith(leaveList: leaveList, loadingStatus: status, errorMessage: errorMessage);
  }

  AppliedLeaveState clearAppliedLeaveList()
  {
    leaveList.clear();
    return copyWith(loadingStatus: LoadingStatus.loading, leaveList: leaveList, errorMessage: '');
  }

  AppliedLeaveState deleteLeave({Leave leave})
  {
    leaveList.remove(leave);
    return copyWith(leaveList: leaveList,);
  }

  AppliedLeaveState addLeave({Leave leave})
  {
    leaveList.add(leave);
    return copyWith(leaveList: leaveList,);
  }

  AppliedLeaveState updateLeave({Leave leave, int index})
  {
    leaveList[index] = leave;
    return copyWith(leaveList: leaveList,);
  }

}