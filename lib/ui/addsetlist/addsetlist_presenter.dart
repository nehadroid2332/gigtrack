import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band_member.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/setlist.dart';
import 'package:gigtrack/ui/addband/add_band_presenter.dart';

import '../../server/models/band.dart';

abstract class AddSetListContract extends BaseContract {
  void onSuccess();
  void onUpdate();
  void onDetails(SetList setList);

  void onDelete();

  void onBandMemberDetails(Iterable<BandMember> values);

  void getBandDetails(Band band);
}

class AddSetListPresenter extends BasePresenter {
  AddSetListPresenter(BaseContract view) : super(view);

  void getDetails(String id, String bandId) async {
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

  void getBandDetails(String id) async {
    final res = await serverAPI.getBandDetails(id);
    if (res is Band) {
      (view as AddSetListContract).getBandDetails(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void deleteSetList(String id) async {
    await serverAPI.deleteSetList(id);
    (view as AddSetListContract).onDelete();
  }

  void addSong(String id, Song currentSong) async {
    final res = await serverAPI.getSetListItemDetails(id);
    if (res is SetList) {
      for (var i = 0; i < res.songs.length; i++) {
        Song song = res.songs[i];
        if (song.id == currentSong.id) {
          res.songs[i] = currentSong;
          break;
        }
      }
      (view as AddSetListContract).onUpdate();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
