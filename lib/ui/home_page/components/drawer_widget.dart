import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/ViewModel.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: new Container(
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0))),
          child: StoreConnector<AppState, ViewModel>(
            converter: (Store<AppState> store) => ViewModel.fromStore(store),
            builder: (BuildContext context, ViewModel viewModel) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('${viewModel.user.name}'),
                    subtitle: Text("${viewModel.user.role.title}"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigation.navigateTo(context, 'profile_page', transition: TransitionType.fadeIn);
                    },
                    leading: Icon(Icons.person),
                  ),
                  ListTile(
                    title: Text('Company Leaves'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigation.navigateTo(context, 'public_holiday_management', transition: TransitionType.fadeIn);
                    },
                    leading: Icon(Icons.party_mode),
                  ),

                  getWidgetIfRoleIsHR(viewModel.user, context),

                  getWidgetIfRoleIsLead(viewModel.user, context),

                  new ListTile(
                    title: new Text('Notifications'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    leading: Icon(Icons.notifications),
                  ),

                  new ListTile(
                    title: new Text('Logout'),
                    onTap: () {
                      Navigator.pop(context);
                      logoutUser(context);
                    },
                    leading: Icon(Icons.vpn_key),
                  ),

                ],
              );
            },
          )
      ),
    );
  }

  Widget getWidgetIfRoleIsHR(User user, BuildContext context) {
    if(user.role.id == 1 || user.role.id == 0) {
      return ListTile(
        title: new Text('Employee Management'),
        onTap: () {
          Navigator.pop(context);
          Navigation.navigateTo(context, 'user_management',
              transition: TransitionType.fadeIn);
        },
        leading: Icon(Icons.person_add),
      );
    } else {
      return Container();
    }
  }

  Widget getWidgetIfRoleIsLead(User user, BuildContext context) {
    if(user.role.id == 5 || user.role.id == 6 || user.role.id == 0) {
      return ListTile(
        title: Text('Project Management'),
        leading: Icon(Icons.work),
        onTap: () {
          Navigator.pop(context);
          Navigation.navigateTo(context, 'project_management',
              transition: TransitionType.fadeIn);
        },
      );
    } else {
      return Container();
    }
  }

  void logoutUser(BuildContext context) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(LOGGED_IN_USER_MMID, "");
    sharedPreferences.setString(LOGGED_IN_USER_PASSWORD, "");
    Navigation.navigateTo(context, 'signin', replace: true, transition: TransitionType.fadeIn);
  }
}
