import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Role{

  Role({
    @required this.id,
    @required this.shortcut,
    @required this.title,
  });

  int id;
  String shortcut;
  String title;

  factory Role.fromJson(DocumentSnapshot snapShot) {
    return Role(
      id: snapShot['id'] as int,
      shortcut: snapShot['shortcut'] as String ,
      title: snapShot['title'] as String ,
    );
  }

  factory Role.fromJsonUserModel(DocumentSnapshot snapShot) {
    return Role(
      id: snapShot['role']['id'] as int,
      shortcut: snapShot['role']['shortcut'] as String ,
      title: snapShot['role']['title'] as String ,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Role &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              shortcut == other.shortcut &&
              title == other.title;

  @override
  int get hashCode =>
      id.hashCode ^
      shortcut.hashCode ^
      title.hashCode;

}