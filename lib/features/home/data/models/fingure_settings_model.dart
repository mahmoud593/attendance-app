class FingureSettingsModel {
  String? absenceTime;
  String? attendTime;
  String? delayTime;
  String? departureTime;
  bool? isEducational;
  int? timeToCalculateAttendance;
  int? workingHours;
  List? location;


  FingureSettingsModel({
    required this.absenceTime,
    required this.attendTime,
    required this.delayTime,
    required this.departureTime,
    required this.isEducational,
    required this.timeToCalculateAttendance,
    required this.workingHours,
    required this.location,
  });


  FingureSettingsModel.fromJson(Map<dynamic, dynamic> json) {
    absenceTime = json['absenceTime']??'';
    attendTime = json['attendTime']??'';
    delayTime = json['delayTime']??'';
    departureTime = json['departureTime']??'';
    isEducational = json['isEducational']??'';
    timeToCalculateAttendance = json['timeToCalculateAttendance']??'';
    workingHours = json['workingHours']??'';
    location =  json['location']??[];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['absenceTime'] = absenceTime;
    data['attendTime'] = attendTime;
    data['delayTime'] = delayTime;
    data['departureTime'] = departureTime;
    data['isEducational'] = isEducational;
    data['timeToCalculateAttendance'] = timeToCalculateAttendance;
    data['workingHours'] = workingHours;
    data['location'] = location;
    return data;
  }

}