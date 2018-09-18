import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/dashboard_page/tabs/applied_leave_tab_widget.dart';
import 'package:flutter_mm_hrmangement/ui/dashboard_page/components/detail_body_widget.dart';
import 'package:flutter_mm_hrmangement/ui/dashboard_page/components/header_widget.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  ScrollController _scrollViewController;
  TabController _tabController;

  Animation<double> containerGrowAnimation;

  AnimationController _screenController;

  Animation<double> listTileWidth;
  Animation<Alignment> listSlideAnimation;
  Animation<EdgeInsets> listSlidePosition;
  Animation<Color> fadeScreenAnimation;

  var animateStatus = 0;

  @override
  void initState() {
    super.initState();

    _scrollViewController = new ScrollController();
    _tabController = new TabController(vsync: this, length: 1);

    _screenController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);

    fadeScreenAnimation = new ColorTween(
      begin: const Color.fromRGBO(247, 64, 106, 1.0),
      end: const Color.fromRGBO(247, 64, 106, 0.0),
    ).animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: Curves.ease,
      ),
    );

    containerGrowAnimation = new CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeIn,
    );
    containerGrowAnimation.addListener(() {
      this.setState(() {});
    });
    containerGrowAnimation.addStatusListener((AnimationStatus status) {});

    listTileWidth = new Tween<double>(
      begin: 1000.0,
      end: 600.0,
    ).animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.225,
          0.600,
          curve: Curves.bounceIn,
        ),
      ),
    );

    listSlideAnimation = new AlignmentTween(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.325,
          0.700,
          curve: Curves.ease,
        ),
      ),
    );

    listSlidePosition = new EdgeInsetsTween(
      begin: const EdgeInsets.only(bottom: 16.0),
      end: const EdgeInsets.only(bottom: 80.0),
    ).animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.325,
          0.800,
          curve: Curves.ease,
        ),
      ),
    );

    _screenController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _screenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.3;
    return new Scaffold(
      drawer: createAppDrawer(),
      body: _buildUI(),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigation.navigateTo(context, 'leave_request',
              transition: TransitionType.fadeIn);
        },
        tooltip: 'Request for leave',
        child: new Icon(Icons.add),
      ),
    );
  }

  Widget _buildUI() {
    return NestedScrollView(
      controller: _scrollViewController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          new SliverAppBar(
            pinned: true,
            expandedHeight: 450.0,
            floating: true,
            forceElevated: innerBoxIsScrolled,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Column(
                children: <Widget>[
                  HeaderWidget(
                    backgroundImage: DecorationImage(
                      image: new ExactAssetImage('assets/home.jpeg'),
                      fit: BoxFit.cover,
                    ),
                    containerGrowAnimation: containerGrowAnimation,
                    profileImage: DecorationImage(
                      image: new ExactAssetImage('assets/login.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: new DetailBodyWidget(),
                  ),
                ],
              ),
            ),
            bottom: new TabBar(
              indicatorColor: Colors.white,
              tabs: <Tab>[
                new Tab(
                  text: "Leave History",
                ),
              ],
              controller: _tabController,
            ),
          ),
        ];
      },
      body: new TabBarView(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: new AppliedLeaveWidget(),
          ),
          //new CompanyLeaveTabWidget(),
        ],
        controller: _tabController,
      ),
    );
  }

  Widget createAppDrawer() {
    return new Drawer(
        child:  StoreConnector<AppState, _ViewModel>(
          converter: (Store<AppState> store) => _ViewModel.fromStore(store),
          builder: (BuildContext context, _ViewModel viewModel) {
            return Container(
              color: Colors.white70,
              child: new ListView(
                children: <Widget> [
                  new UserAccountsDrawerHeader(
                    accountEmail: Text(
                      '${viewModel.user.department}',
                    ),
                    accountName: Text(
                      '${viewModel.user.name}',
                    ),
                    onDetailsPressed: () {

                    },
                    currentAccountPicture:  CircleAvatar(
                      child: Text(
                        '${viewModel.user.name.substring(0,1)}',
                      ),
                      backgroundColor: Colors.pink,
                    ),

                  ),

                  ListTile(
                    title: Text('Company Leaves'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigation.navigateTo(context, 'public_holiday_management', transition: TransitionType.fadeIn);
                    },
                  ),

                  getWidgetIfRoleIsHR(viewModel.user),

                  getWidgetIfRoleIsLead(viewModel.user),

                  new ListTile(
                    title: new Text('Notifications'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  new Divider(),

                  new ListTile(
                    title: new Text('About'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  new ListTile(
                    title: new Text('Setting'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  new ListTile(
                    title: new Text('Team'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );
          },
        ),
    );
  }

  Widget getWidgetIfRoleIsHR(User user) {
    if(user.authLevel == (AUTHORITY_LEVEL_LIST[1]) || user.authLevel == (AUTHORITY_LEVEL_LIST[3])) {
      return ListTile(
          title: new Text('Employee Management'),
          onTap: () {
            Navigator.pop(context);
            Navigation.navigateTo(context, 'user_management',
                transition: TransitionType.fadeIn);
          },
        );
    } else {
      return Container();
    }
  }

  Widget getWidgetIfRoleIsLead(User user) {
    if( user.authLevel == (AUTHORITY_LEVEL_LIST[2]) || user.authLevel == (AUTHORITY_LEVEL_LIST[3])) {
      return ListTile(
        title: Text('Project Management'),
        onTap: () {
          Navigator.pop(context);
          Navigation.navigateTo(context, 'project_management',
              transition: TransitionType.fadeIn);
        },
      );
    } else {
      return Container();
    }
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