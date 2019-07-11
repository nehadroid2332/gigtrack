import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/notes_todo_list_response.dart';
import 'package:gigtrack/server/models/notestodo.dart';

abstract class NotesListContract extends BaseContract {
  void getNotes(List<NotesTodo> data);
}

class NotesListPresenter extends BasePresenter {
  NotesListPresenter(BaseContract view) : super(view);

  void getNotes() async {
    final res = await serverAPI.getNotes();
    final res2 = await serverAPI.getTodos();
    if (res is GetNotesTodoListResponse || res2 is GetNotesTodoListResponse) {
      final data = <NotesTodo>[];
      if (res is GetNotesTodoListResponse) data.addAll(res.data);
      if (res2 is GetNotesTodoListResponse) data.addAll(res2.data);
      (view as NotesListContract).getNotes(data);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    } else if (res2 is ErrorResponse) {
      view.showMessage(res2.message);
    }
  }
}
