import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class PublicHoliday{

  PublicHoliday({
    @required this.title,
    @required this.date,
  });

  DateTime date;
  String title;

  factory PublicHoliday.fromJson(DocumentSnapshot snapShot) {
    return PublicHoliday(
      title: snapShot['title'] as String,
      date: snapShot['date'] as DateTime ,
    );
  }
}