import 'package:attendience_app/core/helper/material_navigation.dart';
import 'package:attendience_app/core/shared_preference/shared_preference.dart';
import 'package:attendience_app/features/auth/presentaion/view/screens/login/member_login.dart';
import 'package:attendience_app/features/home/presentation/view/screens/home_screen.dart';
import 'package:attendience_app/features/splash/presentation/view/widgest/splash_view_body.dart';
import 'package:attendience_app/features/start/presentation/view/start_screen.dart';
import 'package:attendience_app/features/start/presentation/view/widgets/login_as_member.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    timeDelay(context: context);    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashViewBody(),
    );
  }

  void timeDelay({required BuildContext context})  {
    Future.delayed(const Duration(seconds: 2),()
    async{
      print(UserDataFromStorage.adminUidFromStorage);
      UserDataFromStorage.adminUidFromStorage != '' ? customPushAndRemoveUntil(context, const HomeScreen()) :
      customPushAndRemoveUntil(context, const MemberLoginScreen());
    }
    );
  }
}