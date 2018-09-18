import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/Profile_Notification.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/ui/add_project_page/add_new_project_page.dart';
import 'package:flutter_mm_hrmangement/ui/add_project_page/model/AddProjectBloc.dart';
import 'package:flutter_mm_hrmangement/ui/add_project_page/model/AddProjectBlocProvider.dart';

class SelectUserForProjectPage extends StatefulWidget {
  @override
  _SelectUserForProjectPageState createState() => _SelectUserForProjectPageState();
}

class _SelectUserForProjectPageState extends State<SelectUserForProjectPage> {
  List<User> selectedUserList = List();

  @override
  Widget build(BuildContext context) {
    return AddProjectBlocProvider(
      bloc: AddProjectBloc(),
      child: Scaffold(
          appBar: new AppBar(
            title: new Text(selectedUserList.length > 0
                ? '${selectedUserList.length} members selected'
                : 'Select team members'),
            actions: <Widget>[
              getMenuWidget()
            ],
          ),
          body: StreamBuilder(
            stream: Firestore.instance.collection("userCollection").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
              if (!snapShot.hasData) {
                return FetchingDataWidget();
              } else {
                if (snapShot.hasError) {
                  return ErrorInDataWidget();
                } else {
                  debugPrint('${selectedUserList.length}');
                  return ListView.builder(
                      itemCount: snapShot.data.documents.length,
                      padding: const EdgeInsets.all(0.0),
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapShot.data.documents[index];
                        User user = User.fromJson(ds);
                        return  UserListItem(
                          user: user,
                          isSelected: selectedUserList.contains(user),
                          onTapUserItem: () {
                            setState(() {
                              if (selectedUserList.contains(user)) {
                                selectedUserList.remove(user);
                              } else {
                                selectedUserList.add(user);
                              }
                            });
                          },
                        );
                      });
                }
              }
            },
          )),
    );
  }

  Widget getMenuWidget() {
    if (selectedUserList.isNotEmpty) {
      return  IconButton(
        icon: const Icon(Icons.people_outline),
        tooltip: 'Add Project',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNewProjectPage(teamList: selectedUserList),
            ),
          );
        });
    } else {
      return Padding(
        padding: EdgeInsets.all(0.0),
      );
    }
  }
}

class UserListItem extends StatefulWidget {

  UserListItem({
    this.user,
    this.isSelected,
    this.onTapUserItem,
  });

  final bool isSelected;
  final VoidCallback onTapUserItem;
  final User user;

  @override
  _UserListItemState createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(
          height: 5.5,
        ),
        ListTile(
          title: Text(widget.user.name,
            style: new TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          subtitle: new Padding(
            padding: new EdgeInsets.only(top: 5.0),
            child: new Text('${widget.user.department.substring(0,1)}',
              style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
            ),
          ),
          leading: CircleAvatar(
            child: Text("${widget.user.name.substring(0, 2)}",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.pink,
          ),
          onTap: widget.onTapUserItem,
          selected: widget.isSelected,
          trailing: getTrailingWidget(),
        )
      ],
    );
  }

  Widget getTrailingWidget() {
    if (widget.isSelected) {
      return IconButton(
        icon: const Icon(Icons.done),
        tooltip: 'Add Project',
        onPressed: () {
          setState(() {});
        },
      );
    } else {
      return null;
    }
  }
}

class FetchingDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "Getting data",
          style: TextStyle(color: Colors.deepOrange),
        ),
      ),
    );
  }
}

class ErrorInDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "Error data",
          style: TextStyle(color: Colors.deepOrange),
        ),
      ),
    );
  }
}
