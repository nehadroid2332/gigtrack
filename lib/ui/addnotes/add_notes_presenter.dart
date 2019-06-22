import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/note_todo_response.dart';
import 'package:gigtrack/server/models/notestodo.dart';

abstract class AddNoteContract extends BaseContract {
  void onSuccess(NoteTodoResponse res);
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
}
