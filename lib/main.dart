import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  MyApp() {
    Navigation.initPaths();
  }

  Future<AuthUser> isOnboardingANdLoggingFinished() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedMmid = prefs.getString(LOGGED_IN_USER_MMID) ?? "";
    String savedPassword = prefs.getString(LOGGED_IN_USER_PASSWORD) ?? "";
    bool isOnboarded = prefs.getBool(ONBOARDING_FINISHED) ?? false;

    if(isOnboarded) {
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection('pinCollection')
          .where('mmid', isEqualTo: '$savedMmid')
          .getDocuments();

      if( querySnapshot.documents.length > 0) {
        String fireStorePin = querySnapshot.documents[0]['pin'] as String;
        if(fireStorePin == savedPassword) {
          QuerySnapshot userQuerySnapshot = await Firestore.instance
              .collection('userCollection')
              .where('mmid', isEqualTo: '$savedMmid')
              .getDocuments();

          User user = User.fromJson(userQuerySnapshot.documents[0]);
          return AuthUser(isOnboarded, savedPassword.isNotEmpty && savedMmid.isNotEmpty, user);
        } else {
          return AuthUser(isOnboarded, savedPassword.isNotEmpty && savedMmid.isNotEmpty, User.nullObject());
        }
      } else {
        return AuthUser(isOnboarded, savedPassword.isNotEmpty && savedMmid.isNotEmpty, User.nullObject());
      }
    } else {
      return AuthUser(isOnboarded, false, User.nullObject());
    }
  }

  //REDUX
  final store = new Store<AppState>(                            // new
    appReducer,                                                 // new
    initialState: AppState.initial(),
    distinct: true,// new
    middleware: [],                                             // new
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return StoreProvider(
      store: store,
      child: new MaterialApp(
        title: 'MM Leave Management',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.red,
          canvasColor: Colors.transparent,
        ),
        home: FutureBuilder(
          future: isOnboardingANdLoggingFinished(),
          builder: (BuildContext context, AsyncSnapshot<AuthUser> snapshot) {
            if (snapshot.hasData) {
              if(!snapshot.data.isOnboarded) {
                return OnBoardingPage();
              } else if(snapshot.data.isLoggedIn) {
                store.dispatch(LoginUserAction(snapshot.data.user));
                return HomePage();
              } else {
                return SignInPage();
              }
            }
            return Container();
          },
        )
      ),
    );
  }
}

class AuthUser{
  bool isOnboarded = false;
  bool isLoggedIn = false;
  User user = User.nullObject();
  AuthUser(this.isOnboarded, this.isLoggedIn, this.user);
}