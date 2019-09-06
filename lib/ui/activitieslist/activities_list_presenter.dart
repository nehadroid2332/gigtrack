import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/activities.dart';

abstract class ActivitiesListContract extends BaseContract {}

class ActivitiesListPresenter extends BasePresenter {
  ActivitiesListPresenter(BaseContract view) : super(view);

  Stream<Activites> getList() {
    return serverAPI.activitiesDB.onChildAdded.map((a) {
      return Activites.fromJSON(a.snapshot.value);
    });
  }
}
