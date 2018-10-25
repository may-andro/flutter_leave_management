import 'package:flutter_mm_hrmangement/redux/applied_leave_redux/applied_leave_state.dart';
import 'package:flutter_mm_hrmangement/redux/employee_management_redux/employee_management_state.dart';
import 'package:flutter_mm_hrmangement/redux/login_action/login_state.dart';
import 'package:flutter_mm_hrmangement/redux/project_management_redux/project_management_state.dart';
import 'package:flutter_mm_hrmangement/redux/public_holiday/public_holiday_state.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';

class AppState {
  final LoginState loginState;
  final AppliedLeaveState appliedLeaveState;
  final PublicHolidayState publicHolidayState;
  final EmployeeManagementState employeeManagementState;
  final ProjectManagementState projectManagementState;
  final int themeDataId;

  AppState({this.loginState,
    this.appliedLeaveState,
    this.publicHolidayState,
    this.employeeManagementState,
    this.projectManagementState,
    this.themeDataId,
  });

  factory AppState.initial() {
    return AppState(
        loginState: LoginState.initial(),
        appliedLeaveState: AppliedLeaveState.initial(),
        publicHolidayState: PublicHolidayState.initial(),
        employeeManagementState: EmployeeManagementState.initial(),
        projectManagementState: ProjectManagementState.initial(),
        themeDataId: SELECTED_THEME_PURPLE,
    );
  }

  AppState copyWith({
    LoginState loginState,
    AppliedLeaveState appliedLeaveState,
    PublicHolidayState publicHolidayState,
    EmployeeManagementState employeeManagementState,
    ProjectManagementState projectManagementState,
    int themeDataId,
  }) {
    return AppState(
      loginState: loginState ?? this.loginState,
      appliedLeaveState: appliedLeaveState ?? this.appliedLeaveState,
      publicHolidayState: publicHolidayState ?? this.publicHolidayState,
      employeeManagementState: employeeManagementState ?? this.employeeManagementState,
      projectManagementState: employeeManagementState ?? this.projectManagementState,
      themeDataId: themeDataId ?? this.themeDataId,
    );
  }

  AppState setLoginState({ LoginState loginState}) {
    return copyWith(loginState: loginState ?? this.loginState);
  }

  AppState setAppliedLeaveState({ AppliedLeaveState appliedLeaveState}) {
    return copyWith(appliedLeaveState: appliedLeaveState ?? this.appliedLeaveState);
  }

  AppState setPublicHolidayState({ PublicHolidayState publicHolidayState}) {
    return copyWith(publicHolidayState: publicHolidayState ?? this.publicHolidayState);
  }

  AppState setEmployeeManagementStateState({ EmployeeManagementState employeeManagementState}) {
    return copyWith(employeeManagementState: employeeManagementState ?? this.employeeManagementState);
  }

  AppState setProjectAndEmployeeManagementState({ ProjectManagementState projectManagementState}) {
    return copyWith(projectManagementState: projectManagementState ?? this.projectManagementState);
  }

  AppState setThemeDataId({ int id}) {
    return copyWith(projectManagementState: projectManagementState ?? this.projectManagementState);
  }
}