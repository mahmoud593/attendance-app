class GeneralNotificationModel {
  String? title;
  String? body;
  String? uId;
  String? date;
  String? id;
  List? uIds;
  Map? replies;


  GeneralNotificationModel({
    required this.title,
    required this.id,
    required this.body,
    required this.uId,
    required this.date,
    required this.uIds,
    required this.replies,
  });


  GeneralNotificationModel.fromJson(Map<dynamic, dynamic> json) {
    title = json['title']??'';
    id = json['id']??'';
    body = json['body']??'';
    uId = json['uId']??'';
    date = json['date']??'';
    uIds= json['uIds']??[];
    replies= json['replies']??{};
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    data['uId'] = uId;
    data['date'] = date;
    data['uIds'] = uIds;
    data['replies'] = replies;
    return data;
  }
}