import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/app_bar_widget.dart';
import 'package:flutter_mm_hrmangement/components/list_item_card_widget.dart';
import 'package:flutter_mm_hrmangement/components/no_data_found_widget.dart';
import 'package:flutter_mm_hrmangement/model/ProjectModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class  ProjectManagementPage extends StatefulWidget {
  @override
  _ProjectManagementPageState createState() => _ProjectManagementPageState();
}

class _ProjectManagementPageState extends State<ProjectManagementPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AnimationController _screenController;
  Animation<double> _animationReveal;

  @override
  void initState() {
    super.initState();
    _screenController = new AnimationController(
        duration: new Duration(seconds: 1), vsync: this);

    _animationReveal = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _screenController, curve: Curves.decelerate));
  }

  @override
  void dispose() {
    _screenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProjectViewModel>(
        converter: (Store<AppState> store) => ProjectViewModel.fromStore(store),
        builder: (BuildContext context, ProjectViewModel viewModel) {
          return AnimatedBuilder(
              animation: _screenController,
              builder: (BuildContext context, Widget child) {
                return Scaffold(
                  key: _scaffoldKey,
                  appBar: AppBarWidget(viewModel.screenTitle),
                  body: _createContent(context, viewModel),
                );
              });
        });
  }

  Widget _createContent(BuildContext context, ProjectViewModel viewModel) {
    var list = viewModel.projectList.where((project) => project.name != 'hyd_pto_planning').toList();
    if(list.length == 0) {
      return NoDataFoundWidget("No project found");
    }
    _screenController.forward();
    return ListView.builder(
        itemCount: list.length,
        padding: const EdgeInsets.all(0.0),
        itemBuilder: (context, index) {
          var project = list[index];
          return  ListItemWidget(
              project,
              project.name,
              '${project.team.length} Members',
              CircleAvatar(
                child: Text("${project.name.substring(0, 2)}",
                  style: TextStyle(color: Colors.blueGrey),
                ),
                backgroundColor: Colors.white,
              ),
              Opacity(
                opacity: 0.0,
                child: CircleAvatar(
                  child: Text("${project.name.substring(0, 2)}",
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                  backgroundColor: Colors.white,
                ),
              ), () {
          }, _animationReveal, (value) {
            var userToDelete = value as Project;
            showInSnackBar(userToDelete.name);
          }, true, false);
        });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}


class ProjectViewModel {
  final User user;
  final String screenTitle;
  final List<Project> projectList;

  ProjectViewModel({
    this.screenTitle,
    this.user,
    this.projectList
  });

  static ProjectViewModel fromStore(Store<AppState> store) {
    print('ProjectViewModel.fromStore ${store.state.projectManagementState.loadingStatus}');
    print('ProjectViewModel.fromStore ${store.state.projectManagementState.errorMessage}');
    print('ProjectViewModel.fromStore ${store.state.projectManagementState.selectedEmployeeList}');
    print('ProjectViewModel.fromStore ${store.state.projectManagementState.projectList}');
    return ProjectViewModel(screenTitle: 'Project Management',user: store.state.loginState.user, projectList: store.state.projectManagementState.projectList);
  }
}
