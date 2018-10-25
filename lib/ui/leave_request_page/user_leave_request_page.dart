import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/model/PublicHoliday.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/leave_request_page/components/applied_leave_from_widget.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class LeaveRequestPage extends StatefulWidget {
  @override
  _LeaveRequestPageState createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: new Text(
          "Leave Request",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: createUi(context),
    );
  }

  Widget createUi(BuildContext context) {
    return StoreConnector(
        converter: (Store<AppState> store) => AppliedLeaveViewModel.fromStore(store),
        builder: (BuildContext context, AppliedLeaveViewModel viewModel) {
          return Stack(fit: StackFit.expand, children: <Widget>[
            Container(
                color: Colors.white,
                child: AppliedLeaveFormWidget(viewModel.publicHolidayList)
            )
          ]
          );
        }
    );
  }
}


class AppliedLeaveViewModel {
  final List<PublicHoliday> publicHolidayList;

  AppliedLeaveViewModel({
    @required this.publicHolidayList,
  });

  static AppliedLeaveViewModel fromStore(Store<AppState> store) {
    return new AppliedLeaveViewModel(publicHolidayList: store.state.publicHolidayState.publicHolidayList);
  }
}

