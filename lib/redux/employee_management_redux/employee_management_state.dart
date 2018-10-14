import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/model/loading_status.dart';
import 'package:meta/meta.dart';

@immutable
class EmployeeManagementState {
  EmployeeManagementState({this.loadingStatus,
    this.employeeList,
    this.errorMessage,
  });

  @required final List<User> employeeList;
  final LoadingStatus loadingStatus;
  final String errorMessage;

  factory EmployeeManagementState.initial() {
    return EmployeeManagementState(
      loadingStatus: LoadingStatus.loading,
      employeeList: [],
      errorMessage: null,
    );
  }

  EmployeeManagementState copyWith(
      {
        LoadingStatus loadingStatus,
        List<User> employeeList,
        String errorMessage,
      }) {
    return EmployeeManagementState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      employeeList: employeeList ?? this.employeeList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  //Employee Management

  EmployeeManagementState setEmployeeList({List<User> receivedList, LoadingStatus status, String errorMessage})
  {
    employeeList.addAll(receivedList);
    return copyWith(loadingStatus: status, employeeList: employeeList, errorMessage: errorMessage);
  }

  EmployeeManagementState clearEmployeeList()
  {
    employeeList.clear();
    return copyWith(loadingStatus: LoadingStatus.loading, employeeList: employeeList, errorMessage: '');
  }

  EmployeeManagementState deleteEmployee({User user})
  {
    employeeList.remove(user);
    return copyWith(employeeList: employeeList,);
  }

  EmployeeManagementState addEmployee({User user})
  {
    employeeList.add(user);
    return copyWith(employeeList: employeeList,);
  }
}