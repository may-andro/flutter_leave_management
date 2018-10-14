import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mm_hrmangement/model/PublicHoliday.dart';
import 'package:flutter_mm_hrmangement/redux/public_holiday/public_holiday_action.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class PublicHolidayMiddleware extends MiddlewareClass<AppState> {
  @override
  Future<Null> call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is FetchPublicHolidayAction) {
      try {
        store.dispatch(ClearPublicHolidayAction());
        List<PublicHoliday> publicHolidayList = await _fetchPublicHoliday(next);
        store.dispatch(SetPublicHolidayAction(publicHolidayList: publicHolidayList));
      } catch (e) {
        store.dispatch(ErrorLoadingPublicHolidayAction(errorStr: e.toString()));
      }
    }

    if (action is AddPublicHolidayAction) {
      try {
        _addPublicHoliday(action.publicHoliday);
      } catch (e) {
        store.dispatch(ErrorLoadingPublicHolidayAction(errorStr: e.toString()));
      }
    }

    next(action);
  }

  Future<List<PublicHoliday>> _fetchPublicHoliday(NextDispatcher next) async{
    List<PublicHoliday> publicHolidayList = [];
    await Firestore.instance.runTransaction((Transaction transaction) async {
      var snapshot = await Firestore.instance.collection("companyLeaveCollection").getDocuments();
      snapshot.documents.forEach((snapshot) {
        PublicHoliday publicHoliday = PublicHoliday.fromJson(snapshot);
        publicHolidayList.add(publicHoliday);
      });
    });
    return publicHolidayList;
  }

  Future<void> _addPublicHoliday(PublicHoliday publicHoliday) async{
    Firestore.instance.runTransaction((Transaction transaction) async {
      Firestore.instance
          .collection("companyLeaveCollection")
          .document("${publicHoliday.title}")
          .setData({
        "title": "${publicHoliday.title}",
        "date": publicHoliday.date,
      });
    });
  }
}
