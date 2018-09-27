import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/actions/actions.dart';
import 'package:flutter_mm_hrmangement/redux/reducers/app_reducer.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/home_page.dart';
import 'package:flutter_mm_hrmangement/ui/onboarding_page/onboarding_page.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/signin_page.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

//void main() => run();
void main() => run();

Future run() async {
  runApp(new Splash());

  var aithUser = await _init();
  runApp(new App(aithUser));
}

Future<AuthUser> _init() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedMmid = prefs.getString(LOGGED_IN_USER_MMID) ?? "";
  String savedPassword = prefs.getString(LOGGED_IN_USER_PASSWORD) ?? "";
  bool isOnboarded = prefs.getBool(ONBOARDING_FINISHED) ?? false;

  if (isOnboarded) {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('pinCollection')
        .where('mmid', isEqualTo: '$savedMmid')
        .getDocuments();

    if (querySnapshot.documents.length > 0) {
      String fireStorePin = querySnapshot.documents[0]['pin'] as String;
      if (fireStorePin == savedPassword) {
        QuerySnapshot userQuerySnapshot = await Firestore.instance
            .collection('userCollection')
            .where('mmid', isEqualTo: '$savedMmid')
            .getDocuments();

        User user = User.fromJson(userQuerySnapshot.documents[0]);
        return AuthUser(isOnboarded,
            savedPassword.isNotEmpty && savedMmid.isNotEmpty, user);
      } else {
        return AuthUser(
            isOnboarded,
            savedPassword.isNotEmpty && savedMmid.isNotEmpty,
            User.nullObject());
      }
    } else {
      return AuthUser(isOnboarded,
          savedPassword.isNotEmpty && savedMmid.isNotEmpty, User.nullObject());
    }
  } else {
    return AuthUser(isOnboarded, false, User.nullObject());
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Container(
              color: Colors.white,
              child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: new FlutterLogo(colors: Colors.pink, size: 80.0)),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
                  child: new Text("Leave Management",
                      style: new TextStyle(fontSize: 32.0))),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Center(
                  child:
                      new Text("for Mutual Mobile", style: new TextStyle(fontSize: 16.0))),
          )
        ], mainAxisAlignment: MainAxisAlignment.center),
            )),
        theme: new ThemeData(
          primarySwatch: Colors.deepPurple,
          canvasColor: Colors.transparent,
        ));
  }
}

class App extends StatefulWidget {
  AuthUser authUser;

  @override
  _AppState createState() => new _AppState();

  App(this.authUser) {
    Navigation.initPaths();
  }
}

class _AppState extends State<App> {
  //REDUX
  final store = new Store<AppState>(
    // new
    appReducer, // new
    initialState: AppState.initial(),
    distinct: true, // new
    middleware: [], // new
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: new MaterialApp(
          title: 'MM Leave Management',
          debugShowCheckedModeBanner: false,
          theme: new ThemeData(
            primarySwatch: Colors.deepPurple,
            canvasColor: Colors.transparent,
          ),
          home: FutureBuilder(
            future: Future.delayed(Duration(microseconds: 1)),
            builder: (BuildContext context, snapshot) {
              if (!widget.authUser.isOnboarded) {
                return OnBoardingPage();
              }else if (widget.authUser.isLoggedIn) {
                store.dispatch(LoginUserAction(widget.authUser.user));
                return HomePage();
              } else {
                return SignInPage();
              }
            },
          )
      ),
    );
  }
}

class AuthUser {
  bool isOnboarded = false;
  bool isLoggedIn = false;
  User user = User.nullObject();

  AuthUser(this.isOnboarded, this.isLoggedIn, this.user);
}
