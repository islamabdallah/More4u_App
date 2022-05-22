class BaseResponseModel {
  late bool flag;
  late String message;

  // BaseResponseModel({required this.flag, required this.message});

  BaseResponseModel.fromJson(Map<String, dynamic> json) {
    flag = json["flag"];
    message = json["message"];
  }

// factory BaseResponseModel.fromJson(Map<String, dynamic> json) =>
//     BaseResponseModel(flag: json['flag'], message: json['message']);
}
