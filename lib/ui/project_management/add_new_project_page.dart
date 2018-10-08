import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/app_bar_widget.dart';
import 'package:flutter_mm_hrmangement/ui/project_management/components/add_project_formwidget.dart';

class AddNewProjectPage extends StatefulWidget {
  @override
  _AddNewProjectPageState createState() => _AddNewProjectPageState();
}

class _AddNewProjectPageState extends State<AddNewProjectPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _projectName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarWidget("Create Project"),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                AddProjectFormWidget()
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
