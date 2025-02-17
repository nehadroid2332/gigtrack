import 'package:gigtrack/base/base_model.dart';

import 'band.dart';

class UserInstrument extends BaseModel {
  String band_id;
  String id;
  String user_id;
  String name;
  String purchased_from;
  int purchased_date;
  String serial_number;
  String warranty;
  int warranty_end_date;
  String warranty_reference;
  String warranty_phone;
  String photo;
  bool is_insured;
  String image;
  String cost;
  String nickName;
  String insuranceno;
  String policyno;
  bool isWarranty;
  bool isInsurance;
  Band band;
  List<dynamic> uploadedFiles = [];
  List<dynamic> receiptFiles = [];
  String bandId;
  List<SubInstrumentNotes> subNotes = [];

  UserInstrument(
      {this.band_id,
      this.id,
      this.is_insured,
      this.name,
      this.photo,
      this.bandId,
      this.purchased_date,
      this.purchased_from,
      this.serial_number,
      this.cost,
      this.user_id,
      this.warranty,
      this.warranty_end_date,
      this.warranty_phone,
      this.warranty_reference,
      this.nickName,
      this.insuranceno,
      this.uploadedFiles,
      this.policyno,
      this.isWarranty,
        this.receiptFiles,
      this.isInsurance});

  UserInstrument.fromJSON(dynamic data) {
    this.band_id = data['band_id'];
    this.id = data['id'];
    this.is_insured = data['is_insured'];
    this.name = data['name'];
    this.photo = data['photo'];
    this.purchased_date = data['purchased_date'];
    this.purchased_from = data['purchased_from'];
    this.serial_number = data['serial_number'];
    this.user_id = data['user_id'];
    this.warranty = data['warranty'];
    this.warranty_end_date = data['warranty_end_date'];
    this.warranty_phone = data['warranty_phone'];
    this.warranty_reference = data['warranty_reference'];
    this.image = data['image'];
    this.cost = data['cost'];
    this.bandId = data['bandId'];
    this.nickName = data['nick_name'];
    this.policyno = data['policy_no'];
    this.insuranceno = data['insurance_no'];
    this.isWarranty = data['isWarranty'];
    this.isInsurance = data['isInsurance'];
    if (data['uploadedFiles'] != null)
      this.uploadedFiles = data['uploadedFiles'];
    if (data['receiptFiles'] != null)
      this.receiptFiles = data['receiptFiles'];
    if (data['subInstrumentNotes'] != null) {
      for (var item in data['subInstrumentNotes']) {
        subNotes.add(SubInstrumentNotes.fromJSON(item));
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    final data = super.toMap();
    data['band_id'] = band_id ?? "";
    data['id'] = id ?? "";
    data['is_insured'] = is_insured ?? false;
    data['name'] = name ?? "";
    data['bandId'] = bandId;
    data['photo'] = photo ?? "";
    data['purchased_date'] = purchased_date ?? "";
    data['purchased_from'] = purchased_from ?? "";
    data['serial_number'] = serial_number ?? "";
    data['user_id'] = user_id ?? "";
    data['warranty'] = warranty ?? "";
    data['warranty_end_date'] = warranty_end_date ?? "";
    data['warranty_phone'] = warranty_phone ?? "";
    data['warranty_reference'] = warranty_reference ?? "";
    data['image'] = image;
    data['uploadedFiles'] = uploadedFiles;
    data['receiptFiles']=receiptFiles;
    data['cost'] = cost;
    data['nick_name'] = nickName ?? "";
    data['insurance_no'] = insuranceno ?? "";
    data['policy_no'] = policyno ?? "";
    data['isInsurance'] = isInsurance ?? false;
    data['isWarranty'] = isWarranty ?? false;
    final subbs = <dynamic>[];
    for (var item in subNotes) {
      subbs.add(item.toMap());
    }
    data['subInstrumentNotes'] = subbs;
    return data;
  }
}

class SubInstrumentNotes extends BaseModel {
  String id;
  String title;
  int createdDate;
  SubInstrumentNotes();

  SubInstrumentNotes.fromJSON(dynamic data) {
    id = data['id'];
    title = data['title'];
    createdDate = data['createdDate'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['id'] = id;
    data['title'] = title;
    data['createdDate'] = createdDate;
    return data;
  }
}
