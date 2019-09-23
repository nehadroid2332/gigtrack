import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/update_activity_bandmember_status.dart';

abstract class AddActivityContract extends BaseContract {
  void onSuccess();
  void getActivityDetails(Activites activities);

  void onActivitySuccess();

  void onUpdate();

  void onSubSuccess();
}

class AddActivityPresenter extends BasePresenter {
  AddActivityPresenter(BaseContract view) : super(view);

  void getActivityDetails(String id) async {
    final res = await serverAPI.getActivityDetails(id);
    if (res is Activites) {
      (view as AddActivityContract).getActivityDetails(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void addActivity(Activites activities, bool isParent) async {
    activities.userId = serverAPI.currentUserId;
    if (isParent) {
      final res1 = await serverAPI.getActivityDetails(activities.id);
      if (res1 is Activites) {
        res1.userId = serverAPI.currentUserId;
        res1.subActivities.add(activities);
        final res2 = await serverAPI.addActivities(res1);
        if (res2 is bool) {
          (view as AddActivityContract).onSubSuccess();
        } else if (res2 is ErrorResponse) {
          view.showMessage(res2.message);
        }
      } else if (res1 is ErrorResponse) {
        view.showMessage(res1.message);
      }
    } else {
      final res = await serverAPI.addActivities(activities);
      if (res is bool) {
        if (!res)
          (view as AddActivityContract).onSuccess();
        else {
          (view as AddActivityContract).onUpdate();
        }
      } else if (res is ErrorResponse) {
        view.showMessage(res.message);
      }
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

  void activityDelete(String id) {
    serverAPI.deleteActivity(id);
  }
}
