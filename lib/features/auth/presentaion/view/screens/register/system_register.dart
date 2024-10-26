import 'package:attendience_app/features/auth/presentaion/view/widgets/person_register_form.dart';
import 'package:attendience_app/features/auth/presentaion/view/widgets/register_form.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/size_config/app_size_config.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SystemRegisterScreen extends StatelessWidget {
  const SystemRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.primaryBlue,
        body: Container(
          decoration: const BoxDecoration(
              color: ColorManager.primaryBlue
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
                          fontSize: MediaQuery.sizeOf(context).height * .035
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
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.height * 0.001,
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  height: SizeConfig.height * 0.85,
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.height * .07),
                      topRight: Radius.circular(SizeConfig.height * .07),
                    ),
                  ),
                  child:  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * .05,
                        ),

                        Text(
                          " تسجيل دخول جديد \n(للمنشأة)",
                          style: TextStyles.textStyle24Bold.copyWith(
                              color: ColorManager.black,
                              fontSize: MediaQuery.sizeOf(context).height * .027
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * .02,
                        ),

                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: PersonRegisterForm(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}