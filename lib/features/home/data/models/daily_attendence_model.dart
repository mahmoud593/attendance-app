
class DailyAttendenceModel {
  String? date;
  String? subGroup;
  String? notification;
  String? memberPhone;
  String? memberName;
  String? memberId;
  String? memberEmail;
  String? mainGroup;
  String? lateFingureTime;
  String? lateFingure;
  String? earlyFingureTime;
  String? earlyFingure;


  DailyAttendenceModel({

    required this.date,
    required this.subGroup,
    required this.notification,
    required this.memberPhone,
    required this.memberName,
    required this.memberId,
    required this.memberEmail,
    required this.mainGroup,
    required this.lateFingureTime,
    required this.lateFingure,
    required this.earlyFingureTime,
    required this.earlyFingure,


  });


  DailyAttendenceModel.fromJson(Map<dynamic, dynamic> json) {

    date = json['date']??'';
    subGroup = json['subGroup']??'';
    notification = json['notification']??'';
    memberPhone = json['memberPhone']??'';
    memberName = json['memberName']??'';
    memberId = json['memberId']??'';
    memberEmail = json['memberEmail']??'';
    mainGroup = json['mainGroup']??'';
    lateFingureTime = json['lateFingureTime']??'';
    lateFingure = json['lateFingure']??'';
    earlyFingureTime = json['earlyFingureTime']??'';
    earlyFingure = json['earlyFingure']??'';

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['date'] = date;
    data['subGroup'] = subGroup;
    data['notification'] = notification;
    data['memberPhone'] = memberPhone;
    data['memberName'] = memberName;
    data['memberId'] = memberId;
    data['memberEmail'] = memberEmail;
    data['mainGroup'] = mainGroup;
    data['lateFingureTime'] = lateFingureTime;
    data['lateFingure'] = lateFingure;
    data['earlyFingureTime'] = earlyFingureTime;
    data['earlyFingure'] = earlyFingure;

    return data;
  }

}