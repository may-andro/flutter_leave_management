import 'package:flutter_mm_hrmangement/model/loading_status.dart';
import 'package:flutter_mm_hrmangement/redux/applied_leave_redux/applied_leave_action.dart';
import 'package:flutter_mm_hrmangement/redux/applied_leave_redux/applied_leave_state.dart';
import 'package:redux/redux.dart';


final appliedLeaveReducer = combineReducers<AppliedLeaveState>([
  TypedReducer<AppliedLeaveState, FetchAppliedLeaveAction>(_fetchingAppliedLeaveList),
  TypedReducer<AppliedLeaveState, ClearAppliedLeaveAction>(_clearAppliedLeaveListState),
  TypedReducer<AppliedLeaveState, ErrorAppliedLeaveAction>(_errorAppliedLeaveListState),
  TypedReducer<AppliedLeaveState, SetAppliedLeaveAction>(_setAppliedLeaveListState),
  TypedReducer<AppliedLeaveState, AddLeaveAction>(_addLeaveState),
  TypedReducer<AppliedLeaveState, DeleteLeaveAction>(_deleteLeaveState),
  TypedReducer<AppliedLeaveState, UpdateLeaveAction>(_updateLeaveState),
]);

AppliedLeaveState _fetchingAppliedLeaveList(AppliedLeaveState state, FetchAppliedLeaveAction action) {
  return state.setLeaveList(receivedList: []);
}

AppliedLeaveState _clearAppliedLeaveListState(AppliedLeaveState state, ClearAppliedLeaveAction action) {
  return state.clearAppliedLeaveList();
}

AppliedLeaveState _errorAppliedLeaveListState(AppliedLeaveState state, ErrorAppliedLeaveAction action) {
  return state.setLeaveList(status: LoadingStatus.error, errorMessage: action.errorStr);
}

AppliedLeaveState _setAppliedLeaveListState(AppliedLeaveState state, SetAppliedLeaveAction action) {
  return state.setLeaveList(status: LoadingStatus.success, errorMessage: '', receivedList: action.leaveList);
}

AppliedLeaveState _deleteLeaveState(AppliedLeaveState state, DeleteLeaveAction action) {
  return state.deleteLeave(leave: action.leave);
}

AppliedLeaveState _addLeaveState(AppliedLeaveState state, AddLeaveAction action) {
  return state.addLeave(leave: action.leave);
}

AppliedLeaveState _updateLeaveState(AppliedLeaveState state, UpdateLeaveAction action) {
  print('_updateLeaveState ${action.leave}');
  return state.updateLeave(leave: action.leave, index: action.index);
}
