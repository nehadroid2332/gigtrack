import 'package:gigtrack/base/base_model.dart';

class Payment extends BaseModel {
  String image;
  String amount;
  String paymentStatus;
  String paymentPurpose;
  String notes;
  String id;
  int type;
  String user_id;
  int created = DateTime.now().millisecondsSinceEpoch;

  static const int TYPE_PAID = 1;
  static const int TYPE_RECIEVE = 2;

  Payment(
      {this.image,
      this.notes,
      this.amount,
      this.id,
      this.user_id,
      this.type,
      this.paymentPurpose,
      this.paymentStatus,
      this.created});

  Payment.fromJSON(dynamic data) {
    id = data['id'];
    user_id = data['user_id'];
    image = data['image'];
    amount = data['amount'];
    notes = data['notes'];
    type = data['type'];
    paymentStatus = data['paymentStatus'];
    paymentPurpose = data['paymentPurpose'];
    created = data['created'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['image'] = image;
    data['id'] = id;
    data['type'] = type;
    data['user_id'] = user_id;
    data['paymentPurpose'] = paymentPurpose;
    data['amount'] = amount;
    data['paymentStatus'] = paymentStatus;
    data['created'] = created;
    data['notes'] = notes;
    return data;
  }
}
