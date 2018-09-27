import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class Project{

  Project({
    @required this.name,
    @required this.team,
  });

  List<ProjectUser> team;
  String name;

  factory Project.fromJson(Map<dynamic, dynamic> parsedJson) {
    var list = parsedJson['team'] as List;
    List<ProjectUser> team = list.map((i) => ProjectUser.fromJson(i)).toList();

    return Project(
      name: parsedJson['name'],
      team: team,
    );
  }


  Map<dynamic, dynamic> toJson() {
    return {
      "name": "$name",
      "team": team
    };
  }

}

class ProjectUser{

  ProjectUser({
    @required this.name,
    @required this.mmid,
    @required this.isManager,
  });


  String name;
  String mmid;
  bool isManager;

  factory ProjectUser.fromJson(Map<dynamic, dynamic> parsedJson) {
    return ProjectUser(
      name: parsedJson['name'],
      mmid: parsedJson['mmid'],
      isManager: parsedJson['isManager'],
    );
  }

  Map toJson() =>
      {
        "mmid": "$mmid",
        "name": "$name",
        "isManager": isManager,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProjectUser &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              mmid == other.mmid &&
              isManager == other.isManager;

  @override
  int get hashCode =>
      name.hashCode ^
      mmid.hashCode ^
      isManager.hashCode;



}

