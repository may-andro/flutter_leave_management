import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/model/PublicHoliday.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';
import 'package:flutter_redux/flutter_redux.dart';
import "package:intl/intl.dart";
import 'package:flutter_mm_hrmangement/utility//Theme.dart' as Theme;
import 'package:redux/redux.dart';

class HolidayListItemWidget extends StatelessWidget {
  final PublicHoliday publicHoliday;
  final Function showInSnackBar;

  HolidayListItemWidget({@required this.publicHoliday, this.showInSnackBar});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(
          height: 5.5,
        ),
        ListTile(
          title: Text(
            "${publicHoliday.title}",
            style: new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                color: Colors.black87),
          ),
          subtitle: new Padding(
            padding: new EdgeInsets.only(top: 5.0),
            child: Text(
              "${DateFormat.yMMMMd().format(DateTime.fromMicrosecondsSinceEpoch(publicHoliday.date.millisecondsSinceEpoch * 1000))}",
              style: new TextStyle(
                  color: Colors.black38,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300),
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            child: Text(
              "${publicHoliday.title.substring(0, 1)}",
              style: TextStyle(color: Colors.white),
            ),
          ),
          trailing: StoreConnector<AppState, _ViewModel>(
              converter: (Store<AppState> store) => _ViewModel.fromStore(store),
              builder: (BuildContext context, _ViewModel viewModel) {
                return IgnorePointer(
                  ignoring: (viewModel.user.authLevel == AUTHORITY_LEVEL_LIST[1]) ? true : false,
                  child: Opacity(
                    opacity: (viewModel.user.authLevel == AUTHORITY_LEVEL_LIST[1]) ? 1.0 : 0.0,
                    child: IconButton(
                      icon: new Icon(
                        Icons.delete,
                        color: Colors.black87,
                      ),
                      onPressed: () {
                        //delete the user
                        _showDialog(
                            context,
                            "Would you like to delete ${publicHoliday.title} from public holiday database?",
                            publicHoliday,
                            showInSnackBar);
                      },
                    ),
                  ),
                );
              }),
          onTap: () {},
        )
      ],
    );
  }
}

void _showDialog(BuildContext context, String message,
    PublicHoliday publicHoliday, Function showInSnackBar) {
  var alert = AlertDialog(
    title: Text("Delete employee"),
    content: Text(message),
    actions: <Widget>[
      FlatButton(
        color: Colors.transparent,
        child: Text("Delete"),
        onPressed: () {
          Navigator.pop(context);
          Firestore.instance
              .collection("companyLeaveCollection")
              .document("${publicHoliday.title}")
              .delete()
              .then((string) {
            showInSnackBar("${publicHoliday.title} deleted successfully");
          });
        },
      )
    ],
  );

  showDialog(context: context, builder: (context) => alert);
}

class _ViewModel {
  final User user;

  _ViewModel({
    @required this.user,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(user: store.state.user);
  }
}
