import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/model/CompanyLeaveModel.dart';

class CompanyListItemWidget extends StatelessWidget {

  CompanyLeave companyLeave;
  CompanyListItemWidget({this.companyLeave});

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        Divider(
          height: 5.5,
        ),
        ListTile(
          title: Text(
            companyLeave.title,
            style: new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                color: Colors.white),
          ),
          subtitle: new Padding(
            padding: new EdgeInsets.only(top: 5.0),
            child: new Text(
              companyLeave.title,
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300),
            ),
          ),
          leading: CircleAvatar(
            child: Text("Jan",
            style: TextStyle( color: Colors.white),),
            backgroundColor: Colors.pink,
          ),
          onTap: () {},
        )
      ],
    );
  }
}
