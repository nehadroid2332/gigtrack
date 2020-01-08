import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/contacts.dart';
import 'package:gigtrack/server/models/user.dart';

abstract class ContactListContract extends BaseContract {}

class ContactListPresenter extends BasePresenter {
  ContactListPresenter(BaseContract view) : super(view);

  Stream<List<Contacts>> getContacts(String bandId, {String contactInit}) {
    // if (bandId != null && bandId.isNotEmpty)
    //   return serverAPI.contactDB
    //       .orderByChild('bandId')
    //       .equalTo(bandId)
    //       .onValue
    //       .map((a) {
    //     Map mp = a.snapshot.value;
    //     if (mp == null) return null;
    //     List<Contacts> acc = [];
    //     for (var d in mp.values) {
    //       final contact = Contacts.fromJSON(d);

    //       // if (contactInit != null &&
    //       //     getNameOrder(contact.name)[0].toLowerCase() ==
    //       //         contactInit.toLowerCase()) {
    //       //   acc.add(contact);
    //       // } else if (contactInit.isEmpty) {
    //       //   acc.add(contact);
    //       // }
    //       if (contactInit != null) {
    //         if (contact.name.toLowerCase().contains(contactInit.toLowerCase()))
    //           acc.add(contact);
    //       } else
    //         acc.add(contact);
    //       // if (acc.length < 0) {
    //       //   acc.add((contact));
    //       // }
    //     }
    //     acc.sort((a, b) {
    //       return a.name
    //           .split(" ")
    //           .last
    //           .toLowerCase()
    //           .compareTo(b.name.split(" ").last.toLowerCase());
    //     });
    //     return acc;
    //   });
    // else
    return serverAPI
        .contactDB
        // .orderByChild('user_id')
        //  .equalTo(serverAPI.currentUserId)
        .onValue
        .asyncMap((a) async {
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
        // if (contactInit != null &&
        //     getNameOrder(contact.name)[0].toLowerCase() ==
        //         contactInit.toLowerCase()) {
        //   if (contact.user_id == serverAPI.currentUserId) {
        //     acc.add(contact);
        //   } else if (contact.user_id != null) {
        //     final res = await serverAPI.getSingleUserById(contact.user_id);
        //     if (res is User && (res.isUnder18Age ?? false)) {
        //       if (res.guardianEmail == serverAPI.currentUserEmail) {
        //         acc.add(contact);
        //       }
        //     }
        //   }
        // } else {
        //   acc.add(contact);
        // }
        if (contact.user_id == serverAPI.currentUserId ||
            contact.bandId == bandId) {
          if (contactInit != null) {
            if (contact.name.toLowerCase().contains(contactInit.toLowerCase()))
              acc.add(contact);
          } else
            acc.add(contact);
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
}
