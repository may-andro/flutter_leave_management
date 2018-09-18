import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mm_hrmangement/ui/add_project_page/select_user_for_project_page.dart';
import 'package:flutter_mm_hrmangement/ui/add_project_page/add_project_page.dart';
import 'package:flutter_mm_hrmangement/ui/dashboard_page/tabs/company_leave_tab_widget.dart';
import 'package:flutter_mm_hrmangement/ui/dashboard_page/home_page.dart';
import 'package:flutter_mm_hrmangement/components/reveal_button.dart';
import 'package:flutter_mm_hrmangement/ui/leave_request_page/leave_request_page.dart';
import 'package:flutter_mm_hrmangement/ui/onboarding_page/onboarding_page.dart';
import 'package:flutter_mm_hrmangement/ui/project_management_page/project_management_page.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/signin_page.dart';
import 'package:flutter_mm_hrmangement/ui/user_management_page/user_management_page.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';

import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/redux/reducers/app_reducer.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/components/login_form.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/components/app_logo.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/styles.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  MyApp() {
    Navigation.initPaths();
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
        ),
        //onGenerateRoute: Navigation.router.generator,
        //home: ProjectManagementPage(),
        //home: LeaveRequestPage(),
        //home: new DashboardPage(title: 'Home'),
        home: SignInPage(),
      ),
    );
  }
}
