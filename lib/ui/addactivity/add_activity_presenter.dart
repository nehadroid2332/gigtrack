import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/update_activity_bandmember_status.dart';

abstract class AddActivityContract extends BaseContract {
  void onSuccess();
  void getActivityDetails(Activites activities);
  void getUserBands(List<Band> bands);
  void onActivitySuccess();

  void onUpdate();

  void onSubSuccess();

  void getBandDetails(Band res);
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
  
    void updateTaskCompleteDate(String id) async {
      final res1 = await serverAPI.getActivityDetails(id);
      if (res1 is Activites) {
        res1.userId = serverAPI.currentUserId;
        res1.taskCompleteDate = DateTime.now().toUtc().millisecondsSinceEpoch;
        final res2 = await serverAPI.addActivities(res1);
        if (res2 is bool) {
          (view as AddActivityContract).onUpdate();
        } else if (res2 is ErrorResponse) {
          view.showMessage(res2.message);
        }
      }
    }
  
    void getUserBands() async {
      final res = await serverAPI.bandDB
          .orderByChild('user_id')
          .equalTo(serverAPI.currentUserId)
          .once();
      Map mp = res.value;
      if (mp == null) return null;
      List<Band> acc = [];
      for (var d in mp.values) {
        Band band = Band.fromJSON(d);
        if (band.userId == serverAPI.currentUserId ||
            band.bandmates.keys
                .contains(serverAPI.currentUserEmail.replaceAll(".", ""))) {
          acc.add(band);
        }
      }
      (view as AddActivityContract).getUserBands(acc);
    }
  
    void removeDateCompleted(String id) async {
      final res = await serverAPI.getActivityDetails(id);
      if (res is Activites) {
        res.taskCompleteDate = null;
        await serverAPI.addActivities(res);
        getActivityDetails(id);
      }
    }
  
    void getBandDetails(String bandId) async {
      final res = await serverAPI.getBandDetails(bandId);
      if (res is Band) {
        (view as AddActivityContract).getBandDetails(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
