import 'package:flutter_mm_hrmangement/redux/applied_leave_redux/applied_leave_state.dart';
import 'package:flutter_mm_hrmangement/redux/employee_management_redux/employee_management_state.dart';
import 'package:flutter_mm_hrmangement/redux/login_action/login_state.dart';
import 'package:flutter_mm_hrmangement/redux/project_management_redux/project_management_state.dart';
import 'package:flutter_mm_hrmangement/redux/public_holiday/public_holiday_state.dart';

class AppState {
  final LoginState loginState;
  final AppliedLeaveState appliedLeaveState;
  final PublicHolidayState publicHolidayState;
  final EmployeeManagementState employeeManagementState;
  final ProjectManagementState projectManagementState;

  AppState({this.loginState, this.appliedLeaveState, this.publicHolidayState, this.employeeManagementState, this.projectManagementState});

  factory AppState.initial() {
    return AppState(
        loginState: LoginState.initial(),
        appliedLeaveState: AppliedLeaveState.initial(),
        publicHolidayState: PublicHolidayState.initial(),
        employeeManagementState: EmployeeManagementState.initial(),
        projectManagementState: ProjectManagementState.initial(),
    );
  }

  AppState setLoginState({ LoginState loginState}) {
    return new AppState(loginState: loginState ?? this.loginState);
  }

  AppState setAppliedLeaveState({ AppliedLeaveState appliedLeaveState}) {
    return new AppState(appliedLeaveState: appliedLeaveState ?? this.appliedLeaveState);
  }

  AppState setPublicHolidayState({ PublicHolidayState publicHolidayState}) {
    return new AppState(publicHolidayState: publicHolidayState ?? this.publicHolidayState);
  }

  AppState setEmployeeManagementStateState({ EmployeeManagementState employeeManagementState}) {
    return new AppState(employeeManagementState: employeeManagementState ?? this.employeeManagementState);
  }

  AppState setProjectAndEmployeeManagementState({ ProjectManagementState projectManagementState}) {
    return new AppState(projectManagementState: projectManagementState ?? this.projectManagementState);
  }
}