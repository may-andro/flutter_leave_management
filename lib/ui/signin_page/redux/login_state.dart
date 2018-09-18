
import 'package:flutter_mm_hrmangement/model/loading_status.dart';
import 'package:meta/meta.dart';

@immutable
class LoginState {
  LoginState({this.loadingStatus, this.errorMessage});

  @required final LoadingStatus loadingStatus;
  final String errorMessage;

  factory LoginState.initial() {
    return LoginState(
      loadingStatus: LoadingStatus.idle,
      errorMessage: null
    );
  }

  LoginState setStateData(
      {
        LoadingStatus loadingStatus,
        String errorMessage
      }) {
    return LoginState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }
}