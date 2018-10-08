
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:flutter_mm_hrmangement/model/PublicHoliday.dart';
import 'package:meta/meta.dart';

class FetchPublicHolidayAction {}

class RefreshDestinationsAction {}

class ErrorLoadingPublicHolidayAction {
  ErrorLoadingPublicHolidayAction({@required this.errorStr});
  final String errorStr;
}

class SetPublicHolidayAction {
  SetPublicHolidayAction({@required this.publicHolidayList});
  final List<PublicHoliday> publicHolidayList;
}

class ClearPublicHolidayAction {}

class DeletePublicHolidayAction {
  DeletePublicHolidayAction({@required this.publicHoliday});
  final PublicHoliday publicHoliday;
}

class AddPublicHolidayAction {
  AddPublicHolidayAction({@required this.publicHoliday});
  final PublicHoliday publicHoliday;
}



