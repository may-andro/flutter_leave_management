import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

class ViewModel {
  final User user;

  ViewModel({
    @required this.user,
  });

  static ViewModel fromStore(Store<AppState> store) {
    return new ViewModel(user: store.state.user);
  }
}
