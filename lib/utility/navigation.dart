import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/ui/add_project_page/select_user_for_project_page.dart';
import 'package:flutter_mm_hrmangement/ui/add_public_holiday_page/add_public_holiday_page.dart';
import 'package:flutter_mm_hrmangement/ui/add_user_page/add_user_page.dart';
import 'package:flutter_mm_hrmangement/ui/approve_leave_request/approve_leave_page.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/home_page.dart';
import 'package:flutter_mm_hrmangement/ui/leave_request_page/user_leave_request_page.dart';
import 'package:flutter_mm_hrmangement/ui/onboarding_page/onboarding_page.dart';
import 'package:flutter_mm_hrmangement/ui/project_management_page/project_management_page.dart';
import 'package:flutter_mm_hrmangement/ui/public_holiday_page/public_hoilday_page.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/signin_page.dart';
import 'package:flutter_mm_hrmangement/ui/user_management_page/user_management_page.dart';

class Navigation {
  static Router router;

  static void initPaths() {
    router = Router()
      ..define('/', handler: Handler(
          handlerFunc: (BuildContext context, Map<String, dynamic> params) {
            return OnBoardingPage();
          }))
      ..define('signin', handler: Handler(
          handlerFunc: (BuildContext context, Map<String, dynamic> params) {
            return SignInPage();
          }))
      ..define('home', handler: Handler(
          handlerFunc: (BuildContext context, Map<String, dynamic> params) {
            return HomePage();
          }))
      ..define('project_management', handler: Handler(
          handlerFunc: (BuildContext context, Map<String, dynamic> params) {
            return ProjectManagementPage();
          }))
      ..define('select_user_for_project', handler: Handler(
          handlerFunc: (BuildContext context, Map<String, dynamic> params) {
            return SelectUserForProjectPage();
          }))
      ..define('user_management', handler: Handler(
          handlerFunc: (BuildContext context, Map<String, dynamic> params) {
            return UserManagementPage();
          }))
      ..define('add_user', handler: Handler(
          handlerFunc: (BuildContext context, Map<String, dynamic> params) {
            return AddUserPage();
          }))
      ..define('public_holiday_management', handler: Handler(
          handlerFunc: (BuildContext context, Map<String, dynamic> params) {
            return PublicHolidayPage();
          }))
      ..define('add_public_holiday', handler: Handler(
          handlerFunc: (BuildContext context, Map<String, dynamic> params) {
            return AddPublicHolidayPage();
          }))
      ..define('approve_leave', handler: Handler(
          handlerFunc: (BuildContext context, Map<String, dynamic> params) {
            return ApproveLeavePage();
          }))
      ..define('leave_request', handler: Handler(
          handlerFunc: (BuildContext context, Map<String, dynamic> params) {
            return LeaveRequestPage();
          }));

  }

  static void navigateTo(
      BuildContext context,
      String path, {
        bool replace = false,
        TransitionType transition = TransitionType.native,
        Duration transitionDuration = const Duration(milliseconds: 250),
        RouteTransitionsBuilder transitionBuilder,
      }) {
    router.navigateTo(
      context,
      path,
      replace: replace,
      transition: transition,
      transitionDuration: transitionDuration,
      transitionBuilder: transitionBuilder,
    );
  }
}
