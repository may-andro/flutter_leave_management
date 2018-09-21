import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/model/ProjectModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';

class ListData extends StatelessWidget {
  final Project project;

  ListData({@required this.project});

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        Divider(
          height: 5.5,
        ),
        ListTile(
          title: Text( project.name,
            style: new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                color: Colors.white),
          ),
          subtitle: new Padding(
            padding: new EdgeInsets.only(top: 5.0),
            child: new Text("${project.team.length}",
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300),
            ),
          ),
          leading: CircleAvatar(
            child: Text("Jan",
            style: TextStyle( color: Colors.white),),
            backgroundColor: Colors.black,
          ),

          trailing: IconButton(
            icon: new Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            onPressed: () {

            },
          ),
          onTap: () {},
        )
      ],
    );
  }
}
