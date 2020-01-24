import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/feedback.dart';

class FeedbackListPresenter extends BasePresenter {
  FeedbackListPresenter(BaseContract view) : super(view);

  Stream<List<UserFeedback>> getList() {
    return serverAPI.feedDB.onValue.asyncMap((a) async {
      Map mp = a.snapshot.value;
      if (mp == null) return null;
      List<UserFeedback> acc = [];
      for (var d in mp.values) {
        final bullets = UserFeedback.fromJSON(d);
        bullets.user = await serverAPI.getSingleUserById(bullets.userId);
        acc.add(bullets);
      }
      acc.sort((a, b) {
        return a.created.compareTo(b.created);
      });
      return acc;
    });
  }
}
