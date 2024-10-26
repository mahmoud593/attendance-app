import 'package:attendience_app/features/applogize/data/models/applogize_model.dart';

abstract class ApplogizeRepo{

  Future<dynamic> createApplogize({
    required String email,
    required String mainGroup,
    required String subGroup,
    required String organizationId,
    required String userName,
    required String fullName,
    required String folderNum,
    required String uId,
    required String startDay,
    required String numDays,
    required String endDay,
    required String reason,
    required String image,
  });


  Future<List<ApplogizeModel>> getAllApplogize({
    required String organizationId,
  });


}