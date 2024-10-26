class ApplogizeModel {
  String? startDay;
  String? day;
  String? numDays;
  String? endDay;
  String? reason;
  String? image;
  String? mainGroup;
  String? subGroup;
  String? organizationId;
  String? folderNum;
  String? uId;
  String? email;
  String? userName;
  String? fullName;
  String? applogizeId;
  String? status;

  ApplogizeModel({
    required this.email,
    required this.day,
    required this.mainGroup,
    required this.subGroup,
    required this.organizationId,
    required this.userName,
    required this.fullName,
    required this.numDays,
    required this.folderNum,
    required this.uId,
    required this.applogizeId,
    required this.startDay,
    required this.endDay,
    required this.reason,
    required this.status,
    required this.image
  });


  ApplogizeModel.fromJson(Map<dynamic, dynamic> json) {
    email = json['email']??'';
    mainGroup = json['mainGroup']??'';
    subGroup = json['subGroup']??'';
    day = json['day']??'';
    organizationId = json['organizationId']??'';
    userName = json['userName']??'';
    fullName = json['fullName']??'';
    folderNum = json['folderNum']??'';
    numDays = json['numDays']??'';
    uId = json['uId']??'';
    applogizeId = json['applogizeId']??'';
    startDay = json['startDay']??'';
    endDay = json['endDay']??'';
    reason = json['reason']??'';
    image = json['image']??'';
    status = json['status']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['mainGroup'] = mainGroup;
    data['subGroup'] = subGroup;
    data['organizationId'] = organizationId;
    data['userName'] = userName;
    data['fullName'] = fullName;
    data['folderNum'] = folderNum;
    data['day'] = day;
    data['uId'] = uId;
    data['numDays'] = numDays;
    data['applogizeId'] = applogizeId;
    data['startDay'] = startDay;
    data['endDay'] = endDay;
    data['reason'] = reason;
    data['status'] = status;
    data['image'] = image;
    return data;
  }
}