import 'dart:convert';

import 'package:attendience_app/core/helper/constants.dart';
import 'package:attendience_app/core/shared_preference/shared_preference.dart';
import 'package:attendience_app/features/auth/data/auth_repo/auth_repo.dart';
import 'package:attendience_app/features/auth/data/models/member_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthRepoImplement implements AuthRepo{

  @override
  Future<MemberModel> getMemberInfo({
   required String memberId,
   required String macAddress,
  })async {

    MemberModel? memberModel;

    var response = await Constants.database.child('members').child(memberId).get();

    memberModel = MemberModel.fromJson(response.value as Map<dynamic,dynamic>);

    print('Mac Addrees from model${memberModel.macAddress} ');
    if(memberModel.macAddress == ''){
      print('here');
      Constants.database.
      child('members').child(memberModel.uId!).update(
        {
          'macAddress' : macAddress,
        }
      );

      UserDataFromStorage.setEmail(memberModel.email!);
      UserDataFromStorage.setPhoneNumber(memberModel.phone!);
      UserDataFromStorage.setMainGroup(memberModel.mainGroup!);
      UserDataFromStorage.setSubGroup(memberModel.subGroup!);
      UserDataFromStorage.setFullName(memberModel.fullName!);
      UserDataFromStorage.setUserName(memberModel.userName!);
      UserDataFromStorage.setFolderNum(memberModel.folderNum!);
      UserDataFromStorage.setOrganizationId(memberModel.organizationId!);

      print('Get member info : ${memberModel.email}');
      UserDataFromStorage.setThemeIsDarkMode(true);

    }else{
      if(memberModel.macAddress == macAddress){

        print('here2');
        UserDataFromStorage.setEmail(memberModel.email!);
        UserDataFromStorage.setPhoneNumber(memberModel.phone!);
        UserDataFromStorage.setMainGroup(memberModel.mainGroup!);
        UserDataFromStorage.setSubGroup(memberModel.subGroup!);
        UserDataFromStorage.setFullName(memberModel.fullName!);
        UserDataFromStorage.setUserName(memberModel.userName!);
        UserDataFromStorage.setFolderNum(memberModel.folderNum!);
        UserDataFromStorage.setOrganizationId(memberModel.organizationId!);

        print('Get member info : ${memberModel.email}');
        UserDataFromStorage.setThemeIsDarkMode(true);
      }else{

        print('here3');
        print('Different mac address');
        UserDataFromStorage.setThemeIsDarkMode(false);
      }

    }

    return memberModel;

  }

  @override
  Future<dynamic> loginAsMember({required String email, required String password,required String macAddress}) async{

   try{
     var response = await FirebaseAuth.instance.signInWithEmailAndPassword(
         email:email,
         password: password
     );

     print('Login as member : ${response.user!.uid}');

     UserDataFromStorage.setUid(response.user!.uid);

     getMemberInfo(memberId: response.user!.uid,macAddress: macAddress);

     return response;
   }catch (e){
     print('Error in login member : ${e.toString()}');
     print(e.toString());
     return '';
   }


  }

  @override
  Future<dynamic> registerAsMember(
      {required String email,
        required String mainGroup,
        required String subGroup,
        required String organizationId,
        required String password,
        required String userName,
        required String fullName,
        required String folderNum,
        required String phone
      })
  async{

    try{
      var response = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      if(response.user != null){
        saveMemberInfo(
            email: email,
            mainGroup: mainGroup,
            subGroup: subGroup,
            organizationId: organizationId,
            password: password,
            userName: userName,
            fullName: fullName,
            folderNum: folderNum,
            phone: phone,
            uId: response.user!.uid
        );
      }
      return response;

    }catch (e){
      print('Error in register member : ${e.toString()}');
      print(e.toString());
      return '';
    }




  }

  @override
  Future<void> saveMemberInfo(
      {required String email,
        required String mainGroup,
        required String subGroup,
        required String organizationId,
        required String password,
        required String userName,
        required String fullName,
        required String folderNum,
        required String phone,
        required String uId,
      }) async{

    MemberModel memberModel = MemberModel(
      email: email,
      mainGroup: mainGroup,
      subGroup: subGroup,
      organizationId: organizationId,
      password: password,
      userName: userName,
      fullName: fullName,
      folderNum: folderNum,
      phone: phone,
      macAddress: '',
      uId: uId
    );

    try{
      DatabaseReference  databaseReference = Constants.database.
      child('organztions').
      child(organizationId).
      child('groups').
      child(mainGroup).
      child('subGroups').
      child(subGroup).
      child('members').child(uId);

      await databaseReference.set(memberModel.toJson());
    }catch (e){
      print('Error in save member : ${e.toString()}');
    }

    try{
      DatabaseReference  databaseReference2 = Constants.database.
      child('members').child(uId);

      await databaseReference2.set(memberModel.toJson());
    }catch (e){
      print('Error in save members only : ${e.toString()}');
    }




  }


}

