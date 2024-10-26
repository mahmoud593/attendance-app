import 'package:attendience_app/features/auth/presentaion/view/widgets/auth_text_form_field.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/size_config/app_size_config.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:attendience_app/styles/widets/default_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonRegisterForm extends StatelessWidget {
  PersonRegisterForm({super.key});

  TextEditingController emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return  Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// User name
          AuthTextFormField(
            hintText: "رمز المنشاه",
            controller: emailController,
            validator: (value) {
              if (value!.isEmpty) {
                return "رمز المنشاه مطلوب";
              }
              return null;
            },
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
          ),


          SizedBox(
            height: SizeConfig.height * .025,
          ),

          /// PayRoll number
          AuthTextFormField(
            hintText: "كلمه المرور",
            controller: emailController,
            validator: (value) {
              if (value!.isEmpty) {
                return "كلمه المرور مطلوب";
              }
              return null;
            },
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),

          SizedBox(
            height: SizeConfig.height * .025,
          ),

          /// PayRoll number
          AuthTextFormField(
            hintText: "تاكيد كلمه المرور",
            controller: emailController,
            validator: (value) {
              if (value!.isEmpty) {
                return "تاكيد كلمه المرور مطلوب";
              }
              return null;
            },
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),

          SizedBox(
            height: SizeConfig.height * .025,
          ),

          /// PayRoll number
          AuthTextFormField(
            hintText: "رقم الجوال",
            controller: emailController,
            validator: (value) {
              if (value!.isEmpty) {
                return "رقم الجوال مطلوب";
              }
              return null;
            },
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),

          SizedBox(
            height: SizeConfig.height * .025,
          ),

          /// PayRoll number
          AuthTextFormField(
            hintText: "اسم المستخدم",
            controller: emailController,
            validator: (value) {
              if (value!.isEmpty) {
                return "اسم المستخدم مطلوب";
              }
              return null;
            },
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),

          SizedBox(
            height: SizeConfig.height * .025,
          ),

          /// PayRoll number
          AuthTextFormField(
            hintText: "البريد الالكتروني",
            controller: emailController,
            validator: (value) {
              if (value!.isEmpty) {
                return "البريد الالكتروني مطلوب";
              }
              return null;
            },
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),

          SizedBox(
            height: SizeConfig.height * .025,
          ),

          /// PayRoll number
          AuthTextFormField(
            hintText: "كلمه المرور",
            controller: emailController,
            validator: (value) {
              if (value!.isEmpty) {
                return "كلمه المرور مطلوب";
              }
              return null;
            },
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),

          SizedBox(
            height: SizeConfig.height * .025,
          ),

          DefaultButton(
              width: SizeConfig.width,
              buttonText: "تسجيل البيانات",
              onPressed: () {

              },
              buttonColor: ColorManager.primaryBlue,
              large: false),

          SizedBox(
            height: SizeConfig.height * .01,
          ),

        ],
      ),
    );
  }
}
