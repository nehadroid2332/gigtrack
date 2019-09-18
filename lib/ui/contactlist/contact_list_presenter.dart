import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/contacts.dart';

abstract class ContactListContract extends BaseContract {}

class ContactListPresenter extends BasePresenter {
  ContactListPresenter(BaseContract view) : super(view);

  Stream<List<Contacts>> getContacts() {
    return serverAPI.contactDB
        .orderByChild('user_id')
        .equalTo(serverAPI.currentUserId)
        .onValue
        .map((a) {
      Map mp = a.snapshot.value;
      if (mp == null) return null;
      List<Contacts> acc = [];
      for (var d in mp.values) {
        acc.add(Contacts.fromJSON(d));
      }
      return acc;
    });
  }
}
