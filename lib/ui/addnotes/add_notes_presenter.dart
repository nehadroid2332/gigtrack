import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/note_todo_response.dart';
import 'package:gigtrack/server/models/notes_todo_list_response.dart';
import 'package:gigtrack/server/models/notestodo.dart';

abstract class AddNoteContract extends BaseContract {
  void onSuccess(NoteTodoResponse res);
  void getNoteDetails(NotesTodo note);
}

class AddNotesPresenter extends BasePresenter {
  AddNotesPresenter(BaseContract view) : super(view);

  void addNotes(NotesTodo notetodo) async {
    final res = await serverAPI.addNotes(notetodo);
    if (res is NoteTodoResponse) {
      (view as AddNoteContract).onSuccess(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void getNotesDetails(String id) async {
    final res = await serverAPI.getNoteDetails(id);
    if (res is GetNotesTodoListResponse) {
      (view as AddNoteContract).getNoteDetails(res.data[0]);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
