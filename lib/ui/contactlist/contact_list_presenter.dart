import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/contacts.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/get_contact_list_response.dart';

abstract class ContactListContract extends BaseContract {
  void onContactListSuccess(List<Contacts> contacts);
}

class ContactListPresenter extends BasePresenter {
  ContactListPresenter(BaseContract view) : super(view);

  void getContacts() async {
    final res = await serverAPI.getContacts();
    if (res is GetContactListResponse) {
      (view as ContactListContract).onContactListSuccess(res.data);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
