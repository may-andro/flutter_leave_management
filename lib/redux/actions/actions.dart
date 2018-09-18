import 'package:flutter_mm_hrmangement/model/UserModel.dart';


abstract class AppAction {
  AppAction();

  String toString() => '$runtimeType';
}

class LoginUserAction extends AppAction{
  final User user;

  LoginUserAction(this.user);
}
