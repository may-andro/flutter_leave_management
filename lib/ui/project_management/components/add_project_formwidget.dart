import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/app_button_widget.dart';
import 'package:flutter_mm_hrmangement/components/text_label_widget.dart';
import 'package:flutter_mm_hrmangement/model/ProjectModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/project_management_redux/project_management_action.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class AddProjectFormWidget extends StatefulWidget {
  @override
  _AddProjectFormWidgetState createState() => _AddProjectFormWidgetState();
}

class _AddProjectFormWidgetState extends State<AddProjectFormWidget> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _projectName;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AddProjectViewModel>(
        converter: (Store<AppState> store) =>
            AddProjectViewModel.fromStore(store),
        builder: (BuildContext context, AddProjectViewModel viewModel) {
          return _createontent(viewModel: viewModel);
        });
  }

  List<Widget> getFilterChips(List<User> selectedTeamList) {
    List<Widget> filterChips = selectedTeamList.map<Widget>((User user) {
      return new FilterChip(
        key: new ValueKey<String>(user.name),
        label: new Text((user.name)),
        selected: true,
        onSelected: (selected) {
          debugPrint('$selected');
        },
        selectedColor: Colors.blue,
      );
    }).toList();

    return filterChips;
  }

  Widget _createontent({AddProjectViewModel viewModel}) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextLabelWidget(
                  'Project Name', Colors.white, Colors.deepPurple, () {}),
              TextLabelWidget('Dummy', Colors.white, Colors.white, () {}),
            ],
          ),
          Padding(padding: const EdgeInsets.all(8.0)),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 16.0, right: 16.0),
            child: TextFormField(
              validator: (val) =>
                  val.length == 0 ? 'project name is empty' : null,
              onSaved: (String val) {
                _projectName = val;
              },
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(
                labelText: 'Project name',
                border: OutlineInputBorder(),
                hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextLabelWidget(
                  'Team Members', Colors.white, Colors.deepPurple, () {}),
              TextLabelWidget('Dummy', Colors.white, Colors.white, () {}),
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Padding(
                    child: Wrap(
                        children: getFilterChips(viewModel.selectedUserList)
                            .map((Widget chip) {
                      return new Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: chip,
                      );
                    }).toList()),
                    padding: const EdgeInsets.only(top: 4.0, left: 16.0),
                  ),
                  color: Colors.white,
                ),
              ),
            ],
          ),
          new Padding(padding: new EdgeInsets.all(20.0)),
          AppButtonWidget(() {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              var store = StoreProvider.of<AppState>(context);
              store.dispatch(SetProjectNameAction(name: _projectName));

              List<ProjectUser> projectUseList = [];
              viewModel.selectedUserList.forEach((user) {
                var projectUser = ProjectUser(
                    name: user.name,
                    mmid: user.mmid,
                    isManager: (user.role.id == 0 ||
                            user.role.id == 1 ||
                            user.role.id == 4 ||
                            user.role.id == 5 ||
                            user.role.id == 6)
                        ? true
                        : false);
                projectUseList.add(projectUser);
              });

              var project = Project(name: _projectName, team: projectUseList);
              print('_AddProjectFormWidgetState._createontent ${projectUseList.length}');
              store.dispatch(AddProjectAction(project: project));
              Navigator.pop(context);
            }
          }, 'Add')
        ]),
      ),
    );
  }
}

class AddProjectViewModel {
  final User user;
  final String screenTitle;
  final List<User> selectedUserList;

  AddProjectViewModel({this.screenTitle, this.user, this.selectedUserList});

  static AddProjectViewModel fromStore(Store<AppState> store) {
    return AddProjectViewModel(
        screenTitle: 'Add project',
        user: store.state.loginState.user,
        selectedUserList:
            store.state.projectManagementState.selectedEmployeeList);
  }
}
