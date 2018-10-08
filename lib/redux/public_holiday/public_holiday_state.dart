
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:flutter_mm_hrmangement/model/PublicHoliday.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/model/loading_status.dart';
import 'package:meta/meta.dart';

@immutable
class PublicHolidayState {
  PublicHolidayState({this.loadingStatus,
    this.publicHolidayList,
    this.errorMessage});

  @required final List<PublicHoliday> publicHolidayList;
  final LoadingStatus loadingStatus;
  final String errorMessage;

  factory PublicHolidayState.initial() {
    return PublicHolidayState(
      loadingStatus: LoadingStatus.loading,
      publicHolidayList: [],
      errorMessage: null,
    );
  }

  PublicHolidayState setPublicHolidayList({List<PublicHoliday> receivedList, LoadingStatus status, String errorMessage})
  {
    publicHolidayList.addAll(receivedList);
    return PublicHolidayState(loadingStatus: status, publicHolidayList: publicHolidayList, errorMessage: errorMessage);
  }

  PublicHolidayState addPublicHolidayList({PublicHoliday publicHoliday, LoadingStatus status, String errorMessage})
  {
    publicHolidayList.add(publicHoliday);
    return PublicHolidayState(loadingStatus: status, publicHolidayList: publicHolidayList, errorMessage: errorMessage);
  }


  PublicHolidayState clearPublicHolidayAction()
  {
    publicHolidayList.clear();
    return PublicHolidayState(loadingStatus: LoadingStatus.loading, publicHolidayList: publicHolidayList, errorMessage: '');
  }

  PublicHolidayState deletePublicHolidayList({PublicHoliday publicHoliday})
  {
    publicHolidayList.remove(publicHoliday);
    return PublicHolidayState(publicHolidayList: publicHolidayList,);
  }
}