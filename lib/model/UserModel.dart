import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class User{

  User({
    @required this.mmid,
    @required this.name,
    @required this.avatar,
    @required this.authLevel,
    @required this.department,
    @required this.currentProject,
    @required this.remainingLeaves,
    @required this.totalLeaves,
  });

  String mmid;
  String name;
  String avatar;
  String authLevel;
  String department;
  String currentProject;
  int remainingLeaves;
  int totalLeaves;

  factory User.fromJson(DocumentSnapshot snapShot) {
    return User(
      mmid: snapShot['mmid'] as String,
      name: snapShot['name'] as String,
      avatar: snapShot['avatar'] as String,
      authLevel: snapShot['authLevel'] as String,
      department: snapShot['department'] as String,
      currentProject: snapShot['currentProject'] as String,
      remainingLeaves: snapShot['remainingLeaves'] as int,
      totalLeaves: snapShot['totalLeaves'] as int,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User &&
              runtimeType == other.runtimeType &&
              mmid == other.mmid &&
              name == other.name &&
              authLevel == other.authLevel &&
              department == other.department &&
              currentProject == other.currentProject &&
              avatar == other.avatar &&
              remainingLeaves == other.remainingLeaves &&
              totalLeaves == other.totalLeaves;

  @override
  int get hashCode =>
      mmid.hashCode ^
      name.hashCode ^
      authLevel.hashCode ^
      department.hashCode ^
      currentProject.hashCode ^
      avatar.hashCode ^
      remainingLeaves.hashCode ^
      totalLeaves.hashCode;


}