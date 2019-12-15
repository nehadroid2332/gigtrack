import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band_member.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/setlist.dart';

import '../../server/models/band.dart';

abstract class AddSetListContract extends BaseContract {
  void onSuccess();
  void onUpdate();
  void onDetails(SetList setList);

  void onDelete();

  void onBandMemberDetails(Iterable<BandMember> values);
}

class AddSetListPresenter extends BasePresenter {
  AddSetListPresenter(BaseContract view) : super(view);

  void getDetails(String id,String bandId) async {
    final res = await serverAPI.getSetListItemDetails(id);
    if (res is SetList) {
      final res2 = await serverAPI.getBandDetails(bandId);
      if (res2 is Band) {
        (view as AddSetListContract).onBandMemberDetails(res2.bandmates.values);
      }
      (view as AddSetListContract).onDetails(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

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

  void deleteSetList(String id) async {
    await serverAPI.deleteSetList(id);
    (view as AddSetListContract).onDelete();
  }
}
