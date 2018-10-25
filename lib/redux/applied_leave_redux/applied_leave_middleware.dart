import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/applied_leave_redux/applied_leave_action.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AppliedLeaveMiddleware extends MiddlewareClass<AppState> {
  @override
  Future<Null> call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is FetchAppliedLeaveAction) {
      try {
        await _fetchLeaveData(action.mmid).then((value) {
          print('AppliedLeaveMiddleware.call $action applied leave list - ${value.length}');
          store.dispatch(SetAppliedLeaveAction(leaveList: value));
        });
      } catch (e) {
        store.dispatch(ErrorAppliedLeaveAction(errorStr: e.toString()));
      }
    }

    if (action is AddLeaveAction) {
      try {
        _addLeaveData(action.leave, action.leaveId).then((value) {
          action.fcmtokenIdList.forEach((tokenId){
            sendNotification(tokenId, action.user, action.leaveId, action.leave);
          });
        });
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

  Future<void> _addLeaveData(Leave leave, String leaveId) async{
    print('AppliedLeaveMiddleware._addLeaveData ${leave.message}');
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference =
      Firestore.instance.collection('leaveCollection');
      await reference.document(leaveId).setData({
        "mmid": "${leave.mmid}",
        "typeOfLeave": "${leave.typeOfLeave}",
        "startDate": leave.startDate,
        "endDate": leave.endDate,
        "isSingleDayLeave": leave.isSingleDayLeave,
        "numberOfDays": leave.numberOfDays,
        "message": "${leave.message}",
        "status": 0,
      });
    });
  }

  void sendNotification(String sendingToken, User user, String leaveId, Leave leave) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var fcm_token = prefs.getString(FIREBASE_FCM_TOKEN);
    var base = 'https://us-central1-mm-leavemanagement.cloudfunctions.net/';
    String dataURL = '$base/sendNotification?'
        'to=${sendingToken}'
        '&fromPushId=$fcm_token'
        '&fromId=$leaveId'
        '&fromName=${user.name}'
        '&fromMessage=${getLeaveMessage(leave.endDate.compareTo(leave.startDate), leave.endDate, leave.startDate, leave.message, leave.typeOfLeave, user.name)}'
        '&isApproved=false'
        '&type=leave_request';
    print(dataURL);
    await http.get(dataURL).then((response) {});
  }
}
