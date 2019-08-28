import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/add_contact_response.dart';
import 'package:gigtrack/server/models/contacts.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/get_contact_list_response.dart';

abstract class AddContactContract extends BaseContract {
  void onSuccess();

  void getContactDetails(Contacts data);
}

class AddContactPresenter extends BasePresenter {
  AddContactPresenter(BaseContract view) : super(view);

  void addContact(Contacts contacts) async {
    final res = await serverAPI.addContact(contacts);
    if (res is AddContactResponse) {
      (view as AddContactContract).onSuccess();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void contactDetails(String id) async {
    final res = await serverAPI.getContactDetails(id);
    if (res is GetContactListResponse) {
      (view as AddContactContract).getContactDetails(res.data[0]);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
