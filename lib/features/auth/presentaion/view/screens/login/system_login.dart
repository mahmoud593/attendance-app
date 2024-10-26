import 'package:attendience_app/features/auth/presentaion/view/widgets/login_member_form.dart';
import 'package:attendience_app/features/auth/presentaion/view/widgets/login_system_form.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/size_config/app_size_config.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SystemLoginScreen extends StatelessWidget {
  const SystemLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
     return Directionality(
       textDirection: TextDirection.ltr,
       child: Scaffold(
         backgroundColor: ColorManager.primaryBlue,

         body: SingleChildScrollView(
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
                             "تسجيل الدخول \n(للمنشأة)",
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
                           LoginSystemForm()
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
     );
  }
}
