import 'package:gigtrack/base/base_model.dart';

class User extends BaseModel {
  String id;
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
  String dep18;

  String status;

  bool isUnder18Age = false;
  String guardianEmail;
  String guardianName;

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
      this.zipcode,
      this.isUnder18Age,
      this.guardianEmail,
      this.guardianName,
      this.status});

  User.fromJSON(dynamic data) {
    if (data['id'] != null) id = data['id'];
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
    dep18 = data['dep18'];
    isUnder18Age = data['isUnder18Age'];
    guardianEmail = data['guardianEmail'];
    guardianName = data['guardianName'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['id'] = id ?? "";
    data["first_name"] = firstName ?? "";
    data["last_name"] = lastName ?? "";
    data["email"] = email ?? "";
    data["password"] = password ?? "";
    data["phone"] = phone ?? "";
    data["address"] = address ?? "";
    data["city"] = city ?? "";
    data['dep18'] = dep18;
    data["state"] = state ?? "";
    data["zipcode"] = zipcode ?? "";
    data['profile_pic'] = profilePic ?? "";
    data['primary_instrument'] = primaryInstrument ?? "";
    data['isUnder18Age'] = isUnder18Age;
    data['guardianName'] = guardianName;
    data['guardianEmail'] = guardianEmail;
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
