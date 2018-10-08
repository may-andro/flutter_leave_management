import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/ViewModel.dart';
import 'package:flutter_mm_hrmangement/ui/profile_page/components/diagonally_cut_colored_image.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

class FriendDetailHeader extends StatelessWidget {
  static const BACKGROUND_IMAGE = 'assets/login.jpg';

  Widget _buildDiagonalImageBackground(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return StoreConnector<AppState, ViewModel>(
      converter: (Store<AppState> store) => ViewModel.fromStore(store),
      builder: (BuildContext context, ViewModel viewModel) {
        return DiagonallyCutColoredImage(
          new Image.asset(
            BACKGROUND_IMAGE,
            width: screenWidth,
            height: 280.0,
            fit: BoxFit.cover,
          ),
          color: const Color(0xBB8338f4),
        );
      },
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      backgroundImage: new AssetImage('assets/login.jpg'),
      radius: 50.0,
    );
  }

  Widget _buildFollowerInfo(TextTheme textTheme) {
    var followerStyle =
        textTheme.subhead.copyWith(color: const Color(0xBBFFFFFF));

    return new Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text('90 Following', style: followerStyle),
          new Text(
            ' | ',
            style: followerStyle.copyWith(
                fontSize: 24.0, fontWeight: FontWeight.normal),
          ),
          new Text('100 Followers', style: followerStyle),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        _buildDiagonalImageBackground(context),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildAvatar(),
            _buildFollowerInfo(textTheme),
          ],
        ),
      ],
    );
  }
}
