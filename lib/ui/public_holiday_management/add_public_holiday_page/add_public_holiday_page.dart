import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/app_bar_widget.dart';
import 'package:flutter_mm_hrmangement/ui/public_holiday_management/components/add_public_holiday_form_widget.dart';

class AddPublicHolidayPage extends StatefulWidget {
  @override
  _AddPublicHolidayPageState createState() => _AddPublicHolidayPageState();
}

class _AddPublicHolidayPageState extends State<AddPublicHolidayPage>
    with TickerProviderStateMixin {
  final _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
        appBar: AppBarWidget("Add Public Holiday"),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    AddPublicHolidayWidget()
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}
