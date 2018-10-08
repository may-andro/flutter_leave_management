import 'package:flutter_mm_hrmangement/model/loading_status.dart';
import 'package:flutter_mm_hrmangement/redux/public_holiday/public_holiday_action.dart';
import 'package:flutter_mm_hrmangement/redux/public_holiday/public_holiday_state.dart';
import 'package:redux/redux.dart';


final publicHolidayReducer = combineReducers<PublicHolidayState>([
  TypedReducer<PublicHolidayState, FetchPublicHolidayAction>(_fetchingPublicHolidayState),
  TypedReducer<PublicHolidayState, ErrorLoadingPublicHolidayAction>(_errorLoadingPublicHolidayState),
  TypedReducer<PublicHolidayState, SetPublicHolidayAction>(_setPublicHolidayState),
  TypedReducer<PublicHolidayState, DeletePublicHolidayAction>(_deletePublicHolidayState),
  TypedReducer<PublicHolidayState, AddPublicHolidayAction>(_addPublicHolidayState),
  TypedReducer<PublicHolidayState, ClearPublicHolidayAction>(_clearPublicHolidayState),
]);


PublicHolidayState _fetchingPublicHolidayState(PublicHolidayState publicHolidayStateState, FetchPublicHolidayAction action) {
  return publicHolidayStateState.setPublicHolidayList(receivedList: []);
}


PublicHolidayState _errorLoadingPublicHolidayState(
    PublicHolidayState publicHolidayStateState, ErrorLoadingPublicHolidayAction action) {
  return publicHolidayStateState.setPublicHolidayList(
      status: LoadingStatus.error, errorMessage: action.errorStr);
}


PublicHolidayState _setPublicHolidayState(PublicHolidayState publicHolidayStateState, SetPublicHolidayAction action) {
  return publicHolidayStateState.setPublicHolidayList(receivedList: action.publicHolidayList, status: LoadingStatus.success, errorMessage: '');
}

PublicHolidayState _clearPublicHolidayState(PublicHolidayState publicHolidayStateState, ClearPublicHolidayAction action) {
  return publicHolidayStateState.clearPublicHolidayAction();
}


PublicHolidayState _deletePublicHolidayState(PublicHolidayState publicHolidayStateState, DeletePublicHolidayAction action) {
  return publicHolidayStateState.deletePublicHolidayList(publicHoliday: action.publicHoliday);
}


PublicHolidayState _addPublicHolidayState(PublicHolidayState publicHolidayStateState, AddPublicHolidayAction action) {
  return publicHolidayStateState.addPublicHolidayList(publicHoliday: action.publicHoliday);
}
