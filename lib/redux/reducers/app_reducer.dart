import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/redux/login_action/login_reducer.dart';
import 'package:flutter_mm_hrmangement/redux/applied_leave_redux/applied_leave_reducer.dart';
import 'package:flutter_mm_hrmangement/redux/public_holiday/public_leave_reducer.dart';
import 'package:flutter_mm_hrmangement/redux/project_management_redux/project_management_reducer.dart';
import 'package:flutter_mm_hrmangement/redux/employee_management_redux/employee_management_reducer.dart';
import 'package:flutter_mm_hrmangement/redux/reducers/theme_change_reducers.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
      publicHolidayState: publicHolidayReducer(state.publicHolidayState, action),
      appliedLeaveState: appliedLeaveReducer(state.appliedLeaveState, action),
      loginState: setUserReducer(state.loginState, action),
      projectManagementState: projectManagementReducer(state.projectManagementState, action),
      employeeManagementState: employeeManagementReducer(state.employeeManagementState, action),
      themeDataId: changeThemeReducer(state.themeDataId, action)
  );

  //return state.setUser(user: action.user);
}
