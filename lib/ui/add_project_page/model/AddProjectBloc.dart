import 'dart:async';

import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/ui/add_project_page/model/AddProjectModel.dart';

class AddProjectBloc{
  AddProjectModel _addProjectModel = new AddProjectModel();


  Sink<User> get addition => additionController.sink;

  final additionController = StreamController<User>();




  Stream<int> get itemCount => subject.stream;
  final subject = StreamController<int>();

  Stream<List<User>> get user => subjectList.stream;
  final subjectList = StreamController<List<User>>();


  AddProjectBloc() {
    additionController.stream.listen(handle);
  }
  void handle(User user) {
    _addProjectModel.add(user);
    subject.add(_addProjectModel.teamCount);
  }
}