import 'dart:io';

import 'package:attendience_app/core/helper/constants.dart';
import 'package:attendience_app/core/shared_preference/shared_preference.dart';
import 'package:attendience_app/features/auth/data/auth_repo_implement/auth_repo_implement.dart';
import 'package:attendience_app/features/auth/data/models/member_model.dart';
import 'package:attendience_app/features/auth/presentaion/controller/auth_states.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/widets/toast.dart';
import 'package:attendience_app/styles/widets/toastification_widget.dart';
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:toastification/toastification.dart';

class AuthCubit extends Cubit<AuthStates> {

  AuthCubit() :super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of(context);

  TextEditingController emailController = TextEditingController();
  TextEditingController mainGroupController = TextEditingController();
  TextEditingController subGroupController = TextEditingController();
  TextEditingController organizationIdController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController folderNumController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController passwordLoginController = TextEditingController();
  TextEditingController emailLoginController = TextEditingController();


  Future<void> createMemberAccount({
    required String email,
    required String mainGroup,
    required String subGroup,
    required String organizationId,
    required String password,
    required String userName,
    required String fullName,
    required String folderNum,
    required String phone,
  }) async {
    emit(CreateMemberAccountLoadingState());

    try {
      var response =  await AuthRepoImplement().registerAsMember(
          email: email,
          mainGroup: mainGroup,
          subGroup: subGroup,
          organizationId: organizationId,
          password: password,
          userName: userName,
          fullName: fullName,
          folderNum: folderNum,
          phone: phone
      );

      if(response != ''){
        emit(CreateMemberAccountSuccessState());
      }

    } catch (e) {
      print('Error in createMemberAccount member : ${e.toString()}');
      emit(CreateMemberAccountErrorState());
    }
  }

  String? macAddress;

  Future<void> getMacAddress() async {
      var deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) { // import 'dart:io'
        var iosDeviceInfo = await deviceInfo.iosInfo;
        macAddress= iosDeviceInfo.identifierForVendor; // unique ID on iOS
        UserDataFromStorage.setMacAddress(macAddress!);
        print('MAC Address: $macAddress');
      } else if(Platform.isAndroid) {
        var androidDeviceInfo = await deviceInfo.androidInfo;
        macAddress= androidDeviceInfo.id; // un
        UserDataFromStorage.setMacAddress(macAddress!); // ique ID on Android
        print('MAC Address: $macAddress');
      }
      //
    // final info = NetworkInfo();
    //
    // try {
    //   macAddress = await info.getWifiBSSID();
    //   print("MAC Address: $macAddress");
    // } catch (e) {
    //   print("Error fetching MAC address: $e");
    // }
  }

  Future<void> memberLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    emit(LoginMemberLoadingState());

    await getMacAddress();

    try {
      var response  = await AuthRepoImplement().loginAsMember(
          email: email,
          password: password,
          macAddress: macAddress!
      ).then((value){
        if(UserDataFromStorage.emailNotFound==true){
        if(value != '' && UserDataFromStorage.themeIsDarkMode == true){
          print('Success');
          emit(LoginMemberSuccessState());
        }
        else{
          if(UserDataFromStorage.themeIsDarkMode == false){
            toastificationWidget(context: context, title: 'هذا الحساب مملوك لشخص اخر', body: 'تم تسجيل بيانات الحساب في جهاز اخر حاول التسجيل من الجهاز المسجل مسبق',
                type: ToastificationType.error);
            print('Error');
            emit(LoginMemberErrorState());
          }else{
            customToast(title: 'البريد الالكتروني او كلمة المرور غير صحيح', color: Colors.red);
            print('Error');
            emit(LoginMemberErrorState());
          }
        }
      }else{
      customToast(title: 'البريد الالكتروني او كلمه المرور غير صحيحه', color: ColorManager.error);
      emit(LoginMemberErrorState());
      }
      });

    } catch (e) {
      print('Error in memberLogin member : ${e.toString()}');
      emit(LoginMemberErrorState());
    }
  }

  Future<void> updateMemberInfo({
   required String fullName,
   required String phoneNumber,
   required String email,
   required String userName,
 })async{

    emit(UpdateMemberLoadingState());
  try{
    Constants.database.child('members').child(UserDataFromStorage.uIdFromStorage).update({
      'fullName':fullName,
      'phone':phoneNumber,
      'email':email,
      'userName':userName
    });

    customToast(title: 'تم تحديث البيانات بنجاح', color: ColorManager.primaryBlue);
    print('update member success');
    UserDataFromStorage.setFullName(fullName);
    UserDataFromStorage.setPhoneNumber(phoneNumber);
    UserDataFromStorage.setEmail(email);
    UserDataFromStorage.setUserName(userName);
    emit(UpdateMemberSuccessState());
  }catch (e){
    print('Error in update member : ${e.toString()}');
    emit(UpdateMemberErrorState());
  }

  try{
    Constants.database.child('organztions').child(UserDataFromStorage.organizationIdFromStorage).
    child('groups').child(UserDataFromStorage.mainGroupFromStorage).child('subGroups').
    child(UserDataFromStorage.subGroupFromStorage).
    child('members').child(UserDataFromStorage.uIdFromStorage).update({
      'fullName':fullName,
      'phone':phoneNumber,
      'email':email,
      'userName':userName
    });

    print('update member success');
    emit(UpdateMemberSuccessState());
  }catch (e){
    print('Error in update member : ${e.toString()}');
    emit(UpdateMemberErrorState());
  }

}

  Future<void> getHomeMember({
    required String memberId,
    required String macAddress,
  })async {

    MemberModel? memberModel;

    var response = await Constants.database.child('members').child(memberId).get();

    memberModel = MemberModel.fromJson(response.value as Map<dynamic,dynamic>);

    UserDataFromStorage.setMacAddress(macAddress);
    UserDataFromStorage.setUid(memberId);
    UserDataFromStorage.setAdminName(memberModel.fullName!);
    UserDataFromStorage.setAttendenceAdmin(memberModel.attendanceAdmin!);
    UserDataFromStorage.setGradeAdmin(memberModel.gradesAdmin!);

    UserDataFromStorage.setEmail(memberModel.email!);
    UserDataFromStorage.setPhoneNumber(memberModel.phone!);
    UserDataFromStorage.setMainGroup(memberModel.mainGroupName!);
    UserDataFromStorage.setSubGroup(memberModel.subGroupName!);
    UserDataFromStorage.setFullName(memberModel.fullName!);
    UserDataFromStorage.setUserName(memberModel.userName!);
    UserDataFromStorage.setFolderNum(memberModel.folderNum!);
    UserDataFromStorage.setOrganizationId(memberModel.organizationId!);

    print('Get member info : ${memberModel.email}');

  }


}