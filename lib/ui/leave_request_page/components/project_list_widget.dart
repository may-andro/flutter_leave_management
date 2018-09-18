import 'package:flutter/material.dart';

class ProjectListWidget extends StatefulWidget {
  @override
  _ProjectListWidgetState createState() => _ProjectListWidgetState();
}

class _ProjectListWidgetState extends State<ProjectListWidget> {
  final List<String> projects = [
    "Seagate",
    "Bass forecase",
    "Giffy",
    "CSE",
    "Spornado",
    "Skygaurd"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: _createContent());
  }

  _buildCategoryChips() {
    return projects.map((item) {
      return new Chip(
        avatar: new CircleAvatar(
          backgroundColor: Colors.grey.shade800,
          child: new Text(item.substring(0,2),
          style: TextStyle(color: Colors.white),),
        ),
        label: new Text(item),
        labelStyle: TextStyle(color: Colors.white),
        backgroundColor: Colors.black12,
      );
    }).toList();
  }

  Widget _createContent() {
    return Container(
      child: Column(
        children: <Widget>[
          new Text(
            "Select the project your are working on",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: new TextStyle(
                fontWeight: FontWeight.w300,
                letterSpacing: 0.5,
                color: Colors.black38,
                fontSize: 18.0),
          ),

          Padding(
              padding: const EdgeInsets.all(12.0),
          ),

          Padding(
              padding: const EdgeInsets.all(12.0),
              child: new Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                direction: Axis.horizontal,
                children: _buildCategoryChips(),
              )
          ),

          new Padding(padding: new EdgeInsets.all(16.0)),
        ],
      ),
    );
  }
}
