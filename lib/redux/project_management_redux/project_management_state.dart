
import 'package:flutter_mm_hrmangement/model/ProjectModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/model/loading_status.dart';
import 'package:meta/meta.dart';

@immutable
class ProjectManagementState {
  ProjectManagementState({this.loadingStatus,
    this.selectedEmployeeList,
    this.errorMessage,
    this.projectList,
    this.projectName});

  final List<User> selectedEmployeeList;
  final List<Project> projectList;
  final LoadingStatus loadingStatus;
  final String errorMessage;
  final String projectName;

  factory ProjectManagementState.initial() {
    return ProjectManagementState(
      loadingStatus: LoadingStatus.loading,
      selectedEmployeeList: [],
      projectList: [],
      errorMessage: null,
      projectName: null
    );
  }

  ProjectManagementState copyWith(
      {
        LoadingStatus loadingStatus,
        List<User> selectedEmployeeList,
        List<Project> projectList,
        String errorMessage,
        String projectName
      }) {
    return ProjectManagementState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        selectedEmployeeList: selectedEmployeeList ?? this.selectedEmployeeList,
        projectList: projectList ?? this.projectList,
        errorMessage: errorMessage ?? this.errorMessage,
        projectName: projectName ?? this.projectName,
    );
  }

  //Project Management

  ProjectManagementState selectSelectedEmployee({User user})
  {
    selectedEmployeeList.add(user);
    return copyWith(selectedEmployeeList: selectedEmployeeList);
  }

  ProjectManagementState clearSelectedEmployeeList()
  {
    selectedEmployeeList.clear();
    return copyWith(selectedEmployeeList: selectedEmployeeList);
  }

  ProjectManagementState deselectSelectedEmployee({User user})
  {
    selectedEmployeeList.remove(user);
    return copyWith(selectedEmployeeList: selectedEmployeeList);
  }

  ProjectManagementState setProjectName({String name})
  {
    return copyWith(projectName: name);
  }

  ProjectManagementState deleteProjectName()
  {
    return copyWith(projectName: '');
  }

  ProjectManagementState setProjectList({List<Project> receivedList, LoadingStatus status, String errorMessage})
  {
    projectList.addAll(receivedList);
    return copyWith(projectList: projectList, loadingStatus: loadingStatus, errorMessage: errorMessage);
  }

  ProjectManagementState addProject({Project project})
  {
    projectList.add(project);
    return copyWith(projectList: projectList);
  }

  ProjectManagementState clearProjectList()
  {
    projectList.clear();
    return copyWith(projectList: projectList);
  }

  ProjectManagementState deleteProject({Project project})
  {
    projectList.remove(project);
    return copyWith(projectList: projectList);
  }


}