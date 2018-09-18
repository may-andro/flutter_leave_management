import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_mm_hrmangement/components/ProgressHUD.dart';
import 'package:flutter_mm_hrmangement/model/ProjectModel.dart';
import 'package:flutter_mm_hrmangement/ui/project_management_page/components/list_item.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class  ProjectManagementPage extends StatefulWidget {
  @override
  _ProjectManagementPageState createState() => _ProjectManagementPageState();
}

class _ProjectManagementPageState extends State<ProjectManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Project Management"),
      ),

      body: Container(
        color: Colors.white,
        child: _createContent(context),
      ),

      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigation.navigateTo(context, 'select_user_for_project', transition: TransitionType.inFromRight);
        },
        tooltip: 'Add new employee',
        child: new Icon(Icons.add),
      ),
    );
  }


  Future<List> getJsonData() async{
    String url = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
    http.Response response = await http.get(url);
    return json.decode(response.body)['features'];
  }

  Widget _createContent(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection("projectCollection").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (!snapShot.hasData) {
          return FetchingDataWidget();
        } else {
          if (snapShot.hasError) {
            return ErrorInDataWidget();
          } else {
            return ListView.builder(
                itemCount: snapShot.data.documents.length,
                padding: const EdgeInsets.all(0.0),
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapShot.data.documents[index];
                  Project project = Project.fromJson(ds);
                  debugPrint('${project.team}');
                  return  UserListItem(
                    project: project,
                    onTapUserItem: () {
                      setState(() {

                      });
                    },
                  );
                });
          }
        }
      },
    );
  }
}

class UserListItem extends StatefulWidget {

  UserListItem({
    this.project,
    this.onTapUserItem,
  });

  final VoidCallback onTapUserItem;
  final Project project;

  @override
  _UserListItemState createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(
          height: 5.5,
        ),
        ListTile(
          title: Text(widget.project.name,
            style: new TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          subtitle: new Padding(
            padding: new EdgeInsets.only(top: 5.0),
            child: new Text('${widget.project.team.length}',
              style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
            ),
          ),
          leading: CircleAvatar(
            child: Text("${widget.project.name.substring(0, 2)}",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.pink,
          ),
          onTap: widget.onTapUserItem,
        )
      ],
    );
  }
}

class FetchingDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "Getting data",
          style: TextStyle(color: Colors.deepOrange),
        ),
      ),
    );
  }
}

class ErrorInDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "Error data",
          style: TextStyle(color: Colors.deepOrange),
        ),
      ),
    );
  }
}

