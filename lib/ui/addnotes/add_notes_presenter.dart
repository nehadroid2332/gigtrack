import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:random_string/random_string.dart';

abstract class AddNoteContract extends BaseContract {
  void onSuccess();
  void onUpdate();
  void onSubSuccess();
  void getNoteDetails(NotesTodo note);
  void onDelete();
  void onArchive();

  void onUpdateStatus();
}

class AddNotesPresenter extends BasePresenter {
  AddNotesPresenter(BaseContract view) : super(view);

  void addNotes(NotesTodo notetodo, bool isParent, String subNoteId,
      {bool isRemove = false}) async {
    notetodo.userId = serverAPI.currentUserId;
    if (isParent) {
      final res1 = await serverAPI.getNoteDetails(notetodo.id);
      if (res1 is NotesTodo) {
        if (isRemove && subNoteId != null && subNoteId.isNotEmpty) {
          for (var i = 0; i < res1.subNotes.length; i++) {
            NotesTodo item = res1.subNotes[i];
            if (item.id == subNoteId) {
              res1.subNotes.removeAt(i);
              break;
            }
          }
        } else {
          if (subNoteId == null || subNoteId.isEmpty) {
            notetodo.id = randomString(23).replaceAll(",/\\", "");
            res1.subNotes.add(notetodo);
          } else {
            notetodo.id = subNoteId;
            for (var i = 0; i < res1.subNotes.length; i++) {
              NotesTodo item = res1.subNotes[i];
              if (item.id == subNoteId) {
                item.description = notetodo.description;
                res1.subNotes[i] = item;
              }
            }
          }
        }
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

  void updateStatus(String noteId, int status) async {
    final res = await serverAPI.getNoteDetails(noteId);
    if (res is NotesTodo) {
      res.status = status;
      (view as AddNoteContract).onUpdateStatus();
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

  void notesDelete(String id) async {
    await serverAPI.deleteNotes(id);
    (view as AddNoteContract).onDelete();
  }

  void archieveNote(String id) async {
    final res = await serverAPI.getNoteDetails(id);
    if (res is NotesTodo) {
      res.isArchive = true;
      await serverAPI.addNotes(res);
      (view as AddNoteContract).onArchive();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
