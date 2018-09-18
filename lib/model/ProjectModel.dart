import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Project{

  Project({
    @required this.name,
    @required this.team,
  });

  List<String> team;
  String name;

  factory Project.fromJson(DocumentSnapshot snapShot) {
    return Project(
      name: snapShot['name'] as String,
      team: snapShot['team'].cast<String>() ,
    );
  }
}