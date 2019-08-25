import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/activities_list_response.dart';
import 'package:gigtrack/server/models/activities_response.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/band_list_response.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/update_activity_bandmember_status.dart';

abstract class AddActivityContract extends BaseContract {
  void onSuccess(ActivitiesResponse res);
  void getBandSuccess(List<Band> bands);
  void getActivityDetails(Activites activities);

  void onActivitySuccess();

  void onUpdate(ActivitiesResponse res);
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
      if (activities.id.isEmpty)
        (view as AddActivityContract).onSuccess(res);
      else {
        (view as AddActivityContract).onUpdate(res);
      }
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  String getCurrentUserId() {
    return serverAPI.userId;
  }

  void acceptStatusForBandMemberinAcitivty(String activityId) async {
    final res = await serverAPI.updateBandmateStatusForActivity(activityId, 1);
    if (res is UpdateAcivityBandMemberStatusResponse) {
      (view as AddActivityContract).onActivitySuccess();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
