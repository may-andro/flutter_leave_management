import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/ui/dashboard_page/components/applies_leave_list.dart';
import 'package:flutter_mm_hrmangement/ui/dashboard_page/components/profile_header_widget.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';

class LandscapeHomePage extends StatelessWidget {

  final Animation<double> _animationReveal;
  LandscapeHomePage(this._animationReveal);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            constraints: BoxConstraints.expand(),
            child: InkWell(
                child: ProfileHeaderWidget(_animationReveal),
              onTap: () {
                Navigation.navigateTo(context, 'profile_page', transition: TransitionType.fadeIn);
              },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SafeArea(
            child: Container(
              constraints: BoxConstraints.expand(),
              child: AppliedLeaveList(Axis.vertical, _animationReveal)
            ),
          ),
        ),
      ],
    );
  }
}
