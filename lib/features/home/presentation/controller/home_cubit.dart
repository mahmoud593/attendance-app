import 'dart:io';

import 'package:attendience_app/core/helper/constants.dart';
import 'package:attendience_app/core/helper/material_navigation.dart';
import 'package:attendience_app/core/shared_preference/shared_preference.dart';
import 'package:attendience_app/features/auth/data/auth_repo_implement/auth_repo_implement.dart';
import 'package:attendience_app/features/auth/presentaion/controller/auth_cubit.dart';
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
import 'package:geodesy/geodesy.dart';
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
  List<LatLng> buildingPolygon = [];
  Future<void> getFigureOrganizationSettings()async{

    emit(FingureSettingsLoadingState());

    try{

      var response = await Constants.database
          .child('organztions')
          .child(UserDataFromStorage.organizationIdFromStorage)
          .child('fingerprintSetting').get();


      fingureSettingsModel = FingureSettingsModel.fromJson(response.value as Map<dynamic,dynamic>);

      for(int i=0;i<fingureSettingsModel!.location!.length;i++){
        buildingPolygon.add(LatLng(fingureSettingsModel!.location![i]['lat'], fingureSettingsModel!.location![i]['long']));
      }

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
        }
        else{
          NotificationCubit.get(context).addAttendenceNotification(
              title: 'بصمه الحضور',
              body: 'تم تسجيلك غياب عن الدوام لهذا اليوم',
              date: DateFormat('yyyy-MM-dd').format(DateTime.now())
          );

          recordDailyEarlyAttendence(
              earlyFingure: 'متاخر و سجل غائب',
              notification: 'تم تسجيلك غياب عن الدوام لهذا اليوم',
              earlyFingureTime: DateFormat.Hms().format(DateTime.now())
          );

          toastificationWidget(
              context: context,
              title: 'تسجيل الحضور',
              body: 'تم تسجيلك غياب عن الدوام لهذا اليوم',
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
              body: 'تم تسجيلك غياب عن الدوام لهذا اليوم',
              date: DateFormat('yyyy-MM-dd').format(DateTime.now())
          );

          recordDailyEarlyAttendence(
              earlyFingure: 'متاخر و سجل غائب',
              notification: 'تم تسجيلك غياب عن الدوام لهذا اليوم',
              earlyFingureTime: DateFormat.Hms().format(DateTime.now())
          );

          toastificationWidget(
              context: context,
              title: 'تسجيل الحضور',
              body: 'تم تسجيلك غياب عن الدوام لهذا اليوم',
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
        }
        else{

          NotificationCubit.get(context).addAttendenceNotification(
              title: 'بصمه الحضور',
              body: 'حضر في الموعد المحدد لهذا اليوم',
              date: DateFormat('yyyy-MM-dd').format(DateTime.now())
          );

          recordDailyEarlyAttendence(
              earlyFingure: 'حضر في الموعد المحدد لهذا اليوم',
              notification: '',
              earlyFingureTime: DateFormat.Hms().format(DateTime.now())
          );

          toastificationWidget(
              context: context,
              title: 'تسجيل الحضور',
              body: 'حضر في الموعد المحدد لهذا اليوم',
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
              body: 'حضر في الموعد المحدد لهذا اليوم',
              date: DateFormat('yyyy-MM-dd').format(DateTime.now())
          );

          recordDailyEarlyAttendence(
              earlyFingure: 'حضر في الموعد المحدد لهذا اليوم',
              notification: '',
              earlyFingureTime: DateFormat.Hms().format(DateTime.now())
          );

          toastificationWidget(
              context: context,
              title: 'تسجيل الحضور',
              body: 'حضر في الموعد المحدد لهذا اليوم',
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
              body: 'تم تسجيلك متاخر عن الدوام لهذا اليوم',
              date: DateFormat('yyyy-MM-dd').format(DateTime.now())
          );

          recordDailyEarlyAttendence(
              earlyFingure: 'متاخر و سجل متاخر',
              notification: 'تم تسجيلك متاخر عن الدوام لهذا اليوم',
              earlyFingureTime: DateFormat.Hms().format(DateTime.now())
          );

          toastificationWidget(
              context: context,
              title: 'تسجيل الحضور',
              body: 'تم تسجيلك متاخر عن الدوام لهذا اليوم',
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
              body: 'تم تسجيلك انصراف حسب الموعد لهذا اليوم',
              date: DateFormat('yyyy-MM-dd').format(DateTime.now())
          );

          recordDailyLateAttendence(
            lateFingure: 'تم تسجيلك انصراف حسب الموعد لهذا اليوم',
            notification: '',
            lateFingureTime: DateFormat.Hms().format(DateTime.now()),
          );

          toastificationWidget(
              context: context,
              title: 'تسجيل الانصراف',
              body: 'تم تسجيلك انصراف حسب الموعد لهذا اليوم',
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
            notification: 'تم تسجيلك انصراف مبكر عن الدوام لهذا اليوم',
            lateFingureTime: DateFormat.Hms().format(DateTime.now()),
          );

          NotificationCubit.get(context).addAttendenceNotification(
              title: 'بصمه الانصراف',
              body: 'تم تسجيلك انصراف مبكر عن الدوام لهذا اليوم',
              date: DateFormat('yyyy-MM-dd').format(DateTime.now())
          );

          toastificationWidget(
              context: context,
              title: 'تسجيل الانصراف',
              body: 'تم تسجيلك انصراف مبكر عن الدوام لهذا اليوم',
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
            notification: 'تم تسجيلك انصراف مبكر عن الدوام لهذا اليوم',
            lateFingureTime: DateFormat.Hms().format(DateTime.now()),
          );

          NotificationCubit.get(context).addAttendenceNotification(
              title: 'بصمه الانصراف',
              body: 'تم تسجيلك انصراف مبكر عن الدوام لهذا اليوم',
              date: DateFormat('yyyy-MM-dd').format(DateTime.now())
          );

          toastificationWidget(
              context: context,
              title: 'تسجيل الانصراف',
              body: 'تم تسجيلك انصراف مبكر عن الدوام لهذا اليوم',
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
            notification: 'تم تسجيلك انصراف مبكر عن الدوام لهذا اليوم',
            lateFingureTime: DateFormat.Hms().format(DateTime.now()),
          );

          NotificationCubit.get(context).addAttendenceNotification(
              title: 'بصمه الانصراف',
              body: 'تم تسجيلك انصراف مبكر عن الدوام لهذا اليوم',
              date: DateFormat('yyyy-MM-dd').format(DateTime.now())
          );

          toastificationWidget(
              context: context,
              title: 'تسجيل الانصراف',
              body: 'تم تسجيلك انصراف مبكر عن الدوام لهذا اليوم',
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

    Constants.database.child('organztions').
    child(UserDataFromStorage.organizationIdFromStorage).
    child('dailyAttendence').child(DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .child(UserDataFromStorage.uIdFromStorage)
        .child('lectures').set({
       'lec1':false,
       'lec2':false,
    });

    print(' status : $status');
    if(status=='absent'){

      if(foundUserAttendEarly==true){
        toastificationWidget(
            context: context,
            title: 'تسجيل الحضور',
            body: 'تم تسجيل بصمه الحضور من قبل',
            type: ToastificationType.error
        );
      }
      else{
        NotificationCubit.get(context).addAttendenceNotification(
            title: 'بصمه الحضور',
            body: 'تم تسجيلك غياب عن الدوام لهذا اليوم',
            date: DateFormat('yyyy-MM-dd').format(DateTime.now())
        );

        recordDailyEarlyAttendence(
            earlyFingure: 'متاخر و سجل غائب',
            notification: 'تم تسجيلك غياب عن الدوام لهذا اليوم',
            earlyFingureTime: DateFormat.Hms().format(DateTime.now())
        );

        AuthCubit.get(context).getHomeMember(
            memberId: UserDataFromStorage.adminUidFromStorage,
            macAddress: UserDataFromStorage.macAddressFromStorage
        );

        toastificationWidget(
            context: context,
            title: 'تسجيل الحضور',
            body: 'تم تسجيلك غياب عن الدوام لهذا اليوم',
            type: ToastificationType.error
        );

        // customPushNavigator(context, const DoneRecordStudentBody(
        //     image: AssetsManager.sad,
        //     color: ColorManager.error,
        //     title: 'تم تسجيلك غياب عن الدوام لهذا اليوم')
        // );
        emit(RecordEducationalAttendenceSuccessState());
        return;
      }



    }

    else if(status=='too absent'){

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
            body: 'تم تسجيلك غياب عن الدوام لهذا اليوم',
            date: DateFormat('yyyy-MM-dd').format(DateTime.now())
        );

        recordDailyEarlyAttendence(
            earlyFingure: 'متاخر و سجل غائب',
            notification: 'تم تسجيلك غياب عن الدوام لهذا اليوم',
            earlyFingureTime: DateFormat.Hms().format(DateTime.now())
        );

        AuthCubit.get(context).getHomeMember(
            memberId: UserDataFromStorage.adminUidFromStorage,
            macAddress: UserDataFromStorage.macAddressFromStorage
        );

        toastificationWidget(
            context: context,
            title: 'تسجيل الحضور',
            body: 'تم تسجيلك غياب عن الدوام لهذا اليوم',
            type: ToastificationType.error
        );

        // customPushNavigator(context, const DoneRecordStudentBody(
        //     image: AssetsManager.sad,
        //     color: ColorManager.error,
        //     title: 'تم تسجيلك غياب عن الدوام لهذا اليوم')
        // );
        emit(RecordEducationalAttendenceSuccessState());
        return;
      }


    }

    else if (status=='Early') {

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
            body: 'حضر في الموعد المحدد لهذا اليوم',
            date: DateFormat('yyyy-MM-dd').format(DateTime.now())
        );

        AuthCubit.get(context).getHomeMember(
            memberId: UserDataFromStorage.adminUidFromStorage,
            macAddress: UserDataFromStorage.macAddressFromStorage
        );

        recordDailyEarlyAttendence(
            earlyFingure: 'حضر في الموعد المحدد لهذا اليوم',
            notification: '',
            earlyFingureTime: DateFormat.Hms().format(DateTime.now())
        );

        toastificationWidget(
            context: context,
            title: 'تسجيل الحضور',
            body: 'حضر في الموعد المحدد لهذا اليوم',
            type: ToastificationType.success
        );

        // customPushNavigator(context, const DoneRecordStudentBody(
        //     image: AssetsManager.happy,
        //     color: ColorManager.primaryBlue,
        //     title: 'حضر في الموعد المحدد لهذا اليوم')
        // );
        emit(RecordEducationalAttendenceSuccessState());
        return;
      }


    }

    else if (status=='Not early' ){

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
            body: 'حضر في الموعد المحدد لهذا اليوم',
            date: DateFormat('yyyy-MM-dd').format(DateTime.now())
        );

        recordDailyEarlyAttendence(
            earlyFingure: 'حضر في الموعد المحدد لهذا اليوم',
            notification: '',
            earlyFingureTime: DateFormat.Hms().format(DateTime.now())
        );

        AuthCubit.get(context).getHomeMember(
            memberId: UserDataFromStorage.adminUidFromStorage,
            macAddress: UserDataFromStorage.macAddressFromStorage
        );

        toastificationWidget(
            context: context,
            title: 'تسجيل الحضور',
            body: 'حضر في الموعد المحدد لهذا اليوم',
            type: ToastificationType.success
        );

        // customPushNavigator(context, const DoneRecordStudentBody(
        //     image: AssetsManager.happy,
        //     color: ColorManager.primaryBlue,
        //     title: 'حضر في الموعد المحدد لهذا اليوم')
        // );
        emit(RecordEducationalAttendenceSuccessState());
        return;
      }
    }

    else if (status=='Late') {

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
            body: 'تم تسجيلك متاخر عن الدوام لهذا اليوم',
            date: DateFormat('yyyy-MM-dd').format(DateTime.now())
        );

        recordDailyEarlyAttendence(
            earlyFingure: 'متاخر و سجل متاخر',
            notification: 'تم تسجيلك متاخر عن الدوام لهذا اليوم',
            earlyFingureTime: DateFormat.Hms().format(DateTime.now())
        );

        AuthCubit.get(context).getHomeMember(
            memberId: UserDataFromStorage.adminUidFromStorage,
            macAddress: UserDataFromStorage.macAddressFromStorage
        );

        toastificationWidget(
            context: context,
            title: 'تسجيل الحضور',
            body: 'تم تسجيلك متاخر عن الدوام لهذا اليوم',
            type: ToastificationType.error
        );

        // customPushNavigator(context, const DoneRecordStudentBody(
        //     image: AssetsManager.sad,
        //     color: ColorManager.error,
        //     title: 'تم تسجيلك متاخر عن الدوام لهذا اليوم')
        // );
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
              'lecs':{
                'lec1':false,
                'lec2':false,
                'lec3':false,
                'lec4':false,
                'lec5':false,
                'lec6':false,
                'lec7':false,
                'lec8':false
              },
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
              'lecs':{
                'lec1':false,
                'lec2':false,
                'lec3':false,
                'lec4':false,
                'lec5':false,
                'lec6':false,
                'lec7':false,
                'lec8':false
              },
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


  Future<void> recordLectureAttendence({required BuildContext context}) async {
    final now = DateTime.now();

    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now()) ;

    final currentMinutes = now.hour * 60 + now.minute;

    final List<Map<String, dynamic>> lectures = [
      {'lec': 'lec1', 'start': '07:00', 'end': '07:45'},
      {'lec': 'lec2', 'start': '07:46', 'end': '08:30'},
      {'lec': 'lec3', 'start': '08:31', 'end': '09:15'},
      {'lec': 'lec4', 'start': '09:31', 'end': '10:15'},
      {'lec': 'lec5', 'start': '10:16', 'end': '11:00'},
      {'lec': 'lec6', 'start': '11:01', 'end': '11:45'},
      {'lec': 'lec7', 'start': '11:46', 'end': '12:30'},
      {'lec': 'lec8', 'start': '12:45', 'end': '13:00'},
    ];

    for (var lecture in lectures) {
      final start = _timeToMinutes(lecture['start']);
      final end = _timeToMinutes(lecture['end']);

      if (currentMinutes >= start && currentMinutes <= end) {
        String lecName = lecture['lec'];
        String timeNow = DateFormat('HH:mm').format(now);

        Constants.database.child('organztions').
        child(UserDataFromStorage.organizationIdFromStorage).
        child('dailyAttendence').child(currentDate)
            .child(UserDataFromStorage.uIdFromStorage)
            .child('lecs').update({
            lecName: true,
        });

        toastificationWidget(
          context: context,
          title: 'تسجيل الحضور',
          body: 'تم تسجيل بصمه الحضور ف الحصه ${lecName.replaceAll('lec', '')}',
          type: ToastificationType.success,
        );
        break; // لو تم التسجيل، نخرج من اللوب
      }
    }

    emit(RecordDailyEarlyAttendenceLoadingState());
  }

  int _timeToMinutes(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return hour * 60 + minute;
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
      UserDataFromStorage.setUid(memberId);

      var response =await AuthRepoImplement().getEducationalMemberInfo(memberId: memberId);
      print('Member id : $memberId');
      await checkUserAttendEarly();

      if(attendence){
        emit(GetEducationalMembersSuccess1State());
      }else{

        emit(GetEducationalMembersSuccess2State());

      }

    }catch(e){

      print('Error in getEducationalMemberInfo : ${e.toString()}');
      emit(GetEducationalMembersFailureState());
    }


  }


  // void callbackDispatcher() {
  //   Workmanager().executeTask((task, inputData) async {
  //     // هنا تكتب الكود اللي يتنفذ في الخلفية
  //     print("Background task triggered!");
  //     onStart();
  //     return Future.value(true);
  //   });
  // }
  //
  //
  //
  // void onStart() {
  //   Geolocator.getPositionStream(
  //     locationSettings: const LocationSettings(
  //       accuracy: LocationAccuracy.high,
  //       distanceFilter: 10,
  //     ),
  //   ).listen((Position position) async {
  //     LatLng currentPosition = LatLng(position.latitude, position.longitude);
  //
  //     await getLocationTrack();
  //
  //     bool isInside = isPointInPolygon(polygon: buildingPolygon, point: currentPosition);
  //
  //     if (!isInside) {
  //
  //       DateTime now = DateTime.now();
  //       DateFormat formatter = DateFormat('hh:mm a');
  //       String currentTimeString= formatter.format(now);
  //       DateTime currentTime = formatter.parse(currentTimeString);
  //       DateTime attendTime = formatter.parse('${ fingureSettingsModel!.attendTime}');
  //       DateTime absenceTime = formatter.parse('${ fingureSettingsModel!.absenceTime}');
  //
  //       var currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now()) ;
  //
  //       if (currentTime.isAfter(attendTime) && currentTime.isBefore(absenceTime) && foundUserAttendEarly==true) {
  //           if(isLocationTracked==false){
  //             Constants.database.child('organztions').
  //             child(UserDataFromStorage.organizationIdFromStorage).
  //             child('locationNotification').child(currentDate)
  //                 .child(UserDataFromStorage.uIdFromStorage)
  //                 .set({
  //               'name': UserDataFromStorage.fullNameFromStorage,
  //               'phone': UserDataFromStorage.phoneNumberFromStorage,
  //               'timeLeft': currentTimeString,
  //               'mainGroup': UserDataFromStorage.mainGroupFromStorage,
  //               'subGroup': UserDataFromStorage.subGroupFromStorage,
  //               'notificationLeft':'تم رصد خروجك من منطقه التحضير',
  //               'notificationBack':'',
  //               'timeBack':'',
  //               'status':'',
  //             });
  //           }
  //       }
  //   }else{
  //       DateTime now = DateTime.now();
  //       DateFormat formatter = DateFormat('hh:mm a');
  //       String currentTimeString= formatter.format(now);
  //       DateTime currentTime = formatter.parse(currentTimeString);
  //       DateTime attendTime = formatter.parse('${ fingureSettingsModel!.attendTime}');
  //       DateTime absenceTime = formatter.parse('${ fingureSettingsModel!.absenceTime}');
  //
  //       var currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now()) ;
  //
  //       if (currentTime.isAfter(attendTime) && currentTime.isBefore(absenceTime) && foundUserAttendEarly==true) {
  //         if(isLocationTracked==true){
  //           Constants.database.child('organztions').
  //           child(UserDataFromStorage.organizationIdFromStorage).
  //           child('locationNotification').child(currentDate)
  //               .child(UserDataFromStorage.uIdFromStorage)
  //               .update({
  //             'notificationBack':'تم رصد عودتك الي منطقه التحضير',
  //             'timeBack':currentTimeString,
  //           });
  //         }
  //       }
  //     }
  //   });
  // }
  //
  //
  // bool isPointInPolygon({
  //   required List<LatLng> polygon,
  //   required LatLng point
  // }) {
  //   int intersectCount = 0;
  //   for (int j = 0; j < polygon.length; j++) {
  //     int i = (j + 1) % polygon.length;
  //     double x1 = polygon[j].longitude, y1 = polygon[j].latitude;
  //     double x2 = polygon[i].longitude, y2 = polygon[i].latitude;
  //     double px = point.longitude, py = point.latitude;
  //
  //     if (((y1 > py) != (y2 > py)) &&
  //         (px < (x2 - x1) * (py - y1) / (y2 - y1) + x1)) {
  //       intersectCount++;
  //     }
  //   }
  //   return (intersectCount % 2) == 1;
  // }
  //
  // bool isLocationTracked = false;
  // Future<void> getLocationTrack()async{
  //
  //   var currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now()) ;
  //
  //   try{
  //     Constants.database.child('organztions').
  //     child(UserDataFromStorage.organizationIdFromStorage).
  //     child('locationNotification').child(currentDate)
  //         .child(UserDataFromStorage.uIdFromStorage)
  //         .get();
  //
  //     isLocationTracked=true;
  //     emit(GetEducationalMembersFailureState());
  //   }catch(e){
  //     isLocationTracked=false;
  //     emit(GetEducationalMembersFailureState());
  //   }
  //
  // }




}