
import 'package:attendience_app/core/helper/constants.dart';
import 'package:attendience_app/features/applogize/data/applogize_repo/applogize_repo.dart';
import 'package:attendience_app/features/applogize/data/models/applogize_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class ApplogizeRepoImplement implements ApplogizeRepo{
  @override
  Future createApplogize({
    required String email, 
    required String mainGroup,
    required String subGroup,
    required String organizationId, 
    required String userName, 
    required String numDays,
    required String fullName,
    required String folderNum, 
    required String uId,
    required String startDay, 
    required String endDay, 
    required String reason, 
    required String image}) async {

    try{
      DatabaseReference  databaseReference = Constants.database.
      child('organztions').
      child(organizationId).
      child('applogizes').
      push();

      ApplogizeModel applogizeModel = ApplogizeModel(
          email: email,
          mainGroup: mainGroup,
          status: 'قيد المراجعه',
          subGroup: subGroup,
          day: DateFormat.yMd().format(DateTime.now()),
          organizationId: organizationId,
          userName: userName,
          numDays: numDays,
          fullName: fullName,
          folderNum: folderNum,
          uId: uId,
          startDay: startDay,
          endDay: endDay,
          reason: reason,
          image: image,
          applogizeId: databaseReference.key!
      );

      var result = await databaseReference.set(applogizeModel.toJson());

      return result;
    }catch(e){
      print('Error in create applogize : ${e.toString()}');
      return '';
    }
    
  }

  @override
  Future<List<ApplogizeModel>> getAllApplogize({
    required String organizationId
  })async {

    try{

      List<ApplogizeModel> applogizeList=[] ;

      DatabaseReference  databaseReference = Constants.database.
      child('organztions').
      child(organizationId).
      child('applogizes');

      var result = await databaseReference.get();

      result.children.forEach((element) {

        applogizeList.add(ApplogizeModel.fromJson(element.value as Map<dynamic,dynamic>));

      });

      return applogizeList;
    }catch(e){
      print('Error in create applogize : ${e.toString()}');
      return [];
    }
  }
  
}