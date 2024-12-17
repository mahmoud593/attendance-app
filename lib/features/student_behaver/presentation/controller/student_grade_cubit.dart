import 'package:attendience_app/core/helper/constants.dart';
import 'package:attendience_app/core/shared_preference/shared_preference.dart';
import 'package:attendience_app/features/student_behaver/presentation/controller/student_grade_states.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/widets/toast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class StudentGradeCubit extends Cubit<StudentGradeStates>{

  StudentGradeCubit():super(StudentGradeInitialState());

  static StudentGradeCubit get(context)=>BlocProvider.of(context);

  bool isPassive=false,isFail =false;

  void setPassive(){
    if(isPassive==false){
      isPassive= !isPassive;
      isFail=false;
    }else{
      isPassive= false;
      isFail= !isFail;
    }
    emit(StudentGradePassiveState());
  }

  Future<void> uploadStudentPassiveGrades({
   required String grade,
   required String type,
   required String reason,
   required String studentId,
  })async{

    emit(UploadGradeLoadingState());
   try{
     DatabaseReference ref =
     Constants.database.child('organztions').
     child(UserDataFromStorage.organizationIdFromStorage).
     child('groups').
     child(UserDataFromStorage.mainGroupFromStorage).
     child('subGroups').
     child(UserDataFromStorage.subGroupFromStorage).
     child('members').
     child(studentId).child('grades').child('passive').push();

     ref.set({
       'uId':ref.key,
       'grade' : grade,
       'type':type,
       'date': DateFormat.yMMMd().format(DateTime.now()),
       'reason':reason,
       'teacherName':UserDataFromStorage.adminNameFromStorage,
     });
     customToast(title: 'تم الارسال', color: ColorManager.primaryBlue);
     emit(UploadGradeSuccessState());
   }catch(e){
     print(e.toString());
     emit(UploadGradeErrorState());
   }

  }


  Future<void> uploadStudentFailGrades({
    required String grade,
    required String type,
    required String reason,
    required String studentId,
  })async{

    emit(UploadGradeLoadingState());
    try{
      DatabaseReference ref =
      Constants.database.child('organztions').
      child(UserDataFromStorage.organizationIdFromStorage).
      child('groups').
      child(UserDataFromStorage.mainGroupFromStorage).
      child('subGroups').
      child(UserDataFromStorage.subGroupFromStorage).
      child('members').
      child(studentId).child('grades').child('fail').push();

      ref.set({
        'uId':ref.key,
        'grade' : grade,
        'type':type,
        'date': DateFormat.yMMMd().format(DateTime.now()),
        'reason':reason,
        'teacherName':UserDataFromStorage.adminNameFromStorage,
      });
      customToast(title: 'تم الارسال', color: ColorManager.primaryBlue);
      emit(UploadGradeSuccessState());
    }catch(e){
      print(e.toString());
      emit(UploadGradeErrorState());
    }

  }






}