import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Project{

  Project({
    @required this.name,
    @required this.team,
    @required this.lead,
    @required this.manager,
  });

  List<String> team;
  List<String> lead;
  List<String> manager;
  String name;

  factory Project.fromJson(DocumentSnapshot snapShot) {
    return Project(
      name: snapShot['name'] as String,
      team: snapShot['team'].cast<String>() ,
      manager: snapShot['manager'].cast<String>() ,
      lead: snapShot['lead'].cast<String>() ,
    );
  }
}