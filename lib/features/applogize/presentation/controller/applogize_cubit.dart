import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:attendience_app/features/applogize/data/applogize_repo_implemnt/applogize_repo_implement.dart';
import 'package:attendience_app/features/applogize/data/models/applogize_model.dart';
import 'package:attendience_app/features/applogize/presentation/controller/applogize_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ApplogizeCubit extends Cubit<ApplogizeStates>{

  ApplogizeCubit() : super(ApplogizeInitialState());

  static ApplogizeCubit get(context) => BlocProvider.of(context);

  TextEditingController reasonController = TextEditingController();

  String startDate='';
  String endDate='';

  Future<dynamic> createApplogize({
    required String email,
    required String mainGroup,
    required String subGroup,
    required String organizationId,
    required String userName,
    required String fullName,
    required String folderNum,
    required String uId,
    required String numDays,
    required String startDay,
    required String endDay,
    required String reason,
    String ?image,
  })async{

    emit(ApplogizeLoadingState());
    var result = await ApplogizeRepoImplement().createApplogize(
        email: email,
        mainGroup: mainGroup,
        subGroup: subGroup,
        numDays: numDays,
        organizationId: organizationId,
        userName: userName,
        fullName: fullName,
        folderNum: folderNum,
        uId: uId,
        startDay: startDay,
        endDay: endDay,
        reason: reason,
        image: image??''
    );

    if(result != ''){
      emit(ApplogizeSuccessState());
    }
    else{
      emit(ApplogizeErrorState());

    }
  }


  List<ApplogizeModel> applogizeList = [];

  Future<dynamic> getAllApplogize({
    required String organizationId,
  })async{

    emit(GetAllApplogizeLoadingState());
    var result = await ApplogizeRepoImplement().getAllApplogize(
        organizationId: organizationId,
    );

      applogizeList = result;

      emit(GetAllApplogizeSuccessState());
  }



  var picker = ImagePicker();
  File? image;

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      emit(ImagePickerSuccessState());
    } else {
      print('No image selected');
      emit(ImagePickerFailureState());
    }
  }

  void removeImage() {
    image = null;
    emit(RemovePickedImageSuccessState());
  }


  Future<void> uploadImage({
    required String email,
    required String mainGroup,
    required String subGroup,
    required String organizationId,
    required String userName,
    required String fullName,
    required String folderNum,
    required String uId,
    required String numDays,
    required String startDay,
    required String endDay,
    required String reason,
  }) async{

    emit(UploadImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('applogizes/images/${Uri.file(image!.path).pathSegments.last}')
        .putFile(image!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {

        print('image path : ${value.toString()}');

       createApplogize(
          email: email,
          mainGroup: mainGroup,
          subGroup: subGroup,
          organizationId: organizationId,
          userName: userName,
          fullName: fullName,
          folderNum: folderNum,
          numDays: numDays,
          uId: uId,
          startDay: startDay,
          endDay: endDay,
          reason: reason,
          image: value.toString(),
        );

        emit(UploadImageSuccessState());

      }).catchError((error) {
        emit(UploadImageFailureState());
        debugPrint(error.toString());

      });
    }).catchError((error) {
      emit(UploadImageFailureState());
      debugPrint(error.toString());

  });

  }


  String formatDate(String date) {
    List<String> dateParts = date.split('/');
    return '${dateParts[2]}-${dateParts[0].padLeft(2, '0')}-${dateParts[1].padLeft(2, '0')}';
  }

}