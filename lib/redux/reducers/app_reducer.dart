import 'package:flutter_mm_hrmangement/redux/actions/actions.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/redux/reducers/common_reducer.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/redux/login_reducer.dart';
import 'package:redux/redux.dart' as redux;

AppState appReducer(AppState state, dynamic action) {
  return new AppState(
      loginState: destinationsReducer(state.loginState, action),
      user: setUserReducer(state.user, action)
  );

  //return state.setUser(user: action.user);
}
