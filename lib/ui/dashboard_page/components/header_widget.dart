import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/Profile_Notification.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class HeaderWidget extends StatelessWidget {
  final DecorationImage backgroundImage;
  final DecorationImage profileImage;
  final Animation<double> containerGrowAnimation;

  HeaderWidget({
    this.backgroundImage,
    this.containerGrowAnimation,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final Orientation orientation = MediaQuery.of(context).orientation;
    bool isLandscape = orientation == Orientation.landscape;

    return Container(
        width: screenSize.width,
        height: screenSize.height / 2.5,
        decoration: new BoxDecoration(image: backgroundImage),
        child: new Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
            colors: <Color>[
              const Color.fromRGBO(110, 101, 103, 0.6),
              const Color.fromRGBO(51, 51, 63, 0.9),
            ],
            stops: [0.2, 1.0],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
          )),
          child: isLandscape
              ? new ListView(
                  children: <Widget>[
                    new Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        StoreConnector<AppState, _ViewModel>(
                          converter: (Store<AppState> store) =>
                              _ViewModel.fromStore(store),
                          builder:
                              (BuildContext context, _ViewModel viewModel) {
                            return Text(
                              "${viewModel.user.name}",
                              style: new TextStyle(
                                  fontSize: 30.0,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            );
                          },
                        ),
                        new ProfileNotification(
                          containerGrowAnimation: containerGrowAnimation,
                          profileImage: profileImage,
                        ),
                      ],
                    )
                  ],
                )
              : new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    StoreConnector<AppState, _ViewModel>(
                      converter: (Store<AppState> store) =>
                          _ViewModel.fromStore(store),
                      builder: (BuildContext context, _ViewModel viewModel) {
                        return Text(
                          "${viewModel.user.name}",
                          style: new TextStyle(
                              fontSize: 30.0,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        );
                      },
                    ),
                    new ProfileNotification(
                      containerGrowAnimation: containerGrowAnimation,
                      profileImage: profileImage,
                    ),
                  ],
                ),
        ));
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
