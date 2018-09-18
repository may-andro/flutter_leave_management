import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
              CircleAvatar(backgroundColor: Colors.grey, child: getAvatar()),
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
        "${user.name.substring(0, 1)}",
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
          Firestore.instance
              .collection("userCollection")
              .document("${user.mmid}")
              .delete()
              .then((string) {
            Firestore.instance
                .collection('pinCollection')
                .document('${user.mmid}')
                .delete()
                .then((string) {
              showInSnackBar("${user.mmid} deleted successfully");
            });
          });
        },
      )
    ],
  );

  showDialog(context: context, builder: (context) => alert);
}
