import 'package:attendience_app/core/helper/constants.dart';
import 'package:attendience_app/core/shared_preference/shared_preference.dart';
import 'package:attendience_app/features/notification/controller/notification_states.dart';
import 'package:attendience_app/features/notification/data/models/general_notification.dart';
import 'package:attendience_app/features/notification/data/models/notification_model.dart';
import 'package:attendience_app/features/notification/data/models/reply_model.dart';
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
        time: DateFormat.Hms().format(DateTime.now()),
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
  List<GeneralNotificationModel>  generalNotificationList = [];

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

        String date = DateFormat('yyyy-MM-dd').format(filterDate);

        response.children.forEach((element){
          notification = NotificationModel.fromJson(element.value as Map<dynamic,dynamic>);
          print('Date : ${notification!.date} == ${date}');
          if(notification!.date==date){
            notificationList.add(NotificationModel.fromJson(element.value as Map<dynamic,dynamic>));
          }
        });

      }

      notificationList.sort((x,y)=> y.date!.compareTo(x.date!));

      print('Get Attendence Notification');
      emit(GetAttendenceNotificationSuccessState());

    }catch(e){

      print('Error in Get Attendence Notification : ${e.toString()}');
      emit(GetAttendenceNotificationErrorState());

    }
  }

  List<ReplyModel> replies=[];

  Future<void> getGeneralNotificationNotification()async{
    generalNotificationList=[];
    replies=[];
    emit(GetGeneralNotificationSuccessState());
    try{
        Constants.database.child('organztions').
      child(UserDataFromStorage.organizationIdFromStorage).
      child('generalNotifications').onValue.listen((event) {
          generalNotificationList=[];
          replies=[];
        event.snapshot.children.forEach((element){

          GeneralNotificationModel generalNotificationModel = GeneralNotificationModel.fromJson(element.value as Map<dynamic,dynamic>);

          generalNotificationModel.uIds?.forEach((element) {
            if(element==UserDataFromStorage.uIdFromStorage){
              generalNotificationList.add(generalNotificationModel);
            }
          });

          generalNotificationList.sort((x,y)=> y.date!.compareTo(x.date!));

          generalNotificationList.forEach((element) {
            element.date=DateFormat('yyyy-MM-dd').format(DateTime.parse(element.date!));
          });


          replies=[];
          if(generalNotificationModel.replies!.containsKey(UserDataFromStorage.uIdFromStorage)){
            generalNotificationModel.replies![UserDataFromStorage.uIdFromStorage].forEach((key, value) {
              ReplyModel replyModel = ReplyModel.fromJson(value as Map<dynamic,dynamic>);
              print(replyModel.fromSystem);

              replies.add(replyModel);
            });
          }

        });

        replies.sort((x,y)=> y.date!.compareTo(x.date!));

        print('Lenght of replies ${replies.length}');

        print('Get General Notification');
        emit(GetGeneralNotificationSuccessState());


      });



    }catch(e){

      print('Error in Get General Notification : ${e.toString()}');
      emit(GetGeneralNotificationErrorState());

    }
  }

  Future<void> getRepliesGeneralNotificationNotification({required String notificationId})async{
    generalNotificationList=[];
    replies=[];
    emit(GetGeneralNotificationSuccessState());
    try{
      var  response = await Constants.database.child('organztions').
      child(UserDataFromStorage.organizationIdFromStorage).
      child('generalNotifications').get();

      response.children.forEach((element){

        GeneralNotificationModel generalNotificationModel = GeneralNotificationModel.fromJson(element.value as Map<dynamic,dynamic>);

        generalNotificationModel.uIds?.forEach((element) {
          if(element==UserDataFromStorage.uIdFromStorage){
            generalNotificationList.add(generalNotificationModel);
          }
        });


        if(generalNotificationModel.id==notificationId){
          if(generalNotificationModel.replies!.containsKey(UserDataFromStorage.uIdFromStorage)){
            generalNotificationModel.replies![UserDataFromStorage.uIdFromStorage].forEach((key, value) {
              ReplyModel replyModel = ReplyModel.fromJson(value as Map<dynamic,dynamic>);
              print(replyModel.fromSystem);

              replies.add(replyModel);
            });
          }
        }



      });

      replies.sort((x,y)=> y.date!.compareTo(x.date!));

      print('Lenght of replies ${replies.length}');

      print('Get General Notification');
      emit(GetGeneralNotificationSuccessState());

    }catch(e){

      print('Error in Get General Notification : ${e.toString()}');
      emit(GetGeneralNotificationErrorState());

    }
  }



  Future<void> addGeneralNotificationReplies({required String notificationId,required String message})async{
    emit(AddReplyLoadingState());
    try{
      DatabaseReference  ref  = await Constants.database.child('organztions').
      child(UserDataFromStorage.organizationIdFromStorage).
      child('generalNotifications').child(notificationId).child('replies').child(UserDataFromStorage.uIdFromStorage).push();


      ReplyModel replyModel = ReplyModel(
        fromSystem: false,
        message: message,
        uId: ref.key,
        name: UserDataFromStorage.fullNameFromStorage,
        date: '${DateTime.now()}',
      );

      await ref.set(replyModel.toJson()).then((value) {
        getRepliesGeneralNotificationNotification(notificationId:notificationId );
      });

      print('Add Reply Success');
      emit(AddReplySuccessState());

    }catch(e){

      print('Error in Add Reply Notification : ${e.toString()}');
      emit(AddReplyErrorState());

    }
  }



}