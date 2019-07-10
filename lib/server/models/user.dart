import 'package:gigtrack/base/base_model.dart';

class User extends BaseModel {
  String firstName;
  String lastName;
  String email;
  String password;
  String phone;
  String address;
  String city;
  String state;
  String zipcode;
  String primaryInstrument;
  String profilePic;

  User(
      {this.address,
      this.city,
      this.email,
      this.firstName,
      this.lastName,
      this.password,
      this.phone,
      this.state,
      this.primaryInstrument,
      this.profilePic,
      this.zipcode});

  User.fromJSON(dynamic data) {
    firstName = data['first_name'];
    lastName = data['last_name'];
    email = data['email'];
    password = data['password'];
    phone = data['phone'];
    address = data['address'];
    city = data['city'];
    state = data['state'];
    zipcode = data['zipcode'];
    primaryInstrument = data['primary_instrument'];
    profilePic = data['profile_pic'];
  }
  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();

    data["first_name"] = firstName ?? "";
    data["last_name"] = lastName ?? "";
    data["email"] = email ?? "";
    data["password"] = password ?? "";
    data["phone"] = phone ?? "";
    data["address"] = address ?? "";
    data["city"] = city ?? "";
    data["state"] = state ?? "";
    data["zipcode"] = zipcode ?? "";
    data['profile_pic'] = profilePic ?? "";
    data['primary_instrument'] = primaryInstrument ?? "";
    return data;
  }

  Map<String, String> toStringMap() {
    Map<String, String> data = Map();

    data["first_name"] = firstName ?? "";
    data["last_name"] = lastName ?? "";
    data["email"] = email ?? "";
    data["password"] = password ?? "";
    data["phone"] = phone ?? "";
    data["address"] = address ?? "";
    data["city"] = city ?? "";
    data["state"] = state ?? "";
    data["zipcode"] = zipcode ?? "";
    data['profile_pic'] = profilePic ?? "";
    data['primary_instrument'] = primaryInstrument ?? "";
    return data;
  }
}
