import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/ui/dashboard_page/components/applies_leave_list.dart';
import 'package:flutter_mm_hrmangement/ui/dashboard_page/components/profile_header_widget.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';

class PortraitHomePage extends StatelessWidget {

  final Animation<double> _animationReveal;

  PortraitHomePage(this._animationReveal);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.height/2,
              floating: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              forceElevated: innerBoxIsScrolled,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: InkWell(
                  child: ProfileHeaderWidget(_animationReveal),
                  onTap: () {
                    Navigation.navigateTo(context, 'profile_page', transition: TransitionType.fadeIn);
                  },
                ),
              ),
            ),
          ];
        },
        body: AppliedLeaveList(Axis.vertical, _animationReveal)
    );
  }
}
