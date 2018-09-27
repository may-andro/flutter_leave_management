import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/model/PublicHoliday.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/public_holiday_page/components/holiday_list_item_widget.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class PublicHolidayPage extends StatefulWidget {
  @override
  _PublicHolidayPageState createState() => _PublicHolidayPageState();
}

class _PublicHolidayPageState extends State<PublicHolidayPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: new Text(
          "Public Holidays",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: _createContent(context),
      ),



      floatingActionButton: StoreConnector<AppState, _ViewModel>(
          converter: (Store<AppState> store) => _ViewModel.fromStore(store),
          builder: (BuildContext context, _ViewModel viewModel) {
            return IgnorePointer(
              ignoring: (viewModel.user.role.id != 1),
              child: Opacity(
                opacity: (viewModel.user.role.id == 1) ? 1.0 : 0.0,
                child: FloatingActionButton(
                  backgroundColor: Colors.black,
                  onPressed: () {
                    Navigation.navigateTo(context, 'add_public_holiday',
                        transition: TransitionType.fadeIn);
                  },
                  tooltip: 'Add new holiday',
                  child: new Icon(Icons.add),
                ),
              ),
            );
          }),
    );
  }

  Widget _createContent(BuildContext context) {
    return StreamBuilder(
      stream:
          Firestore.instance.collection("companyLeaveCollection").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (!snapShot.hasData) {
          return Center(
            child: Text(
              "Getting data",
              style: TextStyle(color: Colors.deepOrange),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: snapShot.data.documents.length,
            padding: const EdgeInsets.all(0.0),
            itemBuilder: (context, index) {
              DocumentSnapshot documentSnapshot =
                  snapShot.data.documents[index];
              PublicHoliday publicHoliday =
                  PublicHoliday.fromJson(documentSnapshot);
              return HolidayListItemWidget(
                publicHoliday: publicHoliday,
                showInSnackBar: showInSnackBar,
              );
            },
          );
        }
      },
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
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
