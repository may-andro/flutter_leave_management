import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/model/PublicHoliday.dart';
import 'package:flutter_mm_hrmangement/redux/public_holiday/public_holiday_action.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:path/path.dart';

abstract class BaseRevealAndAnimateFunction{

  Future<dynamic> animateProgress();

  Future<void> revealProgress();
}

class AddHolidayCallbacks extends BaseRevealAndAnimateFunction{

  String _title;
  DateTime _date;
  BuildContext context;

  AddHolidayCallbacks(this._title, this._date, this.context);

  @override
  Future<dynamic> animateProgress() async{
    if(_title.isEmpty) {
      return 'Holiday name can not bt empty';
    } else {
      await Firestore.instance.runTransaction((Transaction transaction) async {
        Firestore.instance
            .collection("companyLeaveCollection")
            .document("$_title")
            .setData({
          "title": "$_title",
          "date": _date,
        }).then((value) {
          var publicHoliday = PublicHoliday(
            title: _title,
            date: _date,
          );
          var store = StoreProvider.of<AppState>(context);
          store.dispatch(SetPublicHolidayAction(publicHolidayList: [publicHoliday]));
        });
      });
      return '';
    }
  }



  @override
  Future<void> revealProgress() async{
    return Navigator.pop(context);
  }

}

