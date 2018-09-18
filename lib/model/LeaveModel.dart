import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Leave{

  Leave({
    @required this.mmid,
    @required this.typeOfLeave,
    @required this.startDate,
    @required this.endDate,
    @required this.isSingleDayLeave,
    @required this.numberOfDays,
    @required this.status,
    @required this.message
  });

  String mmid;
  String typeOfLeave;
  DateTime startDate;
  DateTime endDate;
  bool isSingleDayLeave;
  int numberOfDays;
  String message;
  int status;

  factory Leave.fromJson(DocumentSnapshot snapShot) {
    return Leave(
      mmid: snapShot['mmid'] as String,
      typeOfLeave: snapShot['typeOfLeave'] as String,
      startDate: snapShot['startDate'] as DateTime,
      endDate: snapShot['endDate'] as DateTime,
      isSingleDayLeave: snapShot['isSingleDayLeave'] as bool,
      numberOfDays: snapShot['numberOfDays'] as int,
      status: snapShot['status'] as int,
      message: snapShot['message'] as String,
    );
  }
}