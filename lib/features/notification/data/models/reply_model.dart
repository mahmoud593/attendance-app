class ReplyModel {
  String? message;
  bool? fromSystem;
  String? uId;
  String? date;
  String? name;


  ReplyModel({
    required this.message,
    required this.fromSystem,
    required this.uId,
    required this.name,
    required this.date,
  });


  ReplyModel.fromJson(Map<dynamic, dynamic> json) {
    message = json['message']??'';
    fromSystem = json['formSystem']??false;
    uId = json['uId']??'';
    date = json['date']??'';
    name = json['name']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['formSystem'] = fromSystem;
    data['uId'] = uId;
    data['date'] = date;
    data['name'] = name;
    return data;
  }
}