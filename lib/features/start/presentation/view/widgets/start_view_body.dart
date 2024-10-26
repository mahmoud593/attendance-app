import 'package:attendience_app/core/helper/app_size_config.dart';
import 'package:attendience_app/features/auth/presentaion/view/screens/login/system_login.dart';
import 'package:attendience_app/features/auth/presentaion/view/screens/login/member_login.dart';
import 'package:attendience_app/features/home/presentation/view/screens/home_screen.dart';
import 'package:attendience_app/features/start/presentation/view/widgets/login_as_admin.dart';
import 'package:attendience_app/features/start/presentation/view/widgets/login_as_member.dart';
import 'package:attendience_app/features/start/presentation/view/widgets/login_attandence.dart';
import 'package:attendience_app/features/start/presentation/view/widgets/register_as_admin.dart';
import 'package:attendience_app/features/start/presentation/view/widgets/register_as_member.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:flutter/material.dart';

class StartViewBody extends StatelessWidget {
  const StartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorManager.primaryBlue,
      ),
      child: Column(
        children: [

          SizedBox(
            height: MediaQuery.sizeOf(context).height * .06,
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * .02,
                ),
                Text(
                  "اهلا وسهلا",
                  style: TextStyles.textStyle24Bold.copyWith(
                      color: ColorManager.white,
                      fontSize: MediaQuery.sizeOf(context).height * .03
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          SizedBox(
            height: MediaQuery.sizeOf(context).height * .05,
          ),

          Expanded(
            child: Container(
              width: SizeConfig.width,
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConfig.height * .07),
                  topRight: Radius.circular(SizeConfig.height * .07),
                ),
              ),
              child:  Padding(
                padding: EdgeInsets.all(MediaQuery.sizeOf(context).height*.027),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height:  MediaQuery.sizeOf(context).height*.03,),

                      const LoginAsMember(),

                      SizedBox(height:  MediaQuery.sizeOf(context).height*.03,),

                      const RegisterAsMember(),

                      SizedBox(height:  MediaQuery.sizeOf(context).height*.03,),

                      const LoginAsAdmin(),

                      SizedBox(height:  MediaQuery.sizeOf(context).height*.03,),

                      const RegisterAsAdmin(),


                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
