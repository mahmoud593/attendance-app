import 'package:attendience_app/core/shared_preference/shared_preference.dart';
import 'package:attendience_app/features/auth/data/auth_repo_implement/auth_repo_implement.dart';
import 'package:attendience_app/features/auth/presentaion/controller/auth_states.dart';
import 'package:attendience_app/styles/widets/toast.dart';
import 'package:attendience_app/styles/widets/toastification_widget.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:toastification/toastification.dart';

class AuthCubit extends Cubit<AuthStates> {

  AuthCubit() :super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of(context);

  TextEditingController emailController = TextEditingController();
  TextEditingController mainGroupController = TextEditingController();
  TextEditingController subGroupController = TextEditingController();
  TextEditingController organizationIdController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController folderNumController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController passwordLoginController = TextEditingController();
  TextEditingController emailLoginController = TextEditingController();


  Future<void> createMemberAccount({
    required String email,
    required String mainGroup,
    required String subGroup,
    required String organizationId,
    required String password,
    required String userName,
    required String fullName,
    required String folderNum,
    required String phone,
  }) async {
    emit(CreateMemberAccountLoadingState());

    try {
      var response =  await AuthRepoImplement().registerAsMember(
          email: email,
          mainGroup: mainGroup,
          subGroup: subGroup,
          organizationId: organizationId,
          password: password,
          userName: userName,
          fullName: fullName,
          folderNum: folderNum,
          phone: phone
      );

      if(response != ''){
        emit(CreateMemberAccountSuccessState());
      }

    } catch (e) {
      print('Error in createMemberAccount member : ${e.toString()}');
      emit(CreateMemberAccountErrorState());
    }
  }

  String? macAddress;

  Future<void> getMacAddress() async {
    final info = NetworkInfo();

    try {
      // Get the MAC address of the Wi-Fi interface
      macAddress = await info.getWifiBSSID();
      print("MAC Address: $macAddress");
    } catch (e) {
      print("Error fetching MAC address: $e");
    }
  }

  Future<void> memberLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    emit(LoginMemberLoadingState());

    await getMacAddress();

    try {
      var response  = await AuthRepoImplement().loginAsMember(
          email: email,
          password: password,
          macAddress: macAddress!
      );

      if(response != '' && UserDataFromStorage.themeIsDarkMode == true){
        print('Success');
        emit(LoginMemberSuccessState());
      }
      else{
        if(UserDataFromStorage.themeIsDarkMode == false){
          toastificationWidget(context: context, title: 'هذا الحساب مملوك لشخص اخر', body: 'تم تسجيل بيانات الحساب في جهاز اخر حاول التسجيل من الجهاز المسجل مسبق',
              type: ToastificationType.error);
          print('Error');
          emit(LoginMemberErrorState());
        }else{
          customToast(title: 'البريد الالكتروني او كلمة المرور غير صحيح', color: Colors.red);
          print('Error');
          emit(LoginMemberErrorState());
        }
      }

    } catch (e) {
      print('Error in memberLogin member : ${e.toString()}');
      emit(LoginMemberErrorState());
    }
  }

}