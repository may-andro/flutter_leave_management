import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mm_hrmangement/model/RoleModel.dart';
import 'package:meta/meta.dart';

class User {
  User({
    @required this.mmid,
    @required this.name,
    @required this.avatar,
    @required this.role,
    @required this.remainingLeaves,
    @required this.totalLeaves,
  });

  String mmid;
  String name;
  String avatar;
  Role role;
  int remainingLeaves;
  int totalLeaves;

  factory User.nullObject() {
    return User(
        mmid: null,
        name: null,
        avatar: null,
        role: null,
        remainingLeaves: null,
        totalLeaves: null);
  }

  factory User.fromJson(DocumentSnapshot snapShot) {
    return User(
      mmid: snapShot['mmid'] as String,
      name: snapShot['name'] as String,
      avatar: snapShot['avatar'] as String,
      role: Role.fromJsonUserModel(snapShot),
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
          role == other.role &&
          avatar == other.avatar &&
          remainingLeaves == other.remainingLeaves &&
          totalLeaves == other.totalLeaves;

  @override
  int get hashCode =>
      mmid.hashCode ^
      name.hashCode ^
      role.hashCode ^
      avatar.hashCode ^
      remainingLeaves.hashCode ^
      totalLeaves.hashCode;
}
