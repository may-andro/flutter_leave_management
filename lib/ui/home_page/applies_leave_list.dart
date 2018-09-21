import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/loading_widget.dart';
import 'package:flutter_mm_hrmangement/components/no_data_found_widget.dart';
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/ViewModel.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/leave_item_card_widget.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class AppliedLeaveList extends StatelessWidget {
  final Axis scrollDirection;

  AppliedLeaveList(this.scrollDirection);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
        converter: (Store<AppState> store) => ViewModel.fromStore(store),
        builder: (BuildContext context, ViewModel viewModel) {
          return StreamBuilder(
            stream: Firestore.instance
                .collection("leaveCollection")
                .where('mmid', isEqualTo: '${viewModel.user.mmid}')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
              if (!snapShot.hasData) {
                return LoadingWidget("Fetching data from server");
              } else {
                if (snapShot.data.documents.length == 0) {
                  return NoDataFoundWidget("You have not applied for leaves yet");
                } else {
                  return ListView.builder(
                    itemCount: snapShot.data.documents.length,
                    padding: const EdgeInsets.all(0.0),
                    shrinkWrap: true,
                    scrollDirection: scrollDirection,
                    primary: true,
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot =
                          snapShot.data.documents[index];
                      Leave leave = Leave.fromJson(documentSnapshot);
                      return LeaveCardItems(leave);
                    },
                  );
                }
              }
            },
          );
        });
  }
}
