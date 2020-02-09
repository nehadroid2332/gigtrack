import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/band_comm.dart';

abstract class BandCommListContract extends BaseContract{
  void onBandDetails(Band res);
  
  }
  
  class BandCommListPresenter extends BasePresenter {
    BandCommListPresenter(BaseContract view) : super(view);
  
    Stream<List<BandCommunication>> getList(String bandId,bool isLeader) {
      return serverAPI.bandCommDB.onValue.map((a) {
        Map mp = a.snapshot.value;
        if (mp == null) return null;
        List<BandCommunication> acc = [];
        for (var d in mp.values) {
          final bullets = BandCommunication.fromJSON(d);
          if(bullets.status==BandCommunication.STATUS_APPROVED) {
            if (bandId != null && bandId == bullets.bandId) acc.add(bullets);
          }else if( isLeader && bullets.status==BandCommunication.STATUS_PENDING){
            if (bandId != null && bandId == bullets.bandId) acc.add(bullets);

          }
        }
        return acc;
      });
    }
  
    void getBand(String bandId) async{
      final res = await serverAPI.getBandDetails(bandId);
      if (res is Band) {
        (view as BandCommListContract).onBandDetails(res);
    }
  }
}
