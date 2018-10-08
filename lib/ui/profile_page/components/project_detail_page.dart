import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/app_bar_widget.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/ViewModel.dart';
import 'package:flutter_mm_hrmangement/ui/profile_page/components/detail_header_widget.dart';
import 'package:flutter_mm_hrmangement/ui/profile_page/components/edit_pin_form_widget.dart';
import 'package:flutter_mm_hrmangement/ui/public_holiday_management/add_public_holiday_page/add_public_holiday_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';


class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget("Edit Pin"),
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: SingleChildScrollView(child: createContent()),
              )
            ],
          ),
        )
    );
  }

  Widget createContent(){
    return Column(
      children: <Widget>[
        EditPinFormWidget()
      ],
    );
  }
}