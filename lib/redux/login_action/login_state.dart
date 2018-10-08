
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:meta/meta.dart';

@immutable
class LoginState {
  LoginState({this.user});

  @required final User user;

  factory LoginState.initial() {
    return LoginState(
        user: null
    );
  }

  LoginState setLoggedInUser({User user})
  {
    return LoginState(user: user ?? this.user,);
  }
}