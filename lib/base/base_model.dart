class BaseModel {
  // String message;
  BaseModel();

  BaseModel.fromJSON(dynamic data) {
    // print("from JSON");
    // if (data != null) {
    //   if (data is String) {
    //     message = data;
    //   } else {
    //     if (data['message'] != null) {
    //       message = data['message'];
    //     }
    //   }
    // }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    // print("to map");
    // map["message"] = message;
    return map;
  }
}
