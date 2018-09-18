
import 'dart:ui';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/actions/actions.dart';
import 'package:redux/redux.dart';

final setUserReducer = combineReducers<User>([
  TypedReducer<User, LoginUserAction>(_setUserReducer),
]);

User _setUserReducer(User user, LoginUserAction action) {
  return action.user;
}
