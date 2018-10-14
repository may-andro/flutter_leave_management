import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:flutter_mm_hrmangement/model/RoleModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/applied_leave_redux/applied_leave_action.dart';
import 'package:flutter_mm_hrmangement/redux/employee_management_redux/employee_management_action.dart';
import 'package:flutter_mm_hrmangement/redux/login_action/actions.dart';
import 'package:flutter_mm_hrmangement/redux/project_management_redux/project_management_action.dart';
import 'package:flutter_mm_hrmangement/redux/public_holiday/public_holiday_action.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/approve_leave_request/approve_leave_page.dart';
import 'package:flutter_mm_hrmangement/ui/dashboard_page/dashboard_page.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/components/extended_fab_widget.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/components/menu_screen.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/components/zoom_scaffold.dart';
import 'package:flutter_mm_hrmangement/ui/leave_request_page/user_leave_request_page.dart';
import 'package:flutter_mm_hrmangement/ui/project_management/project_management_page.dart';
import 'package:flutter_mm_hrmangement/ui/public_holiday_management/add_public_holiday_page/add_public_holiday_page.dart';
import 'package:flutter_mm_hrmangement/ui/public_holiday_management/public_holiday_page/public_hoilday_page.dart';
import 'package:flutter_mm_hrmangement/ui/user_management_page/user_list_page.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  MenuController menuController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));

    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) async{
        print("onLaunch called");
        handleMessage(msg);
      },
      onResume:  (Map<String, dynamic> msg) async{
        print("onResume called");
        handleMessage(msg);
      },
      onMessage:  (Map<String, dynamic> message) async{
        print("onMessage called $message");
        handleMessage(message);
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true,
            alert: true,
            badge: true
        )
    );

    _firebaseMessaging.onIosSettingsRegistered.listen( (IosNotificationSettings setting) {
      print("onIosSettingsRegistered called");
    });

    _firebaseMessaging.getToken().then((token){
      print("updateToken $token");
      updateFcmToken(token);
    });
  }

  void updateFcmToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(FIREBASE_FCM_TOKEN, token);
    String savedMmid = prefs.getString(LOGGED_IN_USER_MMID) ?? "";
    Firestore.instance
        .collection('fcmCollection')
        .document('$savedMmid')
        .setData({
      "token": "$token",
    }).then((string) {
      print("TOken is saved");
    });
  }

  void handleMessage(Map<dynamic, dynamic> message) async {
    //handle the message
    //send user to approve screen
    print(json.encode(message));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ApproveLeavePage(message['data']),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }


  Menu getMenu(Role role) {
    var list = [
      MenuItem(
        id: 0,
        title: 'Dashboard',
      ),
      MenuItem(
        id: 1,
        title: 'Company Leave',
      ),
    ];

    if(role.id == 1 || role.id == 0) {
      list.add(MenuItem(
        id: 2,
        title: 'Team',
      ));
    }

    if(role.id == 5 || role.id == 6 || role.id == 0) {
      list.add(MenuItem(
        id: 3,
        title: 'Project',
      ));
    }

    list.add(MenuItem(
      id: 4,
      title: 'Logout',
    ));

    return Menu(
      items: list,
    );
  }

  var selectedMenuItemId = 0;

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, HomeViewModel>(
        converter: (Store<AppState> store) => HomeViewModel.fromStore(store),
        builder: (BuildContext context, HomeViewModel viewModel) {
          return ZoomScaffold(
            menuController: menuController,
            menuScreen: MenuScreen(
              menu: getMenu(viewModel.user.role),
              selectedItemId: selectedMenuItemId,
              onMenuItemSelected: (int itemId) {
                setState(() {
                  selectedMenuItemId = itemId;
                });
              },
            ),
            contentScreen: Scaffold(
              key: _scaffoldKey,
              body: SafeArea(
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                        color: Colors.white,
                        child: _buildUI(selectedMenuItemId, context)
                    )
                  ],
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                color: Colors.deepPurple,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        menuController.toggle();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        refreshPage(viewModel);
                      },
                    ),
                  ],
                ),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              floatingActionButton: getFabAccordingToMenuSelection(selectedMenuItemId, viewModel.user.role.id),
            ),
          );
        });
  }

  Widget _buildUI(int selectedMenuItemId, BuildContext context) {
    switch(selectedMenuItemId) {
      case 0: return DashBoardPage();
      case 1: return PublicHolidayPage();
      case 2: return UserManagementPage();
      case 3: return ProjectManagementPage();
      case 4: {
        logoutUser(context);
        return Container(
          color: Colors.transparent,
          child: Center(),
        );
      }
      default: return Center();
    }
  }


  void logoutUser(BuildContext context) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(LOGGED_IN_USER_MMID, "");
    sharedPreferences.setString(LOGGED_IN_USER_PASSWORD, "");

    var store = StoreProvider.of<AppState>(context);
    store.dispatch(LogoutUserAction());
    store.dispatch(ClearAppliedLeaveAction());
    store.dispatch(ClearPublicHolidayAction());
    store.dispatch(ClearSelectedEmployeeListAction());
    store.dispatch(ClearEmployeeListAction());
    store.dispatch(ClearProjectListAction());
    Navigation.navigateTo(context, 'signin', replace: true, transition: TransitionType.fadeIn);
  }

  Widget getFabAccordingToMenuSelection(int selectedMenuItemId, int id) {
    switch(selectedMenuItemId) {
      case 0: return ExtendedFabWidget('Request for leave', () {
        //Navigation.navigateTo(context, 'leave_request', transition: TransitionType.fadeIn);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                LeaveRequestPage(),
          ),
        );
      });
      case 1: return IgnorePointer(
        ignoring: (id != 1),
        child: Opacity(
          opacity: (id == 1) ? 1.0 : 0.0,
          child: ExtendedFabWidget('Add public holiday', () {
            //Navigation.navigateTo(context, 'add_public_holiday', transition: TransitionType.fadeIn);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddPublicHolidayPage(),
              ),
            );
          }),
        ),
      );
      case 2: return ExtendedFabWidget('Add new member', () {
        Navigation.navigateTo(context, 'add_user', transition: TransitionType.fadeIn);
      });
      case 3: return ExtendedFabWidget('Add new project', () {
        Navigation.navigateTo(context, 'select_user_for_project', transition: TransitionType.fadeIn);
      });
      case 4: return ExtendedFabWidget('logout', () {
        Navigation.navigateTo(context, 'select_user_for_project', transition: TransitionType.fadeIn);
      });
      default: return Center();
    }
  }

  void refreshPage(HomeViewModel viewModel) {
    switch(selectedMenuItemId) {
      case 0: return refreshDashboard(viewModel.user.mmid);
      case 1: return refreshPublicHoliday();
      case 2: return refreshUserManagement();
      case 3: return refreshProjectManagement();
      case 4: return null;
      default: return null;
    }
  }

  void refreshDashboard(String mmid) {
    var store = StoreProvider.of<AppState>(context);
    store.dispatch(ClearAppliedLeaveAction());
    store.dispatch(FetchAppliedLeaveAction(mmid: mmid));
  }

  void refreshPublicHoliday() {
    var store = StoreProvider.of<AppState>(context);
    store.dispatch(FetchPublicHolidayAction());
  }

  void refreshUserManagement() {
    var store = StoreProvider.of<AppState>(context);
    store.dispatch(FetchEmployeeListAction());
  }

  void refreshProjectManagement() {
    var store = StoreProvider.of<AppState>(context);
    store.dispatch(FetchProjectListAction());
  }




}

class HomeViewModel {
  final User user;

  final List<Leave> leaveList;

  HomeViewModel({
    @required this.user,
    this.leaveList
  });

  static HomeViewModel fromStore(Store<AppState> store) {
    return HomeViewModel(user: store.state.loginState.user, leaveList: store.state.appliedLeaveState.leaveList);
  }
}
