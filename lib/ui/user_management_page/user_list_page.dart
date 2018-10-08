import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/app_bar_widget.dart';
import 'package:flutter_mm_hrmangement/components/list_item_card_widget.dart';
import 'package:flutter_mm_hrmangement/components/no_data_found_widget.dart';
import 'package:flutter_mm_hrmangement/model/ProjectModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/employee_management_redux/employee_management_action.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/user_management_page/components/user_list_widget.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AnimationController _screenController;
  Animation<double> _animationReveal;

  @override
  void initState() {
    super.initState();
    _screenController = new AnimationController(
        duration: new Duration(seconds: 1), vsync: this);

    _animationReveal = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _screenController, curve: Curves.decelerate));

    _screenController.forward();
  }

  @override
  void dispose() {
    _screenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _screenController,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBarWidget("Team Management"),
            body: Container(
              color: Colors.white,
              child: _createContent(context),
            ),
          );
        });
  }


  Widget _createContent(BuildContext context) {
    return StoreConnector<AppState, UserManagementViewModel>(
        converter: (Store<AppState> store) => UserManagementViewModel.fromStore(store),
        builder: (BuildContext context, UserManagementViewModel viewModel) {
          if(viewModel.employeeList.length > 1) {
            return UserListWidget(
              viewModel.employeeList, (user) {
                var store = StoreProvider.of<AppState>(context);
                store.dispatch(DeleteEmployeeAction(user: user));
                showInSnackBar("${user.name} deleted successfully");
                },
                _animationReveal,
                true
            );
          } else {
            return NoDataFoundWidget('No user found');
          }
        });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}

void _showDialog(
    BuildContext context, String message, User user, Function showInSnackBar) {
  var alert = AlertDialog(
    title: Text("Delete employee"),
    content: Text(message),
    actions: <Widget>[
      FlatButton(
        color: Colors.transparent,
        child: Text("Delete"),
        onPressed: () {
          Navigator.pop(context);

          Firestore.instance.runTransaction((Transaction transaction) async {
            CollectionReference reference = Firestore.instance.collection('userCollection');
            await reference.document('${user.mmid}').delete();
          });

          Firestore.instance.runTransaction((Transaction transaction) async {
            CollectionReference reference = Firestore.instance.collection('pinCollection');
            await reference.document('${user.mmid}').delete();
          });

          Firestore.instance.runTransaction((Transaction transaction) async {
            CollectionReference reference = Firestore.instance.collection('fcmCollection');
            await reference.document('${user.mmid}').delete();
          });

          Firestore.instance.runTransaction((transaction) async {
            var snapshot = await Firestore.instance.collection('projectCollection').document('hyd_pto_planning').get();
            Project project = Project.fromJson(snapshot.data);
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
            await transaction.update(snapshot.reference, {"team": updatedTeam});

            showInSnackBar("${user.name} deleted successfully");
          });

          Firestore.instance.runTransaction((transaction) async {
            var snapshot = await Firestore.instance.collection('projectCollection').where('mmid', isEqualTo: '${user.mmid}').getDocuments();
            snapshot.documents.forEach( (document) {
              Project project = Project.fromJson(document.data);
              ProjectUser projectUserToDelete;
              project.team.forEach( (projectUser) {
                if(projectUser.mmid == user.mmid) {
                  projectUserToDelete = projectUser;
                }
              });

              project.team.remove(projectUserToDelete);
              print(json.encode(project));

              var updatedTeam = project.team.map( (projectUser) {
                Map<String,dynamic> projectUserMap = new Map<String,dynamic>();
                projectUserMap["mmid"] = projectUser.mmid;
                projectUserMap["name"] = projectUser.name;
                projectUserMap["isManager"] = projectUser.isManager;
                print(projectUserMap);
                return projectUserMap;
              }).toList();

              transaction.update(document.reference, {"team": updatedTeam});
            });
          });
        },
      )
    ],
  );

  showDialog(context: context, builder: (context) => alert);
}

class UserManagementViewModel {
  final User user;
  final List<User> employeeList;
  UserManagementViewModel({
    @required this.user,
    @required this.employeeList
  });

  static UserManagementViewModel fromStore(Store<AppState> store) {
    return new UserManagementViewModel(user: store.state.loginState.user, employeeList: store.state.employeeManagementState.employeeList);
  }
}
