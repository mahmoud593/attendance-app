import 'package:attendience_app/features/splash/presentation/view/widgest/logo.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:flutter/material.dart';

class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width:  MediaQuery.of(context).size.width,
      decoration:  BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ColorManager.lightBlue, ColorManager.primaryBlue],
          stops:  [0.0, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Logo(),

          SizedBox(height: MediaQuery.of(context).size.height*.04,),

          Text(
            "اهلا وسهلا بكم في نظام البصمة",
            style: TextStyles.textStyle24Bold.copyWith(
                color: ColorManager.white,
                fontSize: MediaQuery.sizeOf(context).height * .022
            ),
          ),
        ],
      ),
    );
  }
}
