import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/notestodo.dart';

abstract class AddNoteContract extends BaseContract {
  void onSuccess();
  void onUpdate();
  void getNoteDetails(NotesTodo note);
}

class AddNotesPresenter extends BasePresenter {
  AddNotesPresenter(BaseContract view) : super(view);

  void addNotes(NotesTodo notetodo) async {
    notetodo.user_id = serverAPI.currentUserId;
    final res = await serverAPI.addNotes(notetodo);
    if (res is bool) {
      if (res) {
        (view as AddNoteContract).onUpdate();
      } else
        (view as AddNoteContract).onSuccess();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void getNotesDetails(String id) async {
    final res = await serverAPI.getNoteDetails(id);
    if (res is NotesTodo) {
      (view as AddNoteContract).getNoteDetails(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
