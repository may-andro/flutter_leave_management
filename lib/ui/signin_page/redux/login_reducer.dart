import 'package:flutter_mm_hrmangement/model/loading_status.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/redux/login_action.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/redux/login_state.dart';
import 'package:redux/redux.dart';


final destinationsReducer = combineReducers<LoginState>([
  TypedReducer<LoginState, ReceivedLoginStateChangeAction>(_fetchingLoginState),
]);


LoginState _fetchingLoginState(LoginState loginState, ReceivedLoginStateChangeAction action) {
  return loginState.setStateData(loadingStatus: action.loadingStatus, errorMessage: action.errorMessage);
}
