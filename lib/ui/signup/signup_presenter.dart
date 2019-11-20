import 'dart:io';

import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/user.dart';

abstract class SignUpContract extends BaseContract {
  void signUpSuccess();
}

class SignUpPresenter extends BasePresenter {
  SignUpPresenter(BaseContract view) : super(view);

  void signUpUser(
      String firstName,
      String lastName,
      String email,
      String password,
      String phone,
      String address,
      String city,
      String state,
      String zipcode,
      File file,
      String primaryInstrument,
      bool isUnderAge,
      String gName,
      String gEmail) async {
    final res = await serverAPI.register(
        User(
            address: address,
            city: city,
            email: email,
            firstName: firstName,
            lastName: lastName,
            password: password,
            phone: phone,
            state: state,
            zipcode: zipcode,
            guardianEmail: gEmail,
            guardianName: gName,
            isUnder18Age: isUnderAge,
            primaryInstrument: primaryInstrument),
        file);
    print("REs-> $res");
    if (res is String) {
      (view as SignUpContract).signUpSuccess();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
