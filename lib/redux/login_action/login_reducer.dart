import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/login_action/actions.dart';
import 'package:flutter_mm_hrmangement/redux/login_action/login_state.dart';
import 'package:redux/redux.dart';

final setUserReducer = combineReducers<LoginState>([
  TypedReducer<LoginState, LoginUserAction>(_setLoginReducer),
  TypedReducer<LoginState, LogoutUserAction>(_setLogoutReducer),
]);

LoginState _setLoginReducer(LoginState state, LoginUserAction action) {
  return state.setLoggedInUser(user: action.user);
}

LoginState _setLogoutReducer(LoginState state, LogoutUserAction action) {
  return state.setLoggedInUser(user: null);
}
