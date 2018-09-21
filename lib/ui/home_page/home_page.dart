import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/ViewModel.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/applies_leave_list.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/profile_header_widget.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController _screenController;

  Animation<double> _animationReveal;

  double _fraction = 0.0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();


  @override
  void initState() {
    super.initState();
    _screenController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);

    _animationReveal = Tween(begin: 0.0, end: 1.0).animate(_screenController)
      ..addListener(() {
        setState(() {
          _fraction = _animationReveal.value;
        });
      });

    _screenController.forward();

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
        .collection('FCMTokens')
        .document('$savedMmid')
        .setData({
      "token": "$token",
    }).then((string) {
      print("TOken is saved");
    });
  }

  void handleMessage(Map<String, dynamic> message) async {
    //handle the message
    //send user to approve screen
    Navigation.navigateTo(context, 'approve_leave',
        transition: TransitionType.fadeIn);
  }

  @override
  void dispose() {
    _screenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.3;
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[Container(color: Colors.white, child: _buildUI())],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.deepPurple,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                _modalBottomSheetMenu();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        icon: const Icon(Icons.add),
        label: const Text('Request for leave'),
        backgroundColor: Colors.black87,
        onPressed: () {
          Navigation.navigateTo(context, 'leave_request',
              transition: TransitionType.fadeIn);
        },
      ),
    );
  }

  Widget _buildUI() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    bool isLandscape = orientation == Orientation.landscape;

    if (isLandscape) {
      return _landscapeWidget();
    } else {
      return _portraitWidget();
    }
  }

  Widget _landscapeWidget() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            constraints: BoxConstraints.expand(),
            child: ProfileHeaderWidget(_fraction),
          ),
        ),
        Expanded(
          flex: 1,
          child: SafeArea(
            child: Container(
              constraints: BoxConstraints.expand(),
              child: AppliedLeaveList(Axis.vertical),
            ),
          ),
        ),
      ],
    );
  }

  Widget _portraitWidget() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            constraints: BoxConstraints.expand(),
            color: Colors.blueGrey,
            child: ProfileHeaderWidget(_fraction),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.only(bottom: 22.0),
            constraints: BoxConstraints.expand(),
            color: Colors.white,
            child: AppliedLeaveList(Axis.horizontal),
          ),
        ),
      ],
    );
  }

  void _modalBottomSheetMenu(){
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return new Container(
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
                          subtitle: Text("${viewModel.user.department}"),
                          onTap: () {
                            Navigator.pop(context);
                            //Navigation.navigateTo(context, 'public_holiday_management', transition: TransitionType.fadeIn);
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

                        getWidgetIfRoleIsHR(viewModel.user),

                        getWidgetIfRoleIsLead(viewModel.user),

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
                            logoutUser();
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
    );
  }

  void logoutUser() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(LOGGED_IN_USER_MMID, "");
    sharedPreferences.setString(LOGGED_IN_USER_PASSWORD, "");
    Navigation.navigateTo(context, 'signin', replace: true, transition: TransitionType.fadeIn);
  }

  Widget getWidgetIfRoleIsHR(User user) {
    if(user.authLevel == (AUTHORITY_LEVEL_LIST[1]) || user.authLevel == (AUTHORITY_LEVEL_LIST[3])) {
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

  Widget getWidgetIfRoleIsLead(User user) {
    if( user.authLevel == (AUTHORITY_LEVEL_LIST[2]) || user.authLevel == (AUTHORITY_LEVEL_LIST[3])) {
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
}
