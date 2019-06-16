import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/activities_response.dart';
import 'package:gigtrack/server/models/error_response.dart';

abstract class AddActivityContract extends BaseContract {
  void onSuccess(ActivitiesResponse res);
}

class AddActivityPresenter extends BasePresenter {
  AddActivityPresenter(BaseContract view) : super(view);

  void addActivity(Activites activities) async {
    final res = await serverAPI.addActivities(activities);
    if (res is ActivitiesResponse) {
      (view as AddActivityContract).onSuccess(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
