import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:flutter_mm_hrmangement/redux/applied_leave_redux/applied_leave_action.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class AppliedLeaveMiddleware extends MiddlewareClass<AppState> {
  @override
  Future<Null> call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is FetchAppliedLeaveAction) {
      try {
        List<Leave> leaveList = await _fetchLeaveData(action.mmid);
        print('AppliedLeaveMiddleware.call $action applied leave list - ${leaveList.length}');
        store.dispatch(SetAppliedLeaveAction(leaveList: leaveList));
      } catch (e) {
        store.dispatch(ErrorAppliedLeaveAction(errorStr: e.toString()));
      }
    }

    next(action);
  }

  Future<List<Leave>> _fetchLeaveData(String mmid) async{
    List<Leave> leaveList = [];
    await Firestore.instance.runTransaction((Transaction transaction) async {
      var snapshot = await Firestore.instance
          .collection("leaveCollection")
          .where('mmid', isEqualTo: mmid)
          .getDocuments();

      snapshot.documents.forEach((snapshot) {
        Leave leave = Leave.fromJson(snapshot);
        leaveList.add(leave);
      });

    });
    return leaveList;
  }
}
