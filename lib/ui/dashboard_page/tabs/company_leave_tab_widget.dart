import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mm_hrmangement/model/CompanyLeaveModel.dart';
import 'package:flutter_mm_hrmangement/ui/dashboard_page/components/comapny_list_item_widget.dart';

class CompanyLeaveTabWidget extends StatefulWidget {
  @override
  _CompanyLeaveTabWidgetState createState() => _CompanyLeaveTabWidgetState();
}

class _CompanyLeaveTabWidgetState extends State<CompanyLeaveTabWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: loadUi(),
    );
  }
  Widget loadUi() {
    return StreamBuilder(
      stream: Firestore.instance.collection("companyLeaveCollection").snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot> snapShot) {
        if(!snapShot.hasData) {
          return Center(
            child: Text(
              "Getting data",
              style: TextStyle(color: Colors.deepOrange),
            ),
          );
        } else {
          return ListView.builder(
              itemCount: snapShot.data.documents.length,
              padding: const EdgeInsets.all(0.0),
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapShot.data.documents[index];
                CompanyLeave companyLeaveModel = CompanyLeave(ds['title'], ds['date'].toString());
                return CompanyListItemWidget(companyLeave: companyLeaveModel,);
              }
          );
        }
      },
    );
  }
}
