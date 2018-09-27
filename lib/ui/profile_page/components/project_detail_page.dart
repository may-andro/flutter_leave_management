import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/ViewModel.dart';
import 'package:flutter_mm_hrmangement/ui/profile_page/components/detail_header_widget.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';


class LeaveDetailsPage extends StatefulWidget {

    @override
  _FriendDetailsPageState createState() => new _FriendDetailsPageState();
}

class _FriendDetailsPageState extends State<LeaveDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          const Color(0xFF413070),
          const Color(0xFF2B264A),
        ],
      ),
    );

    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          decoration: linearGradient,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new FriendDetailHeader(),
              new Padding(
                padding: const EdgeInsets.all(24.0),
                child: new UserDetailWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserDetailWidget extends StatelessWidget {

  Widget _buildLocationInfo(TextTheme textTheme, User user) {
    return new Row(
      children: <Widget>[
        new Icon(
          Icons.place,
          color: Colors.white,
          size: 16.0,
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: new Text(
            user.role.title,
            style: textTheme.subhead.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _createCircleBadge(IconData iconData, Color color) {
    return new Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: new CircleAvatar(
        backgroundColor: color,
        child: new Icon(
          iconData,
          color: Colors.white,
          size: 16.0,
        ),
        radius: 16.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return StoreConnector<AppState, ViewModel>(
      converter: (Store<AppState> store) => ViewModel.fromStore(store),
      builder: (BuildContext context, ViewModel viewModel) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              viewModel.user.name,
              style: textTheme.headline.copyWith(color: Colors.white),
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: _buildLocationInfo(textTheme, viewModel.user),
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: new Text(
                'Lorem Ipsum is simply dummy text of the printing and typesetting '
                    'industry. Lorem Ipsum has been the industry\'s standard dummy '
                    'text ever since the 1500s.',
                style:
                textTheme.body1.copyWith(color: Colors.white70, fontSize: 16.0),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: new Row(
                children: <Widget>[
                  _createCircleBadge(Icons.beach_access, theme.accentColor),
                  _createCircleBadge(Icons.cloud, Colors.white12),
                  _createCircleBadge(Icons.shop, Colors.white12),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
