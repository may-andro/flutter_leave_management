
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/redux/login_state.dart';

class AppState {
  final User user;
  final LoginState loginState;

  AppState({this.user, this.loginState});


  factory AppState.initial() {
    return AppState(
        user: null,
        loginState: LoginState.initial());
  }

  AppState setUser({ User user}) {
    return new AppState(user: user ?? this.user);
  }

  AppState setLoginState({ LoginState loginState}) {
    return new AppState(loginState: loginState ?? this.loginState);
  }
}