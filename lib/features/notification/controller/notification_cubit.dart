import 'package:attendience_app/core/helper/constants.dart';
import 'package:attendience_app/core/shared_preference/shared_preference.dart';
import 'package:attendience_app/features/notification/controller/notification_states.dart';
import 'package:attendience_app/features/notification/data/models/notification_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NotificationCubit extends Cubit<NotificationStates> {
  
  NotificationCubit() : super(NotificationInitialState());
  
  static NotificationCubit get(context) => BlocProvider.of(context);
  
  Future<void> addAttendenceNotification({
    required String title,
    required String body,
    required String date,
   })async{
   
    try{
      DatabaseReference  ref =  Constants.database.child('organztions').
      child(UserDataFromStorage.organizationIdFromStorage).
      child('groups').
      child(UserDataFromStorage.mainGroupFromStorage).
      child('subGroups').
      child(UserDataFromStorage.subGroupFromStorage).
      child('members').
      child(UserDataFromStorage.uIdFromStorage).
      child('notifications').push();


      NotificationModel notificationModel = NotificationModel(
        uId: ref.key ,
        date: date,
        body: body,
        title: title,
      );

      ref.set(notificationModel.toJson());

      print('Add Attendence Notification : ${ref.key}');
      emit(AddAttendenceNotificationSuccessState());

    }catch(e){

      print('Error in Add Attendence Notification : ${e.toString()}');
      emit(AddAttendenceNotificationErrorState());

    }
  }


  List<NotificationModel> notificationList = [];
  List<NotificationModel>  generalNotificationList = [];

  Future<void> getAttendenceNotification(DateTime filterDate,bool isAll)async{
    notificationList=[];

    emit(GetAttendenceNotificationLoadingState());
    try{
      var  response = await Constants.database.child('organztions').
      child(UserDataFromStorage.organizationIdFromStorage).
      child('groups').
      child(UserDataFromStorage.mainGroupFromStorage).
      child('subGroups').
      child(UserDataFromStorage.subGroupFromStorage).
      child('members').
      child(UserDataFromStorage.uIdFromStorage).
      child('notifications').get();

      if(isAll==false){
        response.children.forEach((element){

          notificationList.add(NotificationModel.fromJson(element.value as Map<dynamic,dynamic>));

        });
      }else {

        NotificationModel ?notification ;

        String date = DateFormat.yMd().format(filterDate);

        response.children.forEach((element){
          notification = NotificationModel.fromJson(element.value as Map<dynamic,dynamic>);
          if(notification!.date==date){
            notificationList.add(NotificationModel.fromJson(element.value as Map<dynamic,dynamic>));
          }
        });

      }


      print('Get Attendence Notification');
      emit(GetAttendenceNotificationSuccessState());

    }catch(e){

      print('Error in Get Attendence Notification : ${e.toString()}');
      emit(GetAttendenceNotificationErrorState());

    }
  }


  Future<void> getGeneralNotificationNotification()async{
    generalNotificationList=[];

    emit(GetGeneralNotificationSuccessState());
    try{
      var  response = await Constants.database.child('organztions').
      child(UserDataFromStorage.organizationIdFromStorage).
      child('generalNotifications').get();

      response.children.forEach((element){

        generalNotificationList.add(NotificationModel.fromJson(element.value as Map<dynamic,dynamic>));

      });

      print('Get General Notification');
      emit(GetGeneralNotificationSuccessState());

    }catch(e){

      print('Error in Get General Notification : ${e.toString()}');
      emit(GetGeneralNotificationErrorState());

    }
  }



}