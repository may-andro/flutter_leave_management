import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/ui/add_project_page/add_new_project_page.dart';
import 'package:flutter_mm_hrmangement/ui/add_project_page/model/AddProjectBloc.dart';
import 'package:flutter_mm_hrmangement/ui/add_project_page/model/AddProjectBlocProvider.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';

class SelectUserForProjectPage extends StatefulWidget {
  @override
  _SelectUserForProjectPageState createState() =>
      _SelectUserForProjectPageState();
}

class _SelectUserForProjectPageState extends State<SelectUserForProjectPage> {
  List<User> selectedUserList = List();
  bool isManagerSelected = false;
  bool isLeadSelected = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return AddProjectBlocProvider(
      bloc: AddProjectBloc(),
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            title: Text(selectedUserList.length > 0
                ? '${selectedUserList.length} members selected'
                : 'Select team members',
              style: TextStyle(color: Colors.black),),
            actions: <Widget>[getMenuWidget()],
          ),
          body:



          Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: StreamBuilder(
                  stream: Firestore.instance.collection("userCollection").snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
                    if (!snapShot.hasData) {
                      return FetchingDataWidget();
                    } else {
                      if (snapShot.hasError) {
                        return ErrorInDataWidget();
                      } else {
                        var map = Map<String, List<User>>();

                        snapShot.data.documents.forEach((document) {
                          User user = User.fromJson(document);
                          if (map.containsKey(user.department)) {
                            var list = map[user.department];
                            list.add(user);
                          } else {
                            map.putIfAbsent(user.department, () => [user]);
                          }
                        });

                        var headerList = [];
                        map.forEach((designation, list) {
                          headerList.add(designation);
                          headerList.addAll(list);
                        });

                        return ListView.builder(
                            itemCount: headerList.length,
                            padding: const EdgeInsets.all(0.0),
                            itemBuilder: (context, index) {
                              var item = headerList[index];
                              if (item is String) {
                                return Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(item),
                                );
                              } else {
                                return UserListItem(
                                  user: item,
                                  isSelected: selectedUserList.contains(item),
                                  onTapUserItem: () {
                                    setState(() {
                                      if (selectedUserList.contains(item)) {
                                        if((item as User).department == DEPARTMENT_LIST[3]) isManagerSelected = false;
                                        if((item as User).department == DEPARTMENT_LIST[4]) isLeadSelected = false;
                                        selectedUserList.remove(item);
                                      } else {
                                        if((item as User).department == DEPARTMENT_LIST[3]) isManagerSelected = true;
                                        if((item as User).department == DEPARTMENT_LIST[4]) isLeadSelected = true;
                                        selectedUserList.add(item);
                                      }
                                    });
                                  },
                                );
                              }
                            });
                      }
                    }
                  },
                ),
              ),
            ]
          )),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Widget getMenuWidget() {
    return IconButton(
        icon: const Icon(Icons.people_outline),
        tooltip: 'Add Project',
        onPressed: () {
          if(selectedUserList.isEmpty) {
            showInSnackBar("No user selected");
          } else if(!isLeadSelected) {
            showInSnackBar("Team lead is required");
          } else if(!isManagerSelected){
            showInSnackBar("Manager is required");
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddNewProjectPage(teamList: selectedUserList),
              ),
            );
          }
        });
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
          title: Text(
            widget.user.name,
            style: new TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          subtitle: new Padding(
            padding: new EdgeInsets.only(top: 5.0),
            child: new Text(
              '${widget.user.department.substring(0, 1)}',
              style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
            ),
          ),
          leading: CircleAvatar(
            child: Text(
              "${widget.user.name.substring(0, 2)}",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.deepPurple,
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
