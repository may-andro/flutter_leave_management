import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/loading_widget.dart';
import 'package:flutter_mm_hrmangement/components/no_data_found_widget.dart';
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:flutter_mm_hrmangement/model/loading_status.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/leave_request_page/user_leave_detail_page.dart';
import 'package:flutter_mm_hrmangement/utility/text_theme.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

class AppliedLeaveList extends StatelessWidget {
  final Axis scrollDirection;
  Animation<double> _animationReveal;

  AppliedLeaveList(this.scrollDirection,
      this._animationReveal);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppliedLeaveViewModel>(
        converter: (Store<AppState> store) => AppliedLeaveViewModel.fromStore(store),
        builder: (BuildContext context, AppliedLeaveViewModel viewModel) {
          print('AppliedLeaveList.build ${viewModel.loadingStatus}');
          switch(viewModel.loadingStatus) {
            case LoadingStatus.loading: return LoadingWidget('Fetching leaves');
            case LoadingStatus.idle: return LoadingWidget('Fetching idle');
            case LoadingStatus.error: return NoDataFoundWidget('Fetching error');
            case LoadingStatus.failure: return NoDataFoundWidget('Fetching failed');
            case LoadingStatus.success: return showContent(viewModel);
            case LoadingStatus.loading: return LoadingWidget('Fetching leaves');
            default: return LoadingWidget('Fetching leaves');
          }
        });
  }


  Widget showContent(AppliedLeaveViewModel viewModel) {
    if(viewModel.leaveList.length > 0) {
      return ListView.builder(
        itemCount: viewModel.leaveList.length,
        padding: const EdgeInsets.all(0.0),
        shrinkWrap: true,
        scrollDirection: scrollDirection,
        primary: true,
        itemBuilder: (context, index) {
          return ListItemWidget(leave: viewModel.leaveList[index],
              animationReveal: _animationReveal);
        },
      );
    } else {
      return NoDataFoundWidget(
          "You have not applied for leaves yet");
    }
  }
}

class ListItemWidget extends StatelessWidget {
  final Leave leave;
  final Animation<double> animationReveal;

  ListItemWidget({@required this.leave,
  @required this.animationReveal});

  BoxDecoration _buildShadowAndRoundedCorners() {
    return BoxDecoration(
      color: Colors.blueGrey,
      borderRadius: BorderRadius.circular(4.0),
      boxShadow: <BoxShadow>[
        BoxShadow(
          spreadRadius: 0.0,
          blurRadius: 0.0,
          color: Colors.blueGrey,
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: animationReveal.value,
      child: Container(
        padding: const EdgeInsets.all(2.0),
        margin: EdgeInsets.symmetric(horizontal: (animationReveal.value*12.0), vertical: animationReveal.value*4.0),
        decoration: _buildShadowAndRoundedCorners(),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    LeaveDetailPage(leave),
              ),
            );
          },
          title: Text(
            leave.typeOfLeave,
            style: TextStyles.titleStyle,
          ),
          subtitle: new Padding(
            padding: new EdgeInsets.only(top: 5.0),
            child: new Text( leave.isSingleDayLeave ? "${DateFormat.MMMMd().format(DateTime.fromMicrosecondsSinceEpoch(leave.startDate.millisecondsSinceEpoch * 1000))}" :
              "${DateFormat.MMMMd().format(DateTime.fromMicrosecondsSinceEpoch(leave.startDate.millisecondsSinceEpoch * 1000))} - ${DateFormat.MMMMd().format(DateTime.fromMicrosecondsSinceEpoch(leave.endDate.millisecondsSinceEpoch * 1000))}",
              style: TextStyles.captionStyle,
            ),
          ),
          leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: getAvatar(leave.typeOfLeave),
                onPressed: () {},
              )),
          trailing: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: getStatusIcon(leave.status),
                onPressed: () {},
              ),
          )
      ),
      ),
    );
  }


  getStatusIcon(int status) {
    switch (status) {
      case 0:
        return Icon(
          Icons.error_outline,
          color: Colors.blueGrey.shade400,
        );
      case 1:
        return Icon(
          Icons.done,
          color: Colors.green,
        );
      case 2:
        return Icon(
          Icons.clear,
          color: Colors.redAccent,
        );

      default: return Icon(
        Icons.clear,
        color: Colors.redAccent,
      );
    }
  }

  getAvatar(String leaveType) {
    switch (leaveType) {
      case 'Vacation and Family':
        return Icon(
          Icons.flight_takeoff,
          color: Colors.blueGrey,
        );
      case 'Sick Leave/ Emergency Leave':
        return Icon(
          Icons.local_hospital,
          color: Colors.blueGrey,
        );
      case 'Work from home':
        return Icon(
          Icons.work,
          color: Colors.blueGrey,
        );
      default: return Icon(
        Icons.hot_tub,
        color: Colors.blueGrey,
      );
    }
  }
}


class AppliedLeaveViewModel {
  final List<Leave> leaveList;
  final LoadingStatus loadingStatus;

  AppliedLeaveViewModel({
    this.leaveList,
    this.loadingStatus
  });

  static AppliedLeaveViewModel fromStore(Store<AppState> store) {
    return AppliedLeaveViewModel(leaveList: store.state.appliedLeaveState.leaveList,
        loadingStatus: store.state.appliedLeaveState.loadingStatus);
  }
}

