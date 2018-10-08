import 'package:flutter_mm_hrmangement/model/loading_status.dart';
import 'package:flutter_mm_hrmangement/redux/project_management_redux/project_management_state.dart';
import 'package:flutter_mm_hrmangement/redux/project_management_redux/project_management_action.dart';
import 'package:redux/redux.dart';

final projectManagementReducer = combineReducers<ProjectManagementState>([
  TypedReducer<ProjectManagementState, FetchProjectListAction>(_fetchingProjectListState),
  TypedReducer<ProjectManagementState, ClearProjectListAction>(_clearProjectListState),
  TypedReducer<ProjectManagementState, ErrorFetchProjectListAction>(_errorProjectListState),
  TypedReducer<ProjectManagementState, SetProjectListAction>(_setProjectListState),
  TypedReducer<ProjectManagementState, DeleteProjectAction>(_deleteProjectState),
  TypedReducer<ProjectManagementState, AddProjectAction>(_addProjectState),

  TypedReducer<ProjectManagementState, AddSelectedEmployeeAction>(_addSelectedEmployeeState),
  TypedReducer<ProjectManagementState, ClearSelectedEmployeeListAction>(_clearSelectedEmployeeListState),
  TypedReducer<ProjectManagementState, DeselectSelectEmployeeAction>(_deleteSelectedEmployeeState),

  TypedReducer<ProjectManagementState, SetProjectNameAction>(_addProjectNameState),
  TypedReducer<ProjectManagementState, DeleteProjectNameAction>(_deleteProjectNameState),
]);

ProjectManagementState _fetchingProjectListState(ProjectManagementState state, FetchProjectListAction action) {
  return state.copyWith(loadingStatus: LoadingStatus.loading);
}

ProjectManagementState _errorProjectListState(
    ProjectManagementState state, ErrorFetchProjectListAction action) {
  return state.copyWith(loadingStatus: LoadingStatus.error, errorMessage: action.errorStr);
}

ProjectManagementState _setProjectListState(ProjectManagementState state, SetProjectListAction action) {
  return state.setProjectList(receivedList: action.projectList, status: LoadingStatus.success, errorMessage: '');
}

ProjectManagementState _clearProjectListState(ProjectManagementState state, ClearProjectListAction action) {
  return state.clearProjectList();
}

ProjectManagementState _deleteProjectState(ProjectManagementState state, DeleteProjectAction action) {
  return state.deleteProject(project: action.project);
}

ProjectManagementState _addProjectState(ProjectManagementState state, AddProjectAction action) {
  return state.addProject(project: action.project);
}

ProjectManagementState _addSelectedEmployeeState(ProjectManagementState state, AddSelectedEmployeeAction action) {
  return state.selectSelectedEmployee(user: action.user);
}

ProjectManagementState _deleteSelectedEmployeeState(ProjectManagementState state, DeselectSelectEmployeeAction action) {
  return state.deselectSelectedEmployee(user: action.user);
}


ProjectManagementState _clearSelectedEmployeeListState(ProjectManagementState state, ClearSelectedEmployeeListAction action) {
  return state.clearSelectedEmployeeList();
}

ProjectManagementState _addProjectNameState(ProjectManagementState state, SetProjectNameAction action) {
  return state.setProjectName(name: action.name);
}

ProjectManagementState _deleteProjectNameState(ProjectManagementState state, DeleteProjectNameAction action) {
  return state.deleteProjectName();
}
