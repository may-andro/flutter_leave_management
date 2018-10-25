import 'package:flutter_mm_hrmangement/ui/home_page/model/menu_item_model.dart';
import 'package:intl/intl.dart';

const List<String> DEPARTMENT_LIST= [
  "General Manager",
  "Human Resource",
  "Finance",
  "Manager",
  "Software Developer Lead",
  "Software Developer",
  "Quality Assurance",
  "UI/UX Designer",
  "Recruiter",
  "Other"
];

const List<String> AUTHORITY_LEVEL_LIST= [
  "Default",
  "Human Resource Authority Level",
  "Lead Authority Level",
  "General Manager AUthority Level",
];

const List<String> LEAVE_TYPE= [
  "Vacation and Family",
  "Sick Leave/ Emergency Leave",
  "Work from home",
];

const List<int> NUMBE_OF_LEAVE_LIST= [
  1,2,3,4,5,6,7,8,9,10,11,12,13,
];

const FIREBASE_FCM_TOKEN = 'FIREBASE_FCM_TOKEN';

const LOGGED_IN_USER_PASSWORD = 'LOGGED_IN_USER_PASSWORD';
const LOGGED_IN_USER_MMID = 'LOGGED_IN_USER_MMID';

const ONBOARDING_FINISHED = 'ONBOARDING_FINISHED';

const SELECTED_THEME = 'SELECTED_THEME';
const SELECTED_THEME_PURPLE = 0;
const SELECTED_THEME_BLUE = 1;
const SELECTED_THEME_RED = 2;
const SELECTED_THEME_YELLOW = 3;

String getLeaveMessage(int dayCount, DateTime _fromDate, DateTime _toDate,
    String reason, String typeOfLeave, String name) {
  print(DateFormat.yMMMMd().format(DateTime.fromMicrosecondsSinceEpoch(
      _fromDate.millisecondsSinceEpoch * 1000)));
  print(DateFormat.yMMMMd().format(DateTime.fromMicrosecondsSinceEpoch(
      _toDate.millisecondsSinceEpoch * 1000)));
  print(_toDate
      .difference(_fromDate)
      .inDays);

  String vocationalMessage = 'Hi Team!'
      '\n\n'
      'I would like to reuest for ${dayCount} ${dayCount > 1 ? 'days' : 'day '}'
      ' leave to spend time with my family and friends '
      '${dayCount > 1 ? 'from ${DateFormat.yMMMMd().format(
      DateTime.fromMicrosecondsSinceEpoch(
          _fromDate.millisecondsSinceEpoch * 1000))} to ${DateFormat.yMMMMd()
      .format(DateTime.fromMicrosecondsSinceEpoch(
      _toDate.millisecondsSinceEpoch * 1000))}.'
      : 'on ${DateFormat.yMMMMd().format(DateTime.fromMicrosecondsSinceEpoch(
      _fromDate.millisecondsSinceEpoch * 1000))} '} '
      'I will available on phone and email in case of any need/assiatance.'
      '\n'
      'I request you to grant me the requested leaves'
      '\n\n'
      'Your truly'
      '\n'
      '$name';

  String sickLeaveMessage = 'Hi Team!'
      '\n\n'
      'I would like to reuest for ${dayCount} ${dayCount > 1
      ? 'days'
      : 'day '} sick leave ${dayCount > 1 ? 'from ${DateFormat.yMMMMd().format(
      DateTime.fromMicrosecondsSinceEpoch(
          _fromDate.millisecondsSinceEpoch * 1000))} to ${DateFormat.yMMMMd()
      .format(DateTime.fromMicrosecondsSinceEpoch(
      _toDate.millisecondsSinceEpoch * 1000))}.'
      : 'on ${DateFormat.yMMMMd().format(DateTime.fromMicrosecondsSinceEpoch(
      _fromDate.millisecondsSinceEpoch * 1000))} '} '
      '. $reason'
      '\n'
      'I request you to grant me the requested sick leaves'
      '\n\n'
      'Your truly'
      '\n'
      '$name';
  String workFromHomeMessage = 'Hi Team!'
      '\n\n'
      'I would like to reuest for work from home on ${DateFormat.yMMMMd()
      .format(DateTime.fromMicrosecondsSinceEpoch(
      _fromDate.millisecondsSinceEpoch * 1000))} as $reason.'
      'I will available on phone, Slack, Hangout and email to collaborate with the team mates and fullfill my duities for the day.'
      '\n'
      'I request you to grant me the work from home for ${DateFormat.yMMMMd()
      .format(DateTime.fromMicrosecondsSinceEpoch(
      _fromDate.millisecondsSinceEpoch * 1000))}'
      '\n\n'
      'Your truly'
      '\n'
      '$name';
  switch (typeOfLeave) {
    case "Vacation and Family":
      return vocationalMessage;
    case "Sick Leave/ Emergency Leave":
      return sickLeaveMessage;
    case "Work from home":
      return workFromHomeMessage;
    default: return vocationalMessage;
  }
}

var menuList = [
  MenuItem(
    id: 0,
    title: 'Dashboard',
  ),
  MenuItem(
    id: 1,
    title: 'Company Leave',
  ),
  MenuItem(
  id: 2,
  title: 'Team',
  ),
  MenuItem(
  id: 3,
  title: 'Project',
  ),
  MenuItem(
  id: 4,
  title: 'Logout',
  )];