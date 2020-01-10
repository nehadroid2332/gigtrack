import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/error_response.dart';

abstract class AddTravelContract extends BaseContract {
  void getTravelDetails(Travel res);
}

class AddTravelPresenter extends BasePresenter {
  AddTravelPresenter(BaseContract view) : super(view);

  void getTravel(String id, String travelId) async {
    final res = await serverAPI.getActivityDetails(id);
    if (res is Activites) {
      for (var item in res.travelList) {
        if (item.id != null && item.id == travelId) {
          (view as AddTravelContract).getTravelDetails(item);
          return;
        }
      }
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
