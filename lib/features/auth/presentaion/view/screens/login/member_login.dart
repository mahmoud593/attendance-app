import 'package:attendience_app/features/auth/presentaion/controller/auth_cubit.dart';
import 'package:attendience_app/features/auth/presentaion/controller/auth_states.dart';
import 'package:attendience_app/features/auth/presentaion/view/widgets/login_member_form.dart';
import 'package:attendience_app/styles/assets/asset_manager.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/size_config/app_size_config.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class MemberLoginScreen extends StatelessWidget {
  const MemberLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder <AuthCubit,AuthStates>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: ColorManager.primaryBlue,
            body: ModalProgressHUD(
              inAsyncCall: state is LoginMemberLoadingState,
              progressIndicator: const CupertinoActivityIndicator(),
              child: SingleChildScrollView(
                child: Container(
                  height: SizeConfig.height,
                  width: SizeConfig.width,
                  decoration: const BoxDecoration(
                    color: ColorManager.primaryBlue,
                  ),
                  child: Column(
                    children: [

                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * .04,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * .015,
                            ),
                            Text(
                              "مرحبا بك",
                              style: TextStyles.textStyle24Bold.copyWith(
                                  color: ColorManager.white,
                                  fontSize: MediaQuery.sizeOf(context).height * .032
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * .03,
                      ),


                      Expanded(
                        child: Container(
                          width: SizeConfig.width,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: AssetImage(AssetsManager.backgroundImage),
                            ),
                            color: ColorManager.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(SizeConfig.height * .07),
                              topRight: Radius.circular(SizeConfig.height * .07),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: MediaQuery.sizeOf(context).height * .05,
                                ),

                                Text(
                                  "تسجيل دخول للعضو",
                                  style: TextStyles.textStyle24Bold.copyWith(
                                      color: ColorManager.black,
                                      fontSize: MediaQuery.sizeOf(context).height * .025
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                SizedBox(
                                  height: MediaQuery.sizeOf(context).height * .06,
                                ),

                                /// Login Form
                                LoginMemberForm()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
