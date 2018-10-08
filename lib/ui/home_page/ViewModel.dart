import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

class ViewModel {
  final User user;

  final List<Leave> leaveList;

  ViewModel({
    @required this.user,
    this.leaveList
  });

  static ViewModel fromStore(Store<AppState> store) {
    return ViewModel(user: store.state.loginState.user, leaveList: store.state.appliedLeaveState.leaveList);
  }
}
