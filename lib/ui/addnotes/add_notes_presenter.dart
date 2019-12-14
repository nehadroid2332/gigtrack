import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/notestodo.dart';

abstract class AddNoteContract extends BaseContract {
  void onSuccess();
  void onUpdate();
  void onSubSuccess();
  void getNoteDetails(NotesTodo note);
}

class AddNotesPresenter extends BasePresenter {
  AddNotesPresenter(BaseContract view) : super(view);

  void addNotes(NotesTodo notetodo, bool isParent) async {
    notetodo.user_id = serverAPI.currentUserId;
    if (isParent) {
      final res1 = await serverAPI.getNoteDetails(notetodo.id);
      if (res1 is NotesTodo) {
        res1.subNotes.add(notetodo);
        final res2 = await serverAPI.addNotes(res1);
        if (res2 is bool) {
          (view as AddNoteContract).onSubSuccess();
        } else if (res2 is ErrorResponse) {
          view.showMessage(res2.message);
        }
      } else if (res1 is ErrorResponse) {
        view.showMessage(res1.message);
      }
    } else {
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
  }

  void getNotesDetails(String id) async {
    final res = await serverAPI.getNoteDetails(id);
    if (res is NotesTodo) {
      (view as AddNoteContract).getNoteDetails(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void notesDelete(String id) async {
    var res = await serverAPI.deleteNotes(id);
  }

  void convertNotesToActivity(String id) async {
    final res = await serverAPI.getNoteDetails(id);
    if (res is NotesTodo) {

    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
