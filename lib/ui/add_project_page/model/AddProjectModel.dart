import 'package:flutter_mm_hrmangement/model/UserModel.dart';

class AddProjectModel {
  List<User> team = [];
  String projectName;

  int get teamCount => team.length;

  void add(User user) {
    if(!team.contains(user)) team.add(user);
  }

  void setProjectName(String name) {
    projectName = name;
  }
}