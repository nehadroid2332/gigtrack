import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/contacts.dart';
import 'package:gigtrack/server/models/error_response.dart';

abstract class AddContactContract extends BaseContract {
  void onSuccess();
  void getContactDetails(Contacts data);
  void onUpdate();
}

class AddContactPresenter extends BasePresenter {
  AddContactPresenter(BaseContract view) : super(view);

  void addContact(Contacts contacts) async {
    contacts.user_id = serverAPI.currentUserId;
    final res = await serverAPI.addContact(contacts);
    if (res is bool) {
      if (res)
        (view as AddContactContract).onUpdate();
      else
        (view as AddContactContract).onSuccess();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void contactDelete(String id) async {
    serverAPI.deleteContact(id);
  }

  void contactDetails(String id) async {
    final res = await serverAPI.getContactDetails(id);
    if (res is Contacts) {
      (view as AddContactContract).getContactDetails(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void addContactNote(List<SubContact> subContacts, String id) async {
    final res = await serverAPI.getContactDetails(id);
    if (res is Contacts) {
      res.subContacts = subContacts;
      await serverAPI.addContact(res);
      (view as AddContactContract).getContactDetails(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
