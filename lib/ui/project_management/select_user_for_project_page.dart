import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/list_item_card_widget.dart';
import 'package:flutter_mm_hrmangement/components/text_label_widget.dart';
import 'package:flutter_mm_hrmangement/model/RoleModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/project_management_redux/project_management_action.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/project_management/add_new_project_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SelectUserForProjectPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SelectedUserViewModel>(
        converter: (Store<AppState> store) => SelectedUserViewModel.fromStore(store),
        builder: (BuildContext context, SelectedUserViewModel viewModel) {
          return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                elevation: 0.0,
                centerTitle: true,
                iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Colors.white,
                title: Text(viewModel.selectedUserList.length > 0
                    ? '${viewModel.selectedUserList.length} members selected'
                    : 'Select team members',
                  style: TextStyle(color: Colors.black),),
                actions: <Widget>[getMenuWidget(viewModel, context)],
              ),
              body: _createContent(context, viewModel)
          );
        });
  }

  Widget _createContent(BuildContext context, SelectedUserViewModel viewModel) {
    return ListView.builder(
        itemCount: viewModel.employeeList.length,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          var item = viewModel.employeeList[index];
          if (item is Role) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextLabelWidget(item.title, Colors.white, Colors.deepPurple, () {}),
                  TextLabelWidget('Dummy', Colors.white, Colors.white, () {}),
                ],
              ),
            );
          } else {
            return
              ListItemWidget((item as User),
                  (item as User).name,
                  (item as User).role.title,
                  CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        "${(item as User).name.substring(0, 1)}",
                        style: TextStyle(color: Colors.blueGrey),
                      )),
                  Opacity(
                    opacity: viewModel.selectedUserList.contains(item as User) ? 1.0 : 0.0,
                    child:
                    CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.done),
                          color: Colors.blueGrey,
                          tooltip: '',
                          onPressed: () {},
                        ),
                    ),
                  ),
                      () {
                        print('SelectUserForProjectPage._createContent on Item CLick ${(item as User).name}');
                        var store = StoreProvider.of<AppState>(context);
                        if (viewModel.selectedUserList.contains((item as User))) {
                          store.dispatch(DeselectSelectEmployeeAction((item as User)));
                        } else {
                          store.dispatch(AddSelectedEmployeeAction(user: (item as User)));
                        }
                      },
                  null, (value) {},
                  false,
                  false);
          }
        });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Widget getMenuWidget(SelectedUserViewModel viewModel, BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.people_outline),
        tooltip: 'Add Project',
        onPressed: () {
          var list = viewModel.selectedUserList.where((user) => user.role.id == 5 || user.role.id == 6).toList();
          if(viewModel.selectedUserList.isEmpty) {
            showInSnackBar("No user selected");
          } else if(list.length > 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddNewProjectPage(),
              ),
            );
          } else {
            showInSnackBar("Team lead/Project Manager is required");
          }
        });
  }
}

class SelectedUserViewModel {
  final User user;
  final String screenTitle;
  final List<dynamic> employeeList;
  final List<User> selectedUserList;

  SelectedUserViewModel({
    this.screenTitle,
    this.user,
    this.employeeList,
    this.selectedUserList
  });

  static SelectedUserViewModel fromStore(Store<AppState> store) {
    var map = Map<Role, List<User>>();
    store.state.employeeManagementState.employeeList.forEach((user) {
      if (map.containsKey(user.role)) {
        var list = map[user.role];
        list.add(user);
      } else {
        map.putIfAbsent(user.role, () => [user]);
      }
    });

    var headerList = [];
    map.forEach((role, list) {
      headerList.add(role);
      headerList.addAll(list);
    });

    return SelectedUserViewModel(screenTitle: 'Select team members',
        user: store.state.loginState.user,
        employeeList: headerList,
        selectedUserList: store.state.projectManagementState.selectedEmployeeList);
  }
}
