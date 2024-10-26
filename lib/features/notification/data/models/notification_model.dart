class NotificationModel {
  String? title;
  String? body;
  String? uId;
  String? date;


  NotificationModel({
    required this.title,
    required this.body,
    required this.uId,
    required this.date,
  });


  NotificationModel.fromJson(Map<dynamic, dynamic> json) {
    title = json['title']??'';
    body = json['body']??'';
    uId = json['uId']??'';
    date = json['date']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    data['uId'] = uId;
    data['date'] = date;
    return data;
  }
}