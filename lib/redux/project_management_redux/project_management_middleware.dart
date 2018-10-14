import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mm_hrmangement/model/ProjectModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/project_management_redux/project_management_action.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class ProjectManagementMiddleware extends MiddlewareClass<AppState> {
  @override
  Future<Null> call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    if (action is FetchProjectListAction) {
      try {
        store.dispatch(ClearProjectListAction());
        List<Project> projectList = await _fetchProjectList(next);
        print('ProjectManagementMiddleware.call $action list size ${projectList.length}');
        next(SetProjectListAction(projectList: projectList));
      } catch (e) {
        next(ErrorFetchProjectListAction(errorStr: e.toString()));
      }
    }

    if (action is AddProjectAction) {
      try {
        await _addProject(store.state.projectManagementState.selectedEmployeeList,
            store.state.projectManagementState.projectName);
      } catch (e) {
        next(ErrorFetchProjectListAction(errorStr: e.toString()));
      }
    }
  }

  Future<List<Project>> _fetchProjectList(NextDispatcher next) async{
    List<Project> projectList = [];
    await Firestore.instance.runTransaction((Transaction transaction) async {
      var snapshot = await Firestore.instance.collection("projectCollection").getDocuments();
      snapshot.documents.forEach((snapshot) {
        Project project = Project.fromJson(snapshot.data);
        projectList.add(project);
      });
    });
    return projectList;
  }

  Future<void> _addProject(List<User> selectedEmployeeList, String projectName) async{
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('projectCollection');

      var team = selectedEmployeeList.map((user) {
        Map<String,dynamic> projectUserMap = new Map<String,dynamic>();
        projectUserMap["mmid"] = user.mmid;
        projectUserMap["name"] = user.name;
        projectUserMap["isManager"] = (user.role.id == 0 || user.role.id == 1 || user.role.id == 4 || user.role.id == 5 || user.role.id == 6) ? true: false;
        print(projectUserMap);
        return projectUserMap;
      }).toList();

      await reference.document(projectName).setData({
        "name": "$projectName",
        "team": team,
      });
    });
  }
}
