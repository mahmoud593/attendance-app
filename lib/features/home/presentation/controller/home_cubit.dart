import 'dart:io';

import 'package:attendience_app/core/helper/constants.dart';
import 'package:attendience_app/core/shared_preference/shared_preference.dart';
import 'package:attendience_app/features/home/data/models/fingure_settings_model.dart';
import 'package:attendience_app/features/home/presentation/controller/home_states.dart';
import 'package:attendience_app/features/notification/controller/notification_cubit.dart';
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
      emit(FingureSettingsSuccessState());


    }catch(e){

      print('Error in getFigureOrganizationSettings : ${e.toString()}');
      emit(FingureSettingsSuccessState());
    }


  }

  String checkAttendanceStatus(String attendTimeStr, String delayTimeStr,String absenceTimeStr) {
    // Parsing the time strings to DateTime objects
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('HH:mm:ss.SSS');
    String currentTimeString= formatter.format(now);
    DateTime currentTime = DateTime.parse('1970-01-01 $currentTimeString');
    DateTime attendTime = DateTime.parse('1970-01-01 $attendTimeStr');
    DateTime delayTime = DateTime.parse('1970-01-01 $delayTimeStr');
    DateTime absenceTime = DateTime.parse('1970-01-01 $absenceTimeStr');

    if (currentTime.isBefore(attendTime)) {
      Duration earlyDuration = attendTime.difference(currentTime);
      return 'Early';
    } else if (currentTime.isAfter(attendTime) && currentTime.isBefore(delayTime)) {
      return 'Not early';
    } else if (currentTime.isAfter(delayTime) && currentTime.isBefore(absenceTime)) {
      return 'Late';
    } else if (currentTime.isAfter(absenceTime) ) {
      return 'absent';
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
      if(status=='absent' && flag==false){

        NotificationCubit.get(context).addAttendenceNotification(
            title: 'بصمه الحضور',
            body: 'متاخر عن موعد الحضور وتم تسجيلك غياب',
            date: DateFormat.yMd().format(DateTime.now())
        );

        recordDailyEarlyAttendence(
          earlyFingure: 'متاخر عن موعد الحضور وتم تسجيلك غياب',
          earlyFingureTime: DateFormat.Hms().format(DateTime.now())
        );

        toastificationWidget(
            context: context,
            title: 'تسجيل الحضور',
            body: 'متاخر عن موعد الحضور وتم تسجيلك غياب',
            type: ToastificationType.error
        );
        return;
      }else if (status=='Early' && flag==false){

        recordDailyEarlyAttendence(
            earlyFingure: 'شكرا لك تم تسجيل حضورك في المعاد المحدد',
            earlyFingureTime: DateFormat.Hms().format(DateTime.now())
        );

        toastificationWidget(
            context: context,
            title: 'تسجيل الحضور',
            body: 'شكرا لك تم تسجيل حضورك في المعاد المحدد',
            type: ToastificationType.success
        );
        return;
      }else if (status=='Not early' && flag==false){

        recordDailyEarlyAttendence(
            earlyFingure: 'شكرا لك تم تسجيل حضورك في المعاد المحدد',
            earlyFingureTime: DateFormat.Hms().format(DateTime.now())
        );

        toastificationWidget(
            context: context,
            title: 'تسجيل الحضور',
            body: 'تم تسجيل حضورك ف المعاد المحدد',
            type: ToastificationType.success
        );
        return;
      }else if (status=='Late' && flag==false){

        NotificationCubit.get(context).addAttendenceNotification(
            title: 'بصمه الحضور',
            body: ' متاخر عن موعد الحضور وتم تسجيلك متاخر',
            date: DateFormat.yMd().format(DateTime.now())
        );

        recordDailyEarlyAttendence(
            earlyFingure: ' متاخر عن موعد الحضور وتم تسجيلك متاخر',
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
      else if(status=='absent' && flag==true){

        NotificationCubit.get(context).addAttendenceNotification(
            title: 'بصمه الانصراف',
            body: ' المعاد متاخر جدا عن موعد الانصراف',
            date: DateFormat.yMd().format(DateTime.now())
        );

        recordDailyLateAttendence(
          lateFingure: ' المعاد متاخر جدا عن موعد الانصراف',
          lateFingureTime: DateFormat.Hms().format(DateTime.now()),
        );

        toastificationWidget(
            context: context,
            title: 'تسجيل الانصراف',
            body: ' المعاد متاخر جدا عن موعد الانصراف',
            type: ToastificationType.error
        );
        return;
      }else if (status=='Early' && flag==true){
        recordDailyLateAttendence(
          lateFingure: 'شكرا لك تم تسجيل انصرافك في المعاد المحدد',
          lateFingureTime: DateFormat.Hms().format(DateTime.now()),
        );

        toastificationWidget(
            context: context,
            title: 'تسجيل الانصراف',
            body: 'شكرا لك تم تسجيل انصرافك في المعاد المحدد',
            type: ToastificationType.success
        );
        return;
      }else if (status=='Not early' && flag==true){

        recordDailyLateAttendence(
          lateFingure: 'تم تسجيل انصرافك ف المعاد المحدد',
          lateFingureTime: DateFormat.Hms().format(DateTime.now()),
        );

        toastificationWidget(
            context: context,
            title: 'تسجيل الانصراف',
            body: 'تم تسجيل انصرافك ف المعاد المحدد',
            type: ToastificationType.success
        );
        return;
      }else if (status=='Late' && flag==true){

        recordDailyLateAttendence(
          lateFingure: ' الوقت مبكر عن موعد الحضور وتم تسجيلك منصر مبكر',
          lateFingureTime: DateFormat.Hms().format(DateTime.now()),
        );

        NotificationCubit.get(context).addAttendenceNotification(
            title: 'بصمه الانصراف',
            body: ' الوقت مبكر عن موعد الحضور وتم تسجيلك منصر مبكر',
            date: DateFormat.yMd().format(DateTime.now())
        );

        toastificationWidget(
            context: context,
            title: 'تسجيل الانصراف',
            body: ' الوقت مبكر عن موعد الحضور وتم تسجيلك منصر مبكر',
            type: ToastificationType.error
        );
        return;
      }

    }else{
      if(flag==false){
        toastificationWidget(context: context, title: 'بصمه الحضور',
            body: 'لم يتم تسجيل الحضور حاول مره اخري'
            ,type: ToastificationType.error);
      } else  if(flag==true){
        toastificationWidget(context: context, title: 'بصمه الانصراف',
            body: 'لم يتم تسجيل الحضور حاول مره اخري'
            ,type: ToastificationType.error);
      }
    }

  }


  Future<void> recordDailyEarlyAttendence({
    required String earlyFingure,
    required String earlyFingureTime,
  })async{

    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now()) ;
    emit(RecordDailyEarlyAttendenceLoadingState());
    try{
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

      print('Record Daily Early Attendence : ${DateFormat.yMd().format(DateTime.now())}');
      emit(RecordDailyEarlyAttendenceSuccessState());
    }catch(e) {

      print('Error in Record Daily Early Attendence : ${e.toString()}');
      emit(RecordDailyEarlyAttendenceFailureState());
    }
  }

  Future<void> recordDailyLateAttendence({
    required String lateFingure,
    required String lateFingureTime,
  })async{

    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now()) ;

    emit(RecordDailyLateAttendenceLoadingState());
    try{
      Constants.database.child('organztions').
      child(UserDataFromStorage.organizationIdFromStorage).
      child('dailyAttendence').child(currentDate)
          .child(UserDataFromStorage.uIdFromStorage)
          .update(
          {
            'lateFingureTime': lateFingureTime,
            'lateFingure': lateFingure,
          }
      );

      print('Record Daily Late Attendence : ${DateFormat.yMd().format(DateTime.now())}');
      emit(RecordDailyLateAttendenceSuccessState());
    }catch(e) {

      print('Error in Record Late Early Attendence : ${e.toString()}');
      emit(RecordDailyLateAttendenceFailureState());
    }
  }


}