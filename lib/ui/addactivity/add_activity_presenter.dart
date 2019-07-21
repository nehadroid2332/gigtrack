import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/activities_list_response.dart';
import 'package:gigtrack/server/models/activities_response.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/band_list_response.dart';
import 'package:gigtrack/server/models/error_response.dart';

abstract class AddActivityContract extends BaseContract {
  void onSuccess(ActivitiesResponse res);
  void getBandSuccess(List<Band> bands);
  void getActivityDetails(Activites activities);
}

class AddActivityPresenter extends BasePresenter {
  AddActivityPresenter(BaseContract view) : super(view);

  void getBands() async {
    final res = await serverAPI.getBands();
    if (res is BandListResponse) {
      (view as AddActivityContract).getBandSuccess(res.bandList);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void getActivityDetails(String id) async {
    final res = await serverAPI.getActivityDetails(id);
    if (res is GetActivitiesListResponse) {
      (view as AddActivityContract).getActivityDetails(res.data[0]);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void addActivity(Activites activities) async {
    final res = await serverAPI.addActivities(activities);
    if (res is ActivitiesResponse) {
      (view as AddActivityContract).onSuccess(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
