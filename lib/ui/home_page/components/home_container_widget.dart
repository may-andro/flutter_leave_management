import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:flutter_mm_hrmangement/model/RoleModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/app_action/app_action.dart';
import 'package:flutter_mm_hrmangement/redux/applied_leave_redux/applied_leave_action.dart';
import 'package:flutter_mm_hrmangement/redux/employee_management_redux/employee_management_action.dart';
import 'package:flutter_mm_hrmangement/redux/login_action/actions.dart';
import 'package:flutter_mm_hrmangement/redux/project_management_redux/project_management_action.dart';
import 'package:flutter_mm_hrmangement/redux/public_holiday/public_holiday_action.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/dashboard_page/dashboard_page.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/components/base_fragment_container.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/components/extended_fab_widget.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/components/menu_controller.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/components/menu_screen.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/components/setting_controller.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/components/setting_page.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/model/menu_item_model.dart';
import 'package:flutter_mm_hrmangement/ui/home_page/model/menu_model.dart';
import 'package:flutter_mm_hrmangement/ui/leave_request_page/user_leave_request_page.dart';
import 'package:flutter_mm_hrmangement/ui/project_management/project_management_page.dart';
import 'package:flutter_mm_hrmangement/ui/public_holiday_management/add_public_holiday_page/add_public_holiday_page.dart';
import 'package:flutter_mm_hrmangement/ui/public_holiday_management/public_holiday_page/public_hoilday_page.dart';
import 'package:flutter_mm_hrmangement/ui/user_management_page/user_list_page.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';
import 'package:flutter_mm_hrmangement/utility/text_theme.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeContainerWidget extends StatefulWidget {
  @override
  _HomeContainerWidgetState createState() => _HomeContainerWidgetState();
}

