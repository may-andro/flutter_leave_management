import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:flutter_mm_hrmangement/model/ProjectModel.dart';
import 'package:flutter_mm_hrmangement/model/PublicHoliday.dart';
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

  //Employee Management

  EmployeeManagementState setEmployeeList({List<User> receivedList, LoadingStatus status, String errorMessage})
  {
    employeeList.addAll(receivedList);
    return EmployeeManagementState(loadingStatus: status, employeeList: employeeList, errorMessage: errorMessage);
  }

  EmployeeManagementState clearEmployeeList()
  {
    employeeList.clear();
    return EmployeeManagementState(loadingStatus: LoadingStatus.loading, employeeList: employeeList, errorMessage: '');
  }

  EmployeeManagementState deleteEmployee({User user})
  {
    employeeList.remove(user);
    return EmployeeManagementState(employeeList: employeeList,);
  }

  EmployeeManagementState addEmployee({User user})
  {
    employeeList.add(user);
    return EmployeeManagementState(employeeList: employeeList,);
  }
}