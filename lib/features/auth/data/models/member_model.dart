class MemberModel {
   String? email;
   String? mainGroup;
   String? subGroup;
   String? organizationId;
   String? password;
   String? userName;
   String? fullName;
   String? folderNum;
   String? phone;
   String? uId;
   String? macAddress;
   bool? gradesAdmin;
   bool? attendanceAdmin;

  MemberModel({
    required this.email,
    required this.mainGroup,
    required this.subGroup,
    required this.organizationId,
    required this.password,
    required this.userName,
    required this.fullName,
    required this.folderNum,
    required this.phone,
    required this.uId,
    required this.macAddress,
    required this.gradesAdmin,
    required this.attendanceAdmin,
  });


  MemberModel.fromJson(Map<dynamic, dynamic> json) {
    email = json['email']??'';
    mainGroup = json['mainGroup']??'';
    subGroup = json['subGroup']??'';
    organizationId = json['organizationId']??'';
    password = json['password']??'';
    userName = json['userName']??'';
    fullName = json['fullName']??'';
    folderNum = json['folderNum']??'';
    phone = json['phone']??'';
    uId = json['uId']??'';
    gradesAdmin = json['gradesAdmin']??false;
    attendanceAdmin = json['attendanceAdmin']??false;
    macAddress = json['macAddress']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['email'] = email;
    data['mainGroup'] = mainGroup;
    data['subGroup'] = subGroup;
    data['organizationId'] = organizationId;
    data['password'] = password;
    data['userName'] = userName;
    data['fullName'] = fullName;
    data['folderNum'] = folderNum;
    data['phone'] = phone;
    data['uId'] = uId;
    data['macAddress'] = macAddress;

    return data;
  }
}