import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/feedback.dart';

abstract class AddFeedbackContract extends BaseContract {
  void onSuccess();
}

class AddFeedbackPresenter extends BasePresenter {
  AddFeedbackPresenter(BaseContract view) : super(view);

  void addFeedback(String feed) async {
    final res = await serverAPI
        .addFeedback(UserFeedback(message: feed, userId: serverAPI.currentUserId));
    if (res is bool) {
      (view as AddFeedbackContract).onSuccess();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
