import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/activities_list_response.dart';
import 'package:gigtrack/server/models/error_response.dart';

abstract class ActivitiesListContract extends BaseContract {
  void onActivitiesListSuccess(List<Activites> activities);
}

class ActivitiesListPresenter extends BasePresenter {
  ActivitiesListPresenter(BaseContract view) : super(view);

  void getList() async {
    final res = await serverAPI.getActivities();
    final res2 = await serverAPI.getSchedules();
    if (res is GetActivitiesListResponse || res2 is GetActivitiesListResponse) {
      final data = <Activites>[];
      if (res is GetActivitiesListResponse) data.addAll(res.data);
      if (res2 is GetActivitiesListResponse) data.addAll(res2.data);
      (view as ActivitiesListContract).onActivitiesListSuccess(data);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    } else if (res2 is ErrorResponse) {
      view.showMessage(res2.message);
    }
  }
}
