import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import "package:intl/intl.dart";

class AppliedLeaveListItemWidget extends StatelessWidget {
  final Leave leave;
  final Function showInSnackBar;

  AppliedLeaveListItemWidget({this.leave, this.showInSnackBar});

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        Divider(
          height: 5.5,
        ),
        ListTile(
          title: Text(
            leave.typeOfLeave,
            style: new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                color: Colors.grey),
          ),
          subtitle: new Padding(
            padding: new EdgeInsets.only(top: 5.0),
            child: new Text(
              "${leave.numberOfDays} days",
              style: new TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300),
            ),
          ),
          leading: CircleAvatar(
            child: Text("${DateFormat.EEEE().format(DateTime.fromMicrosecondsSinceEpoch(leave.startDate.millisecondsSinceEpoch * 1000))}",
            style: TextStyle( color: Colors.white),),
            backgroundColor: Colors.pink,
          ),
          onTap: () {},
        )
      ],
    );
  }
}
