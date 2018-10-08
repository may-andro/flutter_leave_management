import 'package:flutter_mm_hrmangement/model/loading_status.dart';
import 'package:flutter_mm_hrmangement/redux/employee_management_redux/employee_management_action.dart';
import 'package:flutter_mm_hrmangement/redux/employee_management_redux/employee_management_state.dart';
import 'package:redux/redux.dart';


final employeeManagementReducer = combineReducers<EmployeeManagementState>([
  TypedReducer<EmployeeManagementState, FetchEmployeeListAction>(_fetchingEmployeeListState),
  TypedReducer<EmployeeManagementState, ClearEmployeeListAction>(_clearEmployeeListState),
  TypedReducer<EmployeeManagementState, ErrorFetchEmployeeListAction>(_errorLoadingEmployeeListState),
  TypedReducer<EmployeeManagementState, SetEmployeeListAction>(_setEmployeeListState),
  TypedReducer<EmployeeManagementState, DeleteEmployeeAction>(_deleteEmployeeState),
  TypedReducer<EmployeeManagementState, AddEmployeeAction>(_addEmployeeState),

]);

EmployeeManagementState _fetchingEmployeeListState(EmployeeManagementState state, FetchEmployeeListAction action) {
  return state.setEmployeeList(receivedList: []);
}

EmployeeManagementState _errorLoadingEmployeeListState(
    EmployeeManagementState state, ErrorFetchEmployeeListAction action) {
  return state.setEmployeeList(status: LoadingStatus.error, errorMessage: action.errorStr);
}

EmployeeManagementState _setEmployeeListState(EmployeeManagementState state, SetEmployeeListAction action) {
  return state.setEmployeeList(receivedList: action.employeeList, status: LoadingStatus.success, errorMessage: '');
}

EmployeeManagementState _clearEmployeeListState(EmployeeManagementState state, ClearEmployeeListAction action) {
  return state.clearEmployeeList();
}

EmployeeManagementState _deleteEmployeeState(EmployeeManagementState state, DeleteEmployeeAction action) {
  return state.deleteEmployee(user: action.user);
}

EmployeeManagementState _addEmployeeState(EmployeeManagementState state, AddEmployeeAction action) {
  return state.addEmployee(user: action.user);
}