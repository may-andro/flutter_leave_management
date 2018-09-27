import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/loading_widget.dart';
import 'package:flutter_mm_hrmangement/components/no_data_found_widget.dart';
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/ViewModel.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
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
                  return NoDataFoundWidget(
                      "You have not applied for leaves yet");
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
                      return ListItemWidget(leave: leave);
                    },
                  );
                }
              }
            },
          );
        });
  }
}

class ListItemWidget extends StatelessWidget {
  final Leave leave;

  ListItemWidget({@required this.leave});

  BoxDecoration _buildShadowAndRoundedCorners() {
    return BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(4.0),
      boxShadow: <BoxShadow>[
        BoxShadow(
          spreadRadius: 0.0,
          blurRadius: 0.0,
          color: Colors.grey,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: _buildShadowAndRoundedCorners(),
      child: ListTile(
        title: Text(
          leave.typeOfLeave,
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.2,
            fontFamily: 'Poppins',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w400,
            fontSize: 20.0,
          ),
        ),
        subtitle: new Padding(
          padding: new EdgeInsets.only(top: 5.0),
          child: new Text(
            "${DateFormat.MMMMd().format(DateTime.fromMicrosecondsSinceEpoch(leave.startDate.millisecondsSinceEpoch * 1000))} - ${DateFormat.MMMMd().format(DateTime.fromMicrosecondsSinceEpoch(leave.endDate.millisecondsSinceEpoch * 1000))}",
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 18.0,
            ),
          ),
        ),
        leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: getAvatar(leave.typeOfLeave),
              onPressed: () {},
            )),
        trailing: IconButton(
          icon: getStatusIcon(leave.status),
          onPressed: () {},
        ),
        onTap: () {},
      ),
    );
  }

  getStatusIcon(int status) {
    switch (status) {
      case 0:
        return Icon(
          Icons.error,
          color: Colors.white70,
        );
      case 1:
        return Icon(
          Icons.done,
          color: Colors.green,
        );
      case 2:
        return Icon(
          Icons.clear,
          color: Colors.redAccent,
        );
    }
  }

  getAvatar(String leaveType) {
    switch (leaveType) {
      case 'Vacation and Family':
        return Icon(
          Icons.hot_tub,
          color: Colors.blueGrey,
        );
      case 'Sick Leave/ Emergency Leave':
        return Icon(
          Icons.healing,
          color: Colors.blueGrey,
        );
      case 'Work from home':
        return Icon(
          Icons.work,
          color: Colors.blueGrey,
        );
    }
  }
}
