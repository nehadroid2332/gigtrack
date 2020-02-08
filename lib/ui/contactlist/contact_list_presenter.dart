import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/contacts.dart';

abstract class ContactListContract extends BaseContract {
  void onBandDetails(Band res);
}

class ContactListPresenter extends BasePresenter {
  ContactListPresenter(BaseContract view) : super(view);

  Stream<List<Contacts>> getContacts(String bandId, {String contactInit}) {
    return serverAPI.contactDB.onValue.asyncMap((a) async {
      Map mp = a.snapshot.value;
      if (mp == null) return null;
      List<Contacts> acc = [];
      for (var d in mp.values) {
        final contact = Contacts.fromJSON(d);
        if (contact.bandId != null && contact.bandId.isNotEmpty) {
          final res = await serverAPI.getBandDetails(contact.bandId);
          if (res != null && res is Band) {
            contact.band = res;
          }
        }

        if (bandId.isEmpty) {
          if (contact.band != null) {
            if (contact.band.bandmates.keys
                    .contains(serverAPI.currentUserEmail.replaceAll(".", "")) ||
                contact.band.userId == serverAPI.currentUserId) {
              if (contactInit != null) {
                if (contact.name
                    .toLowerCase()
                    .contains(contactInit.toLowerCase())) acc.add(contact);
              } else {
                acc.add(contact);
              }
            }
          }
          if (contact.userId == serverAPI.currentUserId) {
            if (acc.contains(contact)) {
              continue;
            } else {
              if (contactInit != null) {
                if (contact.name
                    .toLowerCase()
                    .contains(contactInit.toLowerCase())) acc.add(contact);
              } else {
                acc.add(contact);
              }
            }
          }
        } else {
          if (contact.bandId == bandId) {
            if (contactInit != null) {
              if (contact.name
                  .toLowerCase()
                  .contains(contactInit.toLowerCase())) acc.add(contact);
            } else
              acc.add(contact);
          }
        }
      }
      acc.sort((a, b) {
        return a.name
            .split(" ")
            .last
            .toLowerCase()
            .compareTo(b.name.split(" ").last.toLowerCase());
      });
      return acc;
    });
  }

  String getNameOrder(String name) {
    List traversedname = name.split(" ");
    int namelength = traversedname.length;
    if (traversedname.length > 1) {
      String lastname = "" + traversedname.last + ", ";
      traversedname.removeLast();
      return lastname + "" + traversedname.join(' ');
    } else {
      return traversedname.last;
    }
  }

  void getBand(String bandId) async {
    final res = await serverAPI.getBandDetails(bandId);
    if (res is Band) {
      (view as ContactListContract).onBandDetails(res);
    }
  }
}
