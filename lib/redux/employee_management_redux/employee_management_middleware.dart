import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mm_hrmangement/model/ProjectModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/employee_management_redux/employee_management_action.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class EmployeeManagementMiddleware extends MiddlewareClass<AppState> {
  @override
  Future<Null> call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is FetchEmployeeListAction) {
      try {
        store.dispatch(ClearEmployeeListAction());
        List<User> employeeList = await _fetchEmployeeList(next);
        print('EmployeeManagementMiddleware.call $action employee list size - ${employeeList.length}');
        store.dispatch(SetEmployeeListAction(employeeList: employeeList));
      } catch (e) {
        store.dispatch(ErrorFetchEmployeeListAction(errorStr: e.toString()));
      }
    }

    if (action is DeleteEmployeeAction) {
      try {
        _deleteEmployee(action.user);
      } catch (e) {
        store.dispatch(ErrorFetchEmployeeListAction(errorStr: e.toString()));
      }
    }

    if (action is AddEmployeeAction) {
      try {
        _addEmployee(action.user, action.password);
      } catch (e) {
        store.dispatch(ErrorFetchEmployeeListAction(errorStr: e.toString()));
      }
    }

    next(action);
  }

  Future<List<User>> _fetchEmployeeList(NextDispatcher next) async{
    List<User> employeList = [];
    await Firestore.instance.runTransaction((Transaction transaction) async {
      var snapshot = await Firestore.instance.collection("userCollection").getDocuments();
      snapshot.documents.forEach((snapshot) {
        User user = User.fromJson(snapshot);
        employeList.add(user);
      });
    });
    return employeList;
  }

  Future<void> _deleteEmployee(User user, ) async{
    await Firestore.instance.runTransaction((Transaction transaction) async {
      //Remove from projectCollection
      var projectCollectionSnapshot = await Firestore.instance.collection('projectCollection').document('hyd_pto_planning').get();
      Project project = Project.fromJson(projectCollectionSnapshot.data);
      ProjectUser projectUserToDelete;
      project.team.forEach((projectUser) {
        if(projectUser.mmid == user.mmid) {
          projectUserToDelete = projectUser;
        }
      });
      project.team.remove(projectUserToDelete);
      print(json.encode(project));

      var updatedTeam = project.team.map((projectUser) {
        Map<String,dynamic> projectUserMap = new Map<String,dynamic>();
        projectUserMap["mmid"] = projectUser.mmid;
        projectUserMap["name"] = projectUser.name;
        projectUserMap["isManager"] = projectUser.isManager;
        print(projectUserMap);
        return projectUserMap;
      }).toList();
      await transaction.update(projectCollectionSnapshot.reference, {"team": updatedTeam});

      var snapshot = await Firestore.instance.collection('projectCollection').where('mmid', isEqualTo: '${user.mmid}').getDocuments();
      print('EmployeeManagementMiddleware._deleteEmployee ${snapshot.documents.length}');
      snapshot.documents.forEach( (document) {
        Project project = Project.fromJson(document.data);
        ProjectUser projectUserToDelete;
        project.team.forEach( (projectUser) {
          if(projectUser.mmid == user.mmid) {
            projectUserToDelete = projectUser;
          }
        });

        project.team.remove(projectUserToDelete);

        var updatedTeam = project.team.map( (projectUser) {
          Map<String,dynamic> projectUserMap = new Map<String,dynamic>();
          projectUserMap["mmid"] = projectUser.mmid;
          projectUserMap["name"] = projectUser.name;
          projectUserMap["isManager"] = projectUser.isManager;
          print( " EmployeeManagementMiddleware._deleteEmployee $projectUserMap");
          return projectUserMap;
        }).toList();
        transaction.update(document.reference, {"team": updatedTeam});
      });
    });

    //Remove from userCollection
    CollectionReference userReference = Firestore.instance.collection('userCollection');
    await userReference.document('${user.mmid}').delete();

    //Remove from pinCollection
    CollectionReference pinReference = Firestore.instance.collection('pinCollection');
    await pinReference.document('${user.mmid}').delete();

    //Remove from fcmCollection
    CollectionReference fcmReference = Firestore.instance.collection('fcmCollection');
    await fcmReference.document('${user.mmid}').delete();

  }

  Future<void> _addEmployee(User user, String password) async{
    await Firestore.instance.runTransaction((Transaction transaction) async {
      var role = {
        "id" : user.role.id,
        "title" : "${user.role.title}",
        "shortcut" : "${user.role.shortcut}",
      };

      CollectionReference userCollectionReference = Firestore.instance.collection('userCollection');
      await userCollectionReference.document(user.mmid).setData({
        "mmid": "${user.mmid}",
        "name": "${user.name}",
        "avatar": "",
        "role": role,
        "remainingLeaves": user.remainingLeaves,
        "totalLeaves": user.totalLeaves,
      });
    });


    await Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference pinCollectionReference = Firestore.instance.collection('pinCollection');
      await pinCollectionReference.document(user.mmid).setData({
        "mmid": "${user.mmid}",
        "pin": "$password",
      });

      var snapshot = await Firestore.instance.collection('projectCollection').document('hyd_pto_planning').get();
      Project project = Project.fromJson(snapshot.data);
      print(json.encode(project.team));
      project.team.add(ProjectUser(
          name: '${user.name}',
          mmid: '${user.mmid}',
          isManager: (user.role.id == 0 || user.role.id == 1 || user.role.id == 4 || user.role.id == 5 || user.role.id == 6) ? true: false));
      print(json.encode(project));
      var updatedTeam = project.team.map((projectUser) {
        Map<String,dynamic> projectUserMap = new Map<String,dynamic>();
        projectUserMap["mmid"] = projectUser.mmid;
        projectUserMap["name"] = projectUser.name;
        projectUserMap["isManager"] = projectUser.isManager;
        print(projectUserMap);
        return projectUserMap;
      }).toList();
      await transaction.update(snapshot.reference, {"team": updatedTeam});
    });

    await Firestore.instance.runTransaction((Transaction transaction) async {
      var snapshot = await Firestore.instance.collection('projectCollection').document('hyd_pto_planning').get();
      Project project = Project.fromJson(snapshot.data);
      print(json.encode(project.team));
      project.team.add(ProjectUser(
          name: '${user.name}',
          mmid: '${user.mmid}',
          isManager: (user.role.id == 0 || user.role.id == 1 || user.role.id == 4 || user.role.id == 5 || user.role.id == 6) ? true: false));
      print(json.encode(project));
      var updatedTeam = project.team.map((projectUser) {
        Map<String,dynamic> projectUserMap = new Map<String,dynamic>();
        projectUserMap["mmid"] = projectUser.mmid;
        projectUserMap["name"] = projectUser.name;
        projectUserMap["isManager"] = projectUser.isManager;
        print(projectUserMap);
        return projectUserMap;
      }).toList();
      await transaction.update(snapshot.reference, {"team": updatedTeam});
    });
  }
}
