import 'dart:io';

import 'package:attendience_app/core/helper/constants.dart';
import 'package:attendience_app/core/helper/material_navigation.dart';
import 'package:attendience_app/core/shared_preference/shared_preference.dart';
import 'package:attendience_app/features/auth/data/auth_repo_implement/auth_repo_implement.dart';
import 'package:attendience_app/features/home/data/models/daily_attendence_model.dart';
import 'package:attendience_app/features/home/data/models/fingure_settings_model.dart';
import 'package:attendience_app/features/home/presentation/controller/home_states.dart';
import 'package:attendience_app/features/home/presentation/view/widgets/done_record_student_body.dart';
import 'package:attendience_app/features/notification/controller/notification_cubit.dart';
import 'package:attendience_app/features/student_behaver/presentation/view/record_student_grade_view.dart';
import 'package:attendience_app/styles/assets/asset_manager.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/widets/toastification_widget.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

class HomeCubit extends Cubit<HomeStates>{

  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  var picker = ImagePicker();
  File? image;

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      emit(ImagePickerSuccessState());
    } else {
      print('No image selected');
      emit(ImagePickerFailureState());
    }
  }

  FingureSettingsModel  ?fingureSettingsModel ;
  bool isEducational = false;

  Future<void> getFigureOrganizationSettings()async{

    emit(FingureSettingsLoadingState());

    try{

      var response = await Constants.database
          .child('organztions')
          .child(UserDataFromStorage.organizationIdFromStorage)
          .child('fingerprintSetting').get();


      fingureSettingsModel = FingureSettingsModel.fromJson(response.value as Map<dynamic,dynamic>);

      print(fingureSettingsModel!.location![0]);

      print('Get figure organization settings : ${fingureSettingsModel!.isEducational}');
      isEducational=fingureSettingsModel!.isEducational!;
      emit(FingureSettingsSuccessState());


    }catch(e){

      print('Error in getFigureOrganizationSettings : ${e.toString()}');
      emit(FingureSettingsSuccessState());
    }


  }

  String checkAttendanceStatus(String attendTimeStr, String delayTimeStr,String absenceTimeStr) {
    // Parsing the time strings to DateTime objects

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('hh:mm a');
    String currentTimeString= formatter.format(now);
    DateTime currentTime = formatter.parse('$currentTimeString');
    DateTime attendTime = formatter.parse('$attendTimeStr');
    DateTime delayTime = formatter.parse('$delayTimeStr');
    DateTime absenceTime = formatter.parse('$absenceTimeStr');

    print('current time : $currentTime');
    print('attend time : $attendTime');
    print('delay time : $delayTime');
    print('absence time : $absenceTime');

    if (currentTime.isBefore(attendTime)) {
      Duration earlyDuration = attendTime.difference(currentTime);
      return 'Early';
    } else if (currentTime.isAfter(attendTime) && currentTime.isBefore(delayTime)) {
      return 'Not early';
    } else if (currentTime.isAfter(delayTime) && currentTime.isBefore(absenceTime)) {
      return 'Late';
    } else if (currentTime.isAfter(absenceTime) && currentTime.difference(absenceTime) < const Duration(hours: 3) ) {
      return 'absent';
    } else if (currentTime.difference(absenceTime) > const Duration(hours: 3)) {
      return 'too absent';
    }
    return 'not found';
  }


  void checkTimeToast({required  String autherized,required BuildContext context,required bool flag}){

    if(autherized =='Authorized'){
      String status = checkAttendanceStatus(
          fingureSettingsModel!.attendTime!,
          fingureSettingsModel!.delayTime!,
          fingureSettingsModel!.absenceTime!
      );

      print(' status : $status');
      if(status=='absent' && flag==false){

        if(foundUserAttendEarly==true){
          toastificationWidget(
              context: context,
              title: 'تسجيل الحضور',
              body: 'تم تسجيل بصمه الحضور من قبل',
              type: ToastificationType.error
          );
        }else{
          NotificationCubit.get(context).addAttendenceNotification(
              title: 'بصمه الحضور',
              body: 'متاخر عن موعد الحضور وتم تسجيلك غياب',
              date: DateFormat('yyyy-MM-dd').format(DateTime.now())
          );

          recordDailyEarlyAttendence(
              earlyFingure: 'متاخر و سجل غائب',
              notification: 'متاخر عن موعد الحضور وتم تسجيلك غياب',
              earlyFingureTime: DateFormat.Hms().format(DateTime.now())
          );

          toastificationWidget(
              context: context,
              title: 'تسجيل الحضور',
              body: 'متاخر عن موعد الحضور وتم تسجيلك غياب',
              type: ToastificationType.error
          );
          return;
        }
      }

      else if(status=='too absent' && flag==false){

        if(foundUserAttendEarly==true){
          toastificationWidget(
              context: context,
              title: 'تسجيل الحضور',
              body: 'تم تسجيل بصمه الحضور من قبل',
              type: ToastificationType.error
          );
        }else{
          NotificationCubit.get(context).addAttendenceNotification(
              title: 'بصمه الحضور',
              body: 'متاخر عن موعد الحضور وتم تسجيلك غياب',
              date: DateFormat('yyyy-MM-dd').format(DateTime.now())
          );

          recordDailyEarlyAttendence(
              earlyFingure: 'متاخر و سجل غائب',
              notification: 'متاخر عن موعد الحضور وتم تسجيلك غياب',
              earlyFingureTime: DateFormat.Hms().format(DateTime.now())
          );

          toastificationWidget(
              context: context,
              title: 'تسجيل الحضور',
              body: 'متاخر عن موعد الحضور وتم تسجيلك غياب',
              type: ToastificationType.error
          );
          return;
        }
      }

      else if (status=='Early' && flag==false) {

        if(foundUserAttendEarly==true){
          toastificationWidget(
              context: context,
              title: 'تسجيل الحضور',
              body: 'تم تسجيل بصمه الحضور من قبل',
              type: ToastificationType.error
          );
        }else{

          NotificationCubit.get(context).addAttendenceNotification(
              title: 'بصمه الحضور',
              body: 'شكرا لك تم تسجيل حضورك في المعاد المحدد',
              date: DateFormat('yyyy-MM-dd').format(DateTime.now())
          );

          recordDailyEarlyAttendence(
              earlyFingure: 'حضر في الموعد المحدد',
              notification: '',
              earlyFingureTime: DateFormat.Hms().format(DateTime.now())
          );

          toastificationWidget(
              context: context,
              title: 'تسجيل الحضور',
              body: 'شكرا لك تم تسجيل حضورك في المعاد المحدد',
              type: ToastificationType.success
          );
          return;
        }
      }

      else if (status=='Not early' && flag==false){

        if(foundUserAttendEarly==true){
          toastificationWidget(
              context: context,
              title: 'تسجيل الحضور',
              body: 'تم تسجيل بصمه الحضور من قبل',
              type: ToastificationType.error
          );
        }else{
          NotificationCubit.get(context).addAttendenceNotification(
              title: 'بصمه الحضور',
              body: 'تم تسجيل حضورك ف المعاد المحدد',
              date: DateFormat('yyyy-MM-dd').format(DateTime.now())
          );

          recordDailyEarlyAttendence(
              earlyFingure: 'حضر في الموعد المحدد',
              notification: '',
              earlyFingureTime: DateFormat.Hms().format(DateTime.now())
          );

          toastificationWidget(
              context: context,
              title: 'تسجيل الحضور',
              body: 'تم تسجيل حضورك ف المعاد المحدد',
              type: ToastificationType.success
          );
          return;
        }

      }

      else if (status=='Late' && flag==false) {

        if(foundUserAttendEarly==true){
          toastificationWidget(
              context: context,
              title: 'تسجيل الحضور',
              body: 'تم تسجيل بصمه الحضور من قبل',
              type: ToastificationType.error
          );
        }else{
          NotificationCubit.get(context).addAttendenceNotification(
              title: 'بصمه الحضور',
              body: ' متاخر عن موعد الحضور وتم تسجيلك متاخر',
              date: DateFormat('yyyy-MM-dd').format(DateTime.now())
          );

          recordDailyEarlyAttendence(
              earlyFingure: 'متاخر و سجل متاخر',
              notification: 'متاخر عن موعد الحضور وتم تسجيلك متاخر',
              earlyFingureTime: DateFormat.Hms().format(DateTime.now())
          );

          toastificationWidget(
              context: context,
              title: 'تسجيل الحضور',
              body: ' تم التاخير عن المعاد المحدد وتم تسجيلك متاخر',
              type: ToastificationType.error
          );
          return;
        }

      }

      ///////////////////////////////////////////////////////

      else if(status=='too absent' && flag==true){

        if(foundUserAttendLate==true){
          toastificationWidget(
              context: context,
              title: 'تسجيل الانصراف',
              body: 'تم تسجيل بصمه الانصراف من قبل',
              type: ToastificationType.error
          );
        }else{
          NotificationCubit.get(context).addAttendenceNotification(
              title: 'بصمه الانصراف',
              body: ' المعاد متاخر جدا عن موعد الانصراف',
              date: DateFormat('yyyy-MM-dd').format(DateTime.now())
          );

          recordDailyLateAttendence(
            lateFingure: 'منصرف متاخر عن موعد متاخر',
            notification: ' المعاد متاخر جدا عن موعد الانصراف',
            lateFingureTime: DateFormat.Hms().format(DateTime.now()),
          );

          toastificationWidget(
              context: context,
              title: 'تسجيل الانصراف',
              body: ' المعاد متاخر جدا عن موعد الانصراف',
              type: ToastificationType.error
          );
          return;
        }

      }

      else if(status=='absent' && flag==true){

        if(foundUserAttendLate==true){
          toastificationWidget(
              context: context,
              title: 'تسجيل الانصراف',
              body: 'تم تسجيل بصمه الانصراف من قبل',
              type: ToastificationType.error
          );
        }else{
          NotificationCubit.get(context).addAttendenceNotification(
              title: 'بصمه الانصراف',
              body: 'شكرا لك تم تسجيل انصرافك في المعاد المحدد',
              date: DateFormat('yyyy-MM-dd').format(DateTime.now())
          );

          recordDailyLateAttendence(
            lateFingure: 'انصرف في الموعد المحدد',
            notification: '',
            lateFingureTime: DateFormat.Hms().format(DateTime.now()),
          );

          toastificationWidget(
              context: context,
              title: 'تسجيل الانصراف',
              body: 'شكرا لك تم تسجيل انصرافك في المعاد المحدد',
              type: ToastificationType.success
          );
          return;
        }

      }

      else if (status=='Early' && flag==true){
        if(foundUserAttendLate==true){
          toastificationWidget(
              context: context,
              title: 'تسجيل الانصراف',
              body: 'تم تسجيل بصمه الانصراف من قبل',
              type: ToastificationType.error
          );
        }else{
          recordDailyLateAttendence(
            lateFingure: 'منصرف مبكرا',
            notification: 'الوقت مبكر عن موعد الحضور وتم تسجيلك منصر مبكر',
            lateFingureTime: DateFormat.Hms().format(DateTime.now()),
          );

          NotificationCubit.get(context).addAttendenceNotification(
              title: 'بصمه الانصراف',
              body: ' الوقت مبكر عن موعد الحضور وتم تسجيلك منصر مبكر',
              date: DateFormat('yyyy-MM-dd').format(DateTime.now())
          );

          toastificationWidget(
              context: context,
              title: 'تسجيل الانصراف',
              body: ' الوقت مبكر عن موعد الحضور وتم تسجيلك منصر مبكر',
              type: ToastificationType.error
          );
          return;
        }

      }
      else if (status=='Not early' && flag==true){

        if(foundUserAttendLate==true){
          toastificationWidget(
              context: context,
              title: 'تسجيل الانصراف',
              body: 'تم تسجيل بصمه الانصراف من قبل',
              type: ToastificationType.error
          );
        }else{
          recordDailyLateAttendence(
            lateFingure: 'منصرف مبكرا',
            notification: 'الوقت مبكر عن موعد الحضور وتم تسجيلك منصر مبكر',
            lateFingureTime: DateFormat.Hms().format(DateTime.now()),
          );

          NotificationCubit.get(context).addAttendenceNotification(
              title: 'بصمه الانصراف',
              body: ' الوقت مبكر عن موعد الحضور وتم تسجيلك منصر مبكر',
              date: DateFormat('yyyy-MM-dd').format(DateTime.now())
          );

          toastificationWidget(
              context: context,
              title: 'تسجيل الانصراف',
              body: ' الوقت مبكر عن موعد الحضور وتم تسجيلك منصر مبكر',
              type: ToastificationType.error
          );
          return;
        }

      }
      else if (status=='Late' && flag==true){

        if(foundUserAttendLate==true){
          toastificationWidget(
              context: context,
              title: 'تسجيل الانصراف',
              body: 'تم تسجيل بصمه الانصراف من قبل',
              type: ToastificationType.error
          );
        }else{
          recordDailyLateAttendence(
            lateFingure: 'منصرف مبكرا',
            notification: 'الوقت مبكر عن موعد الحضور وتم تسجيلك منصر مبكر',
            lateFingureTime: DateFormat.Hms().format(DateTime.now()),
          );

          NotificationCubit.get(context).addAttendenceNotification(
              title: 'بصمه الانصراف',
              body: ' الوقت مبكر عن موعد الحضور وتم تسجيلك منصر مبكر',
              date: DateFormat('yyyy-MM-dd').format(DateTime.now())
          );

          toastificationWidget(
              context: context,
              title: 'تسجيل الانصراف',
              body: ' الوقت مبكر عن موعد الحضور وتم تسجيلك منصر مبكر',
              type: ToastificationType.error
          );
          return;
        }

      }

    }else{
      if(flag==false){
        toastificationWidget(context: context, title: 'بصمه الحضور',
            body: 'لم يتم تسجيل الحضور حاول مره اخري'
            ,type: ToastificationType.error);
      } else  if(flag==true){
        toastificationWidget(context: context, title: 'بصمه الانصراف',
            body: 'لم يتم تسجيل الانصراف حاول مره اخري'
            ,type: ToastificationType.error);
      }
    }

  }

  Future<void> recordEducationalAttendence({required BuildContext context})async{
    emit(RecordEducationalAttendenceLoadingState());
    String status = checkAttendanceStatus(
        fingureSettingsModel!.attendTime!,
        fingureSettingsModel!.delayTime!,
        fingureSettingsModel!.absenceTime!
    );

    print(' status : $status');
    if(status=='absent'){

      if(foundUserAttendEarly==true){

      }else{
        NotificationCubit.get(context).addAttendenceNotification(
            title: 'بصمه الحضور',
            body: 'متاخر عن موعد الحضور وتم تسجيلك غياب',
            date: DateFormat('yyyy-MM-dd').format(DateTime.now())
        );

        recordDailyEarlyAttendence(
            earlyFingure: 'متاخر و سجل غائب',
            notification: 'متاخر عن موعد الحضور وتم تسجيلك غياب',
            earlyFingureTime: DateFormat.Hms().format(DateTime.now())
        );

        // toastificationWidget(
        //     context: context,
        //     title: 'تسجيل الحضور',
        //     body: 'متاخر عن موعد الحضور وتم تسجيلك غياب',
        //     type: ToastificationType.error
        // );

        customPushNavigator(context, const DoneRecordStudentBody(
            image: AssetsManager.sad,
            color: ColorManager.error,
            title: 'متاخر عن موعد الحضور وتم تسجيلك غياب')
        );
        emit(RecordEducationalAttendenceSuccessState());
        return;
      }



    }

    else if(status=='too absent'){

      if(foundUserAttendEarly==true){

      }else{
        NotificationCubit.get(context).addAttendenceNotification(
            title: 'بصمه الحضور',
            body: 'متاخر عن موعد الحضور وتم تسجيلك غياب',
            date: DateFormat('yyyy-MM-dd').format(DateTime.now())
        );

        recordDailyEarlyAttendence(
            earlyFingure: 'متاخر و سجل غائب',
            notification: 'متاخر عن موعد الحضور وتم تسجيلك غياب',
            earlyFingureTime: DateFormat.Hms().format(DateTime.now())
        );

        // toastificationWidget(
        //     context: context,
        //     title: 'تسجيل الحضور',
        //     body: 'متاخر عن موعد الحضور وتم تسجيلك غياب',
        //     type: ToastificationType.error
        // );

        customPushNavigator(context, const DoneRecordStudentBody(
            image: AssetsManager.sad,
            color: ColorManager.error,
            title: 'متاخر عن موعد الحضور وتم تسجيلك غياب')
        );
        emit(RecordEducationalAttendenceSuccessState());
        return;
      }


    }

    else if (status=='Early') {

      if(foundUserAttendEarly==true){

      }else{
        NotificationCubit.get(context).addAttendenceNotification(
            title: 'بصمه الحضور',
            body: 'شكرا لك تم تسجيل حضورك في المعاد المحدد',
            date: DateFormat('yyyy-MM-dd').format(DateTime.now())
        );

        recordDailyEarlyAttendence(
            earlyFingure: 'حضر في الموعد المحدد',
            notification: '',
            earlyFingureTime: DateFormat.Hms().format(DateTime.now())
        );

        // toastificationWidget(
        //     context: context,
        //     title: 'تسجيل الحضور',
        //     body: 'شكرا لك تم تسجيل حضورك في المعاد المحدد',
        //     type: ToastificationType.success
        // );

        customPushNavigator(context, const DoneRecordStudentBody(
            image: AssetsManager.happy,
            color: ColorManager.primaryBlue,
            title: 'شكرا لك تم تسجيل حضورك في المعاد المحدد')
        );
        emit(RecordEducationalAttendenceSuccessState());
        return;
      }


    }

    else if (status=='Not early' ){

      if(foundUserAttendEarly==true){

      }else{
        NotificationCubit.get(context).addAttendenceNotification(
            title: 'بصمه الحضور',
            body: 'تم تسجيل حضورك ف المعاد المحدد',
            date: DateFormat('yyyy-MM-dd').format(DateTime.now())
        );

        recordDailyEarlyAttendence(
            earlyFingure: 'حضر في الموعد المحدد',
            notification: '',
            earlyFingureTime: DateFormat.Hms().format(DateTime.now())
        );

        // toastificationWidget(
        //     context: context,
        //     title: 'تسجيل الحضور',
        //     body: 'تم تسجيل حضورك ف المعاد المحدد',
        //     type: ToastificationType.success
        // );

        customPushNavigator(context, const DoneRecordStudentBody(
            image: AssetsManager.happy,
            color: ColorManager.primaryBlue,
            title: 'تم تسجيل حضورك ف المعاد المحدد')
        );
        emit(RecordEducationalAttendenceSuccessState());
        return;


      }


    }

    else if (status=='Late') {

      if(foundUserAttendEarly==true){

      }else{
        NotificationCubit.get(context).addAttendenceNotification(
            title: 'بصمه الحضور',
            body: ' متاخر عن موعد الحضور وتم تسجيلك متاخر',
            date: DateFormat('yyyy-MM-dd').format(DateTime.now())
        );

        recordDailyEarlyAttendence(
            earlyFingure: 'متاخر و سجل متاخر',
            notification: 'متاخر عن موعد الحضور وتم تسجيلك متاخر',
            earlyFingureTime: DateFormat.Hms().format(DateTime.now())
        );

        // toastificationWidget(
        //     context: context,
        //     title: 'تسجيل الحضور',
        //     body: ' تم التاخير عن المعاد المحدد وتم تسجيلك متاخر',
        //     type: ToastificationType.error
        // );

        customPushNavigator(context, const DoneRecordStudentBody(
            image: AssetsManager.sad,
            color: ColorManager.error,
            title: ' تم التاخير عن المعاد المحدد وتم تسجيلك متاخر')
        );
        emit(RecordEducationalAttendenceSuccessState());
        return;

      }


    }

  }


  Future<void> recordDailyEarlyAttendence({
    required String earlyFingure,
    required String earlyFingureTime,
    required String notification,
  })async{

    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now()) ;
    emit(RecordDailyEarlyAttendenceLoadingState());
    try{
      if(notification !=''){
        Constants.database.child('organztions').
        child(UserDataFromStorage.organizationIdFromStorage).
        child('dailyAttendence').child(currentDate)
            .child(UserDataFromStorage.uIdFromStorage)
            .set(
            {
              'memberId': UserDataFromStorage.uIdFromStorage,
              'memberEmail': UserDataFromStorage.emailFromStorage,
              'memberName': UserDataFromStorage.fullNameFromStorage,
              'mainGroup': UserDataFromStorage.mainGroupFromStorage,
              'subGroup': UserDataFromStorage.subGroupFromStorage,
              'memberPhone': UserDataFromStorage.phoneNumberFromStorage,
              'earlyFingure': earlyFingure,
              'earlyFingureTime': earlyFingureTime,
              'notification':notification,
              'lateFingureTime': '',
              'lateFingure': '',
              'date': DateFormat.yMd().format(DateTime.now())
            }
        );
      }else{
        Constants.database.child('organztions').
        child(UserDataFromStorage.organizationIdFromStorage).
        child('dailyAttendence').child(currentDate)
            .child(UserDataFromStorage.uIdFromStorage)
            .set(
            {
              'memberId': UserDataFromStorage.uIdFromStorage,
              'memberEmail': UserDataFromStorage.emailFromStorage,
              'memberName': UserDataFromStorage.fullNameFromStorage,
              'mainGroup': UserDataFromStorage.mainGroupFromStorage,
              'subGroup': UserDataFromStorage.subGroupFromStorage,
              'memberPhone': UserDataFromStorage.phoneNumberFromStorage,
              'earlyFingure': earlyFingure,
              'earlyFingureTime': earlyFingureTime,
              'lateFingureTime': '',
              'lateFingure': '',
              'date': DateFormat.yMd().format(DateTime.now())
            }
        );
      }


      print('Record Daily Early Attendence : ${DateFormat.yMd().format(DateTime.now())}');
      emit(RecordDailyEarlyAttendenceSuccessState());
    }catch(e) {

      print('Error in Record Daily Early Attendence : ${e.toString()}');
      emit(RecordDailyEarlyAttendenceFailureState());
    }
  }

  bool foundUserAttendEarly=false;
  Future<void> checkUserAttendEarly()async{

    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now()) ;

    try{
      var response = await Constants.database.child('organztions').
      child(UserDataFromStorage.organizationIdFromStorage).
      child('dailyAttendence').child(currentDate)
          .child(UserDataFromStorage.uIdFromStorage).get();

      DailyAttendenceModel dailyModel = DailyAttendenceModel.fromJson(response.value as Map<dynamic, dynamic>);

      if(dailyModel.earlyFingureTime!='' && dailyModel.earlyFingure!=''){
        foundUserAttendEarly=true;
      }
      print('foundUserAttendEarly : $foundUserAttendEarly');
      emit(CheckDailyEarlyAttendenceLoadingState());
    }catch(e){
      foundUserAttendEarly=false;
      emit(CheckDailyEarlyAttendenceSuccessState());
    }


  }

  bool foundUserAttendLate=false;
  Future<void> checkUserAttendLate()async{

    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now()) ;

    try{
      var response = await Constants.database.child('organztions').
      child(UserDataFromStorage.organizationIdFromStorage).
      child('dailyAttendence').child(currentDate)
          .child(UserDataFromStorage.uIdFromStorage).get();

      DailyAttendenceModel dailyModel = DailyAttendenceModel.fromJson(response.value as Map<dynamic, dynamic>);

      if(dailyModel.lateFingureTime!='' && dailyModel.lateFingure!=''){
        foundUserAttendLate=true;
      }
      emit(CheckDailyLateAttendenceLoadingState());
    }catch(e){
      foundUserAttendLate=false;
      emit(CheckDailyLateAttendenceLoadingState());
    }


  }

  Future<void> recordDailyLateAttendence({
    required String lateFingure,
    required String lateFingureTime,
    required String notification,

  })async{

    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now()) ;

    emit(RecordDailyLateAttendenceLoadingState());
    try{
      if(notification!=''){
        Constants.database.child('organztions').
        child(UserDataFromStorage.organizationIdFromStorage).
        child('dailyAttendence').child(currentDate)
            .child(UserDataFromStorage.uIdFromStorage)
            .update({
          'lateFingureTime': lateFingureTime,
          'lateFingure': lateFingure,
          'notification':notification,
        });
      }else{
        Constants.database.child('organztions').
        child(UserDataFromStorage.organizationIdFromStorage).
        child('dailyAttendence').child(currentDate)
            .child(UserDataFromStorage.uIdFromStorage)
            .update({
          'lateFingureTime': lateFingureTime,
          'lateFingure': lateFingure,
        });
      }


      print('Record Daily Late Attendence : ${DateFormat.yMd().format(DateTime.now())}');
      emit(RecordDailyLateAttendenceSuccessState());
    }catch(e) {

      print('Error in Record Late Early Attendence : ${e.toString()}');
      emit(RecordDailyLateAttendenceFailureState());
    }
  }

  Future<void> getEducationalMemberInfo({required String memberId,required BuildContext context,required bool attendence})async{
    emit(GetEducationalMembersLoadingState());
    try{
      var response =await AuthRepoImplement().getEducationalMemberInfo(memberId: memberId);
      await checkUserAttendEarly();

      if(attendence){
        await recordEducationalAttendence(context: context);
      }else{
        customPushNavigator(context, RecordStudentGradeView(
          studentId: memberId ,
          studentMainGroup: UserDataFromStorage.mainGroupFromStorage,
          studentName: UserDataFromStorage.fullNameFromStorage,
          studentSubGroup: UserDataFromStorage.subGroupFromStorage,
        ));
      }

      emit(GetEducationalMembersSuccessState());
    }catch(e){

      print('Error in getEducationalMemberInfo : ${e.toString()}');
      emit(GetEducationalMembersFailureState());
    }


  }


}