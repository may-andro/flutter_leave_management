import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/model/ProjectModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/utility//Theme.dart' as Theme;

class UserListItemWidget extends StatelessWidget {
  final User user;
  final Function showInSnackBar;

  UserListItemWidget({@required this.user, this.showInSnackBar});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(
          height: 5.5,
        ),
        ListTile(
          title: Text(
            user.name,
            style: new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                color: Colors.black87),
          ),
          subtitle: new Padding(
            padding: new EdgeInsets.only(top: 5.0),
            child: new Text(
              user.mmid,
              style: new TextStyle(
                  color: Colors.black38,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300),
            ),
          ),
          leading:
              CircleAvatar(backgroundColor: Colors.deepPurple, child: getAvatar()),
          trailing: IconButton(
            icon: new Icon(
              Icons.delete,
              color: Colors.black87,
            ),
            onPressed: () {
              //delete the user
              _showDialog(
                  context,
                  "Would you like to delete ${user.mmid} from mutual mobile database",
                  user,
                  showInSnackBar);
            },
          ),
          onTap: () {},
        )
      ],
    );
  }

  Widget getAvatar() {
    if (user.avatar.isEmpty) {
      return Text(
        "${user.role.shortcut}",
        style: TextStyle(color: Colors.white),
      );
    } else {
      return Text(
        "${user.avatar.substring(0, 1)}",
        style: TextStyle(color: Colors.white),
      );
    }
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
