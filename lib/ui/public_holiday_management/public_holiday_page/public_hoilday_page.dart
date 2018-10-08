import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/app_bar_widget.dart';
import 'package:flutter_mm_hrmangement/components/no_data_found_widget.dart';
import 'package:flutter_mm_hrmangement/model/PublicHoliday.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/public_holiday/public_holiday_action.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/public_holiday_management/components/public_holiday_list_widget.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class PublicHolidayPage extends StatefulWidget {
  @override
  _PublicHolidayPageState createState() => _PublicHolidayPageState();
}

class _PublicHolidayPageState extends State<PublicHolidayPage> with TickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AnimationController _screenController;
  Animation<double> _animationReveal;

  @override
  void initState() {
    super.initState();

    _screenController = new AnimationController(
        duration: new Duration(seconds: 1), vsync: this);

    _animationReveal = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _screenController, curve: Curves.decelerate));

    _screenController.forward();
  }

  @override
  void dispose() {
    _screenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PublicHolidayViewModel>(
        converter: (Store<AppState> store) => PublicHolidayViewModel.fromStore(store),
        builder: (BuildContext context, PublicHolidayViewModel viewModel) {
          return AnimatedBuilder(
              animation: _screenController,
              builder: (BuildContext context, Widget child) {
                return Scaffold(
                  key: _scaffoldKey,
                  appBar: AppBarWidget(viewModel.screenTitle),
                  body: _createContent(context, viewModel),
                );
              });
        });
  }

  Widget _createContent(BuildContext context, PublicHolidayViewModel viewModel) {
    if (viewModel.publicHolidayList != null && viewModel.publicHolidayList.length > 0) {
      return PublicHolidayList(viewModel.publicHolidayList, (publicHoliday) {
        _deletePublicHolidayFromList(publicHoliday.title);
        var store = StoreProvider.of<AppState>(context);
        store.dispatch(DeletePublicHolidayAction(publicHoliday: publicHoliday));
      }, _animationReveal, viewModel.user.role.id == 1 || viewModel.user.role.id ==  0);
    } else {
      return NoDataFoundWidget("You have not applied for leaves yet");
    }
  }

  Future<void> _deletePublicHolidayFromList(String title) async{
    await Firestore.instance.runTransaction((Transaction transaction) async {
      Firestore.instance
          .collection("companyLeaveCollection")
          .document("$title")
          .delete().then((value) {
        showInSnackBar('$title is deleted from database');
      });
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}

class PublicHolidayViewModel {
  final User user;
  final String screenTitle;
  final List<PublicHoliday> publicHolidayList;

  PublicHolidayViewModel({
    this.screenTitle,
    @required this.user,
    this.publicHolidayList
  });

  static PublicHolidayViewModel fromStore(Store<AppState> store) {
    print('PublicHolidayViewModel.fromStore ${store.state.publicHolidayState.publicHolidayList.length}');
    return PublicHolidayViewModel(screenTitle: 'Company Leaves',user: store.state.loginState.user, publicHolidayList: store.state.publicHolidayState.publicHolidayList);
  }
}


