
import 'package:flutter_mm_hrmangement/model/loading_status.dart';
import 'package:meta/meta.dart';

class ReceivedLoginStateChangeAction {
  ReceivedLoginStateChangeAction({@required this.loadingStatus, @required this.errorMessage});
  final LoadingStatus loadingStatus;
  final String errorMessage;
}

