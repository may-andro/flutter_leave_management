import 'dart:async';

import 'package:flutter_mm_hrmangement/redux/applied_leave_redux/applied_leave_middleware.dart';
import 'package:flutter_mm_hrmangement/redux/employee_management_redux/employee_management_middleware.dart';
import 'package:flutter_mm_hrmangement/redux/project_management_redux/project_management_middleware.dart';
import 'package:flutter_mm_hrmangement/redux/public_holiday/public_holiday_middleware.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/redux/reducers/app_reducer.dart';
import 'package:redux/redux.dart';

Future<Store<AppState>> createStore() async {

  return Store<AppState>(
    appReducer, // new
    initialState: AppState.initial(),
    distinct: true, // new
    middleware: [
      AppliedLeaveMiddleware(),
      PublicHolidayMiddleware(),
      ProjectManagementMiddleware(),
      EmployeeManagementMiddleware()
    ], // new
  );
}
