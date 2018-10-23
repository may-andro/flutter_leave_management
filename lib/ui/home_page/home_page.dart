import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/ui/approve_leave_request/approve_leave_page.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/components/home_container_widget.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return HomeContainerWidget();
  }
}
