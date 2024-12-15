import 'package:attendience_app/features/auth/data/models/member_model.dart';

abstract class AuthRepo{

  Future<dynamic> loginAsMember({required String email, required String password,required String macAddress,});

  Future<dynamic> registerAsMember({
    required String email,
    required String mainGroup,
    required String subGroup,
    required String organizationId,
    required String password,
    required String userName,
    required String fullName,
    required String folderNum,
    required String phone,
});

  Future<void> saveMemberInfo({
    required String email,
    required String mainGroup,
    required String subGroup,
    required String organizationId,
    required String password,
    required String userName,
    required String fullName,
    required String folderNum,
    required String phone,
    required String uId,
  });


  Future<MemberModel> getMemberInfo({required String memberId,required String macAddress,});

  Future<MemberModel> getEducationalMemberInfo({required String memberId});


}