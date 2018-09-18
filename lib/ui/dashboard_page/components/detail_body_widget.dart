import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class DetailBodyWidget extends StatelessWidget {
  Widget _buildLocationInfo(TextTheme textTheme) {
    return new Row(
      children: <Widget>[
        new Icon(
          Icons.place,
          color: Colors.white,
          size: 16.0,
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: StoreConnector<AppState, _ViewModel>(
            converter: (Store<AppState> store) => _ViewModel.fromStore(store),
            builder: (BuildContext context, _ViewModel viewModel) {
              return Text(
                "${viewModel.user.totalLeaves} days",
                style: textTheme.subhead.copyWith(color: Colors.white),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          "Your Leaves",
          style: textTheme.headline.copyWith(color: Colors.white),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: _buildLocationInfo(textTheme),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 16.0),

          child: StoreConnector<AppState, _ViewModel>(
            converter: (Store<AppState> store) => _ViewModel.fromStore(store),
            builder: (BuildContext context, _ViewModel viewModel) {
              return Text(
                'You have ${viewModel.user.remainingLeaves} days of remaining leaves for this year. Plan your leaves in advance to make it hassel free',
                style:
                textTheme.body1.copyWith(color: Colors.white70, fontSize: 16.0),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ViewModel {
  final User user;

  _ViewModel({
    @required this.user,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(user: store.state.user);
  }
}
