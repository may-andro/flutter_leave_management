import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/ViewModel.dart';
import 'package:flutter_mm_hrmangement/utility/text_theme.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';


class ProfileHeaderWidget extends StatelessWidget {

  final Animation<double> _animationReveal;

  ProfileHeaderWidget(this._animationReveal);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      converter: (Store<AppState> store) => ViewModel.fromStore(store),
      builder: (BuildContext context, ViewModel viewModel) {
        return Container(
            constraints: BoxConstraints.expand(),
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ProfileCircle(
                  screenSize: MediaQuery.of(context).size,
                  fraction: _animationReveal.value,
                  profileImage: DecorationImage(
                    image: new ExactAssetImage('assets/login.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Opacity(
                    opacity: _animationReveal.value,
                    child: Text(
                      "${viewModel.user.name}",
                      style: TextStyles.headingStyle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Opacity(
                    opacity: _animationReveal.value,
                    child: Text(
                      "${viewModel.user.role.title}",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Opacity(
                        opacity: _animationReveal.value,
                        child: Text(
                          "${viewModel.user.remainingLeaves}",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            letterSpacing: 1.2,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            fontSize: 40.0,
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(5.0),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Opacity(
                            opacity: _animationReveal.value,
                            child: Text(
                              "Leaves",
                              style: Theme.of(context).textTheme.body1,
                            ),
                          ),

                          Opacity(
                            opacity: _animationReveal.value,
                            child: Text(
                              "Available",
                              style: Theme.of(context).textTheme.body1,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ));
      },
    );
  }
}



class ProfileCircle extends StatelessWidget {
  final Size screenSize;
  final double fraction;
  final DecorationImage profileImage;

  ProfileCircle(
      {@required this.screenSize,
        @required this.fraction,
        @required this.profileImage});

  @override
  Widget build(BuildContext context) {
    var squareSize = screenSize.width > screenSize.height
        ? screenSize.height
        : screenSize.width;
    var radius = (squareSize / 3) * fraction;
    return Container(
      width: radius,
      height: radius,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        image: profileImage,
      ),
    );
  }
}
