import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/setlist.dart';

abstract class AddSetListContract extends BaseContract {
  void onSuccess();
  void onUpdate();
}

class AddSetListPresenter extends BasePresenter {
  AddSetListPresenter(BaseContract view) : super(view);

  void addSetList(SetList setList) async {
    final res = await serverAPI.addSetList(setList);
    if (res is bool) {
      if (res) {
        (view as AddSetListContract).onUpdate();
      } else
        (view as AddSetListContract).onSuccess();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
