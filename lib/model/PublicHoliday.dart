import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class PublicHoliday{

  PublicHoliday({
     this.title,
     this.date,
  });

  @required DateTime date;
  @required String title;

  factory PublicHoliday.fromJson(DocumentSnapshot snapShot) {
    return PublicHoliday(
      title: snapShot['title'] as String,
      date: snapShot['date'] as DateTime ,
    );
  }
}