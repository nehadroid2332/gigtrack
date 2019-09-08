import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/activities.dart';

abstract class ActivitiesListContract extends BaseContract {}

class ActivitiesListPresenter extends BasePresenter {
  ActivitiesListPresenter(BaseContract view) : super(view);

  Stream<List<Activites>> getList() {
    return serverAPI.activitiesDB
        .orderByChild('user_id')
        .equalTo(serverAPI.currentUserId)
        .onValue
        .map((a) {
      Map mp = a.snapshot.value;
      List<Activites> acc = [];
      for (var d in mp.values) {
        acc.add(Activites.fromJSON(d));
      }
      return acc;
    });
  }
}
