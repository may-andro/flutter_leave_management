import 'package:flutter_mm_hrmangement/redux/app_action/app_action.dart';
import 'package:redux/redux.dart';

final changeThemeReducer = combineReducers<int>([
  TypedReducer<int, ChangeThemeAction>(_changeThemeReducer),
]);

int _changeThemeReducer(int id, ChangeThemeAction action) {
  return action.themeId;
}
