import 'package:attendience_app/core/helper/material_navigation.dart';
import 'package:attendience_app/features/auth/presentaion/controller/auth_cubit.dart';
import 'package:attendience_app/features/auth/presentaion/controller/auth_states.dart';
import 'package:attendience_app/features/auth/presentaion/view/screens/login/member_login.dart';
import 'package:attendience_app/features/auth/presentaion/view/widgets/auth_text_form_field.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/size_config/app_size_config.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:attendience_app/styles/widets/default_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterForm extends StatelessWidget {
   RegisterForm({super.key});

   GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AuthCubit,AuthStates>(
        listener: (context, state) {
          if(state is CreateMemberAccountSuccessState){
            customPushAndRemoveUntil(context, const MemberLoginScreen());
          }
        },
        builder: (context, state) {
          var cubit = AuthCubit.get(context);
          return  Form(
            key: registerFormKey,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// User name
                  AuthTextFormField(
                    hintText: "رمز المنشاه",
                    controller: cubit.organizationIdController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "رمز المنشاه مطلوب";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(
                    height: SizeConfig.height * .025,
                  ),


                  /// Email
                  AuthTextFormField(
                    hintText: "رقم السجل",
                    controller:  cubit.folderNumController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "رقم السجل مطلوب";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(
                    height: SizeConfig.height * .025,
                  ),

                  /// Phone number
                  AuthTextFormField(
                    hintText: "الاسم رباعي",
                    controller:  cubit.fullNameController,
                    validator: (value) {
                      if(value!.isEmpty){
                        return "الاسم رباعي مطلوب";
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
                    hintText: "المجموعه الرئسيه",
                    controller:  cubit.mainGroupController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "المجموعه الرئسيه مطلوب";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),

                  SizedBox(
                    height: SizeConfig.height * .025,
                  ),

                  /// PayRoll number
                  AuthTextFormField(
                    hintText: "المجموعه الفرعيه",
                    controller:  cubit.subGroupController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "المجموعه الفرعيه مطلوب";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),

                  SizedBox(
                    height: SizeConfig.height * .025,
                  ),

                  /// PayRoll number
                  AuthTextFormField(
                    hintText: "رقم الجوال",
                    controller:  cubit.phoneController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "رقم الجوال مطلوب";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),

                  SizedBox(
                    height: SizeConfig.height * .025,
                  ),

                  /// PayRoll number
                  AuthTextFormField(
                    hintText: "اسم المستخدم",
                    controller:  cubit.userNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "اسم المستخدم مطلوب";
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
                    hintText: "البريد الالكتروني",
                    controller:  cubit.emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "البريد الالكتروني مطلوب";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),

                  SizedBox(
                    height: SizeConfig.height * .025,
                  ),

                  /// PayRoll number
                  AuthTextFormField(
                    isPassword: true,
                    viewPassword: true,
                    withSuffix: true,
                    hintText: "كلمه المرور",
                    controller:  cubit.passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "كلمه المرور مطلوب";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                  ),

                  SizedBox(
                    height: SizeConfig.height * .025,
                  ),

                  DefaultButton(
                      width: SizeConfig.width,
                      buttonText: "تسجيل البيانات",
                      onPressed: () {

                        if(registerFormKey.currentState!.validate()){
                          cubit.createMemberAccount(
                              email: cubit.emailController.text,
                              mainGroup: cubit.mainGroupController.text,
                              subGroup: cubit.subGroupController.text,
                              organizationId: cubit.organizationIdController.text,
                              password: cubit.passwordController.text,
                              userName: cubit.userNameController.text,
                              fullName: cubit.fullNameController.text,
                              folderNum: cubit.folderNumController.text,
                              phone: cubit.phoneController.text
                          );
                        }


                      },
                      buttonColor: ColorManager.primaryBlue,
                      large: false),

                  SizedBox(
                    height: SizeConfig.height * .01,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('لدي حساب بالفعل ؟',style: TextStyles.textStyle18Medium.copyWith(
                          color: ColorManager.black,
                          fontSize: SizeConfig.height * .017
                      ),),

                      TextButton(
                        onPressed: (){
                          customPushNavigator(context,const MemberLoginScreen() );
                        },
                        child: Text('تسجيل دخول',
                          style: TextStyles.textStyle18Bold.copyWith(
                              color: ColorManager.primaryBlue,
                              fontSize: SizeConfig.height * .017
                          ),
                        ),)
                    ],
                  )


                ],
              ),
            ),
          );
        }
    );
  }
}
