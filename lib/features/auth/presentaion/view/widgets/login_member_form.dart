import 'package:attendience_app/core/helper/material_navigation.dart';
import 'package:attendience_app/features/auth/presentaion/controller/auth_cubit.dart';
import 'package:attendience_app/features/auth/presentaion/controller/auth_states.dart';
import 'package:attendience_app/features/auth/presentaion/view/screens/register/system_register.dart';
import 'package:attendience_app/features/auth/presentaion/view/screens/register/member_register.dart';
import 'package:attendience_app/features/auth/presentaion/view/widgets/auth_text_form_field.dart';
import 'package:attendience_app/features/home/presentation/view/screens/home_screen.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/size_config/app_size_config.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:attendience_app/styles/widets/default_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class LoginMemberForm extends StatelessWidget {
  LoginMemberForm({super.key});

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit,AuthStates>(
        listener: (context, state) {
           if(state is LoginMemberSuccessState){
             customPushAndRemoveUntil(context, const HomeScreen());
           }
        },
        builder:  (context, state) {
          var cubit = AuthCubit.get(context);
         return Form(
           key: loginFormKey,
           child: Directionality(
             textDirection: TextDirection.rtl,
             child: Column(
               children: [
                 /// Email
                 AuthTextFormField(
                   hintText: "البريد الالكتروني",
                   controller: cubit.emailLoginController,
                   validator: (value) {
                     if (value!.isEmpty) {
                       return " البريد الالكتروني مطلوب";
                     }
                     return null;
                   },
                   keyboardType: TextInputType.emailAddress,
                   textInputAction: TextInputAction.next,
                 ),
                 SizedBox(
                   height: SizeConfig.height * .02,
                 ),
                 /// Password
                 AuthTextFormField(
                   isPassword: true,
                   withSuffix: true,
                   hintText: "كلمه المرور",
                   controller: cubit.passwordLoginController,
                   validator: (value) {
                     if (value!.isEmpty) {
                       return "كلمه المرور مطلوبه";
                     }
                     return null;
                   },
                   keyboardType: TextInputType.text,
                   textInputAction: TextInputAction.done,
                 ),


                 SizedBox(height: SizeConfig.height * .08,),

                 /// Login Button
                 DefaultButton(
                     width: SizeConfig.width,
                     buttonText: "دخول للحساب",
                     onPressed: () {

                       if(loginFormKey.currentState!.validate()) {
                         cubit.memberLogin(
                             email: cubit.emailLoginController.text,
                             context: context,
                             password: cubit.passwordLoginController.text
                         );
                       }

                     },
                     buttonColor: ColorManager.primaryBlue,
                     large: false),

                 SizedBox(height: SizeConfig.height * .02,),

                 // Row(
                 //   mainAxisAlignment: MainAxisAlignment.center,
                 //   children: [
                 //     Text('ليس لديك حساب ؟',style: TextStyles.textStyle18Medium.copyWith(
                 //         color: ColorManager.black,
                 //         fontSize: SizeConfig.height * .017
                 //     ),),
                 //
                 //     TextButton(
                 //       onPressed: (){
                 //         customPushNavigator(context,const MemberRegisterScreen() );
                 //       },
                 //       child: Text('انشاء حساب',
                 //         style: TextStyles.textStyle18Bold.copyWith(
                 //             color: ColorManager.primaryBlue,
                 //             fontSize: SizeConfig.height * .017
                 //         ),
                 //       ),)
                 //   ],
                 // )

               ],
             ),
           ),
         );
        }
    );
  }
}
