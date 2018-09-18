import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/components/login_form.dart';
import 'package:flutter_mm_hrmangement/ui/user_management_page/components/user_list_item_widget.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("Employee Management"),
      ),

      body: Container(
        color: Colors.white,
        child: _createContent(context),
      ),

      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigation.navigateTo(context, 'add_user', transition: TransitionType.fadeIn);
        },
        tooltip: 'Add new employee',
        child: new Icon(Icons.add),
      ),
    );
  }

  Widget _createContent(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection("userCollection").snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot> snapShot) {
        if(!snapShot.hasData) {
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
                DocumentSnapshot documentSnapshot = snapShot.data.documents[index];
                User user = User.fromJson(documentSnapshot);
                return StoreConnector<AppState, _ViewModel>(
                    converter: (Store<AppState> store) => _ViewModel.fromStore(store),
                    builder: (BuildContext context, _ViewModel viewModel) {
                      return createListItem(viewModel.user, user);
                    }
                );
              },

          );
        }
      },
    );
  }

  Widget createListItem(User loggedInUser, User user) {
    if(loggedInUser == user) {
      return Container();
    } else {
      return  UserListItemWidget(user: user, showInSnackBar: showInSnackBar);
    }
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