class _HomeContainerWidgetState extends State<HomeContainerWidget>
    with TickerProviderStateMixin {
  var selectedMenuItemId = 0;

  MenuController menuController;
  SettingController settingController;

  var settingMenuState = 0;

  Curve scaleDownCurve = new Interval(0.0, 0.5, curve: Curves.easeOut);
  Curve scaleUpCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideOutCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideInCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);

  Curve slideOut = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideIn = new Interval(0.0, 1.0, curve: Curves.easeOut);

  @override
  void initState() {
    super.initState();

    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {
          print('_HomeContainerWidgetState.initState');
        }));

    settingController = new SettingController(
      vsync: this,
    )..addListener(() => setState(() {
      print('_HomeContainerWidgetState.initState');
    }));

  }

  @override
  void dispose() {
    menuController.dispose();
    settingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeViewModel>(
        converter: (Store<AppState> store) => HomeViewModel.fromStore(store),
        builder: (BuildContext context, HomeViewModel viewModel) {
          return Stack(
            fit: StackFit.expand,
            children: [
              MenuScreen(
                menuController: menuController,
                menu: getMenu(viewModel.user.role),
                selectedItemId: selectedMenuItemId,
                onMenuItemSelected: (int itemId) {
                  if (selectedMenuItemId == itemId) {
                    menuController.toggle();
                  } else {
                    selectedMenuItemId = itemId;
                    menuController.toggle();
                  }
                },
              ),

              zoomAndSlideContent(
                BaseFragmentContainerWidget(
                  isDrawerOpen: menuController.state == MenuState.open,
                  isSettingOpen: settingController.state == MenuState.open,
                  contentScreen: _buildUI(selectedMenuItemId, context),
                  fabButton: getFabAccordingToMenuSelection(selectedMenuItemId, viewModel.user.role.id),
                  menuToggleCallback: () {
                    menuController.toggle();
                  },
                  refreshCallback: () {
                    settingController.toggle();
                    /*setState(() {
                      settingMenuState = 1;
                    });*/
                    //refreshPage(viewModel);
                  },
                ),
              ),

              slideUpAndDownContent(
                  SettingPage(
                    menu: getSettingMenu(),
                    menuClickCallback: (index) {
                      switch(index) {
                        case 0:

                          break;
                        case 1:
                          var store = StoreProvider.of<AppState>(context);
                          store.dispatch(ChangeThemeAction(themeId: SELECTED_THEME_RED));
                          settingController.toggle();
                          break;
                        case 2: refreshPage(viewModel);
                          break;
                        default: break;
                      }
                    },
                    closeMenuCallback: () {
                      settingController.toggle();
                    },
                  )
              ),
            ],
          );
        });
  }

  zoomAndSlideContent(Widget content) {
    var slidePercent, scalePercent;
    switch (menuController.state) {
      case MenuState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case MenuState.opening:
        slidePercent = slideOutCurve.transform(menuController.percentOpen);
        scalePercent = scaleDownCurve.transform(menuController.percentOpen);
        break;
      case MenuState.closing:
        slidePercent = slideInCurve.transform(menuController.percentOpen);
        scalePercent = scaleUpCurve.transform(menuController.percentOpen);
        break;
    }

    final slideAmount = 275.0 * slidePercent;
    final contentScale = 1.0 - (0.2 * scalePercent);
    final cornerRadius = 10.0 * menuController.percentOpen;

    return new Transform(
      transform: new Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: new Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: const Color(0x44000000),
              offset: const Offset(0.0, 5.0),
              blurRadius: 20.0,
              spreadRadius: 10.0,
            ),
          ],
        ),
        child: new ClipRRect(
            borderRadius: new BorderRadius.circular(cornerRadius),
            child: content),
      ),
    );
  }

  slideUpAndDownContent(Widget content) {
    var slidePercent;
    switch (settingController.state) {
      case SettingState.closed:
        slidePercent = 1.0;
        print('slidePercent close= $slidePercent');
        break;
      case SettingState.open:
        slidePercent = 0.0;
        print('slidePercent open= $slidePercent');
        break;
      case SettingState.opening:
        slidePercent = 1.0 - slideIn.transform(settingController.percentOpen);
        print('slidePercent opening= $slidePercent');
        break;
      case SettingState.closing:
        slidePercent = 1.0 - slideOut.transform(settingController.percentOpen);
        print('slidePercent closing = $slidePercent');
        break;
    }

    final slideAmount = 1075.0 * slidePercent;

    return new Transform(
      transform: new Matrix4.translationValues(0.0, slideAmount, 0.0),
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(0.0),
          child: content),
    );
  }


  Menu getMenu(Role role) {
    var list = [
      MenuItem(
        id: 0,
        title: 'Dashboard',
      ),
      MenuItem(
        id: 1,
        title: 'Company Leave',
      ),
    ];
    if (role.id == 1 || role.id == 0) {
      list.add(MenuItem(
        id: 2,
        title: 'Team',
      ));
    }
    if (role.id == 5 || role.id == 6 || role.id == 0) {
      list.add(MenuItem(
        id: 3,
        title: 'Project',
      ));
    }
    list.add(MenuItem(
      id: 4,
      title: 'Logout',
    ));
    return Menu(
      items: list,
    );
  }

  Menu getSettingMenu() {
    var list = [
      MenuItem(
        id: 0,
        title: 'Language',
      ),
      MenuItem(
        id: 1,
        title: 'Theme',
      ),
      MenuItem(
        id: 2,
        title: 'Refresh',
      ),
    ];
    return Menu(
      items: list,
    );
  }

  Widget _buildUI(int selectedMenuItemId, BuildContext context) {
    switch (selectedMenuItemId) {
      case 0:
        return DashBoardPage();
      case 1:
        return PublicHolidayPage();
      case 2:
        return UserManagementPage();
      case 3:
        return ProjectManagementPage();
      case 4:
        {
          logoutUser(context);
          return Container(
            color: Colors.transparent,
            child: Center(),
          );
        }
      default:
        return Center();
    }
  }

  Widget getFabAccordingToMenuSelection(int selectedMenuItemId, int id) {
    switch (selectedMenuItemId) {
      case 0:
        return ExtendedFabWidget('Request for leave', () {
          //Navigation.navigateTo(context, 'leave_request', transition: TransitionType.fadeIn);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LeaveRequestPage(),
            ),
          );
        });
      case 1:
        return IgnorePointer(
          ignoring: (id != 1),
          child: Opacity(
            opacity: (id == 1) ? 1.0 : 0.0,
            child: ExtendedFabWidget('Add public holiday', () {
              //Navigation.navigateTo(context, 'add_public_holiday', transition: TransitionType.fadeIn);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPublicHolidayPage(),
                ),
              );
            }),
          ),
        );
      case 2:
        return ExtendedFabWidget('Add new member', () {
          Navigation.navigateTo(context, 'add_user',
              transition: TransitionType.fadeIn);
        });
      case 3:
        return ExtendedFabWidget('Add new project', () {
          Navigation.navigateTo(context, 'select_user_for_project',
              transition: TransitionType.fadeIn);
        });
      case 4:
        return ExtendedFabWidget('logout', () {
          Navigation.navigateTo(context, 'select_user_for_project',
              transition: TransitionType.fadeIn);
        });
      default:
        return Center();
    }
  }

  void refreshPage(HomeViewModel viewModel) {
    var store = StoreProvider.of<AppState>(context);
    switch (selectedMenuItemId) {
      case 0:
        store.dispatch(ClearAppliedLeaveAction());
        store.dispatch(FetchAppliedLeaveAction(mmid: viewModel.user.mmid));
        break;
      case 1:
        store.dispatch(FetchPublicHolidayAction());
        break;
      case 2:
        store.dispatch(FetchEmployeeListAction());
        break;
      case 3:
        store.dispatch(FetchProjectListAction());
        break;
      case 4:
        return null;
      default:
        return null;
    }
  }

  void logoutUser(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(LOGGED_IN_USER_MMID, "");
    sharedPreferences.setString(LOGGED_IN_USER_PASSWORD, "");

    var store = StoreProvider.of<AppState>(context);
    store.dispatch(LogoutUserAction());
    store.dispatch(ClearAppliedLeaveAction());
    store.dispatch(ClearPublicHolidayAction());
    store.dispatch(ClearSelectedEmployeeListAction());
    store.dispatch(ClearEmployeeListAction());
    store.dispatch(ClearProjectListAction());
    Navigation.navigateTo(context, 'signin',
        replace: true, transition: TransitionType.fadeIn);
  }
}

class HomeViewModel {
  final User user;

  final List<Leave> leaveList;

  HomeViewModel({@required this.user, this.leaveList});

  static HomeViewModel fromStore(Store<AppState> store) {
    return HomeViewModel(
        user: store.state.loginState.user,
        leaveList: store.state.appliedLeaveState.leaveList);
  }
}
