import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/ProgressHUD.dart';
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/dashboard_page/components/applied_leave_list_item_widget.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

class AppliedLeaveWidget extends StatefulWidget {
  @override
  _AppliedLeaveWidgetState createState() => _AppliedLeaveWidgetState();
}

class _AppliedLeaveWidgetState extends State<AppliedLeaveWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: _createContent(context),
    );
  }

  Widget _createContent(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.fromStore(store),
        builder: (BuildContext context, _ViewModel viewModel) {

          getListData(viewModel.user.mmid);
          return StreamBuilder(
            stream:
                Firestore.instance.collection("leaveCollection").where('mmid', isEqualTo: '${viewModel.user.mmid}').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
              if (!snapShot.hasData) {
                return Center(
                  child: Text(
                    "Getting data",
                    style: TextStyle(color: Colors.deepOrange),
                  ),
                );
              } else {
                if(snapShot.data.documents.length == 0) {
                  return Center(
                    child: Text(
                      "No data",
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapShot.data.documents.length,
                    padding: const EdgeInsets.all(0.0),
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot =
                      snapShot.data.documents[index];
                      Leave leave = Leave.fromJson(documentSnapshot);
                      print("document for leave ${leave}");
                      return AppliedLeaveListItemWidget(
                        leave: leave,
                        showInSnackBar: showInSnackBar,
                      );
                    },
                  );
                }
              }
            },
          );
        });
  }

  void showInSnackBar(String value) {}

  Future getListData(String mmid) async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("leaveCollection").where('mmid', isEqualTo: '$mmid').getDocuments();
    print("document for leave ${querySnapshot.documents.length}");

  }
}

class _ViewModel {
  final User user;

  _ViewModel({
    @required this.user,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(user: store.state.user);
  }
}
