
import 'package:attendience_app/core/helper/app_size_config.dart';
import 'package:attendience_app/core/shared_preference/shared_preference.dart';
import 'package:attendience_app/features/auth/presentaion/controller/auth_cubit.dart';
import 'package:attendience_app/features/auth/presentaion/controller/auth_states.dart';
import 'package:attendience_app/styles/assets/asset_manager.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:attendience_app/styles/widets/default_button.dart';
import 'package:attendience_app/styles/widets/default_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ProfileScreenBody extends StatefulWidget {
  const ProfileScreenBody({super.key});

  static TextEditingController passwordController = TextEditingController();

  @override
  State<ProfileScreenBody> createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody> {

  TextEditingController fullNameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController userNameController=TextEditingController();

  @override
  void initState() {
    super.initState();

    fullNameController.text=UserDataFromStorage.fullNameFromStorage;
    emailController.text=UserDataFromStorage.emailFromStorage;
    phoneController.text=UserDataFromStorage.phoneNumberFromStorage;
    userNameController.text=UserDataFromStorage.userNameFromStorage;
  }

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<AuthCubit,AuthStates>(
      builder: (context, state) {
        var cubit= AuthCubit.get(context);
         return SingleChildScrollView(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [

               SizedBox(height: MediaQuery.of(context).size.height*.03,),

               Text(
                 'البيانات الشخصيه',style: TextStyles.textStyle18Bold.copyWith(
                   color: ColorManager.primaryBlue
               ),),

               SizedBox(height: MediaQuery.of(context).size.height*.02,),

               Container(
                 padding: EdgeInsets.symmetric(
                   horizontal: MediaQuery.of(context).size.width*.04,
                   vertical: MediaQuery.of(context).size.width*.04,
                 ),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(12),
                   color: ColorManager.primaryBlue,
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [

                     Text(
                       'الاسم رباعي',style: TextStyles.textStyle18Bold.copyWith(
                         color: ColorManager.white,
                         fontSize: MediaQuery.sizeOf(context).height*.018
                     ),),

                     SizedBox(height: MediaQuery.of(context).size.height*.02,),

                     DefaultTextField(
                         controller: fullNameController,
                         hintText: 'الاسم رباعي',
                         validator: (value){},
                         keyboardType: TextInputType.text,
                         textInputAction: TextInputAction.next,
                         fillColor: Colors.white
                     ),


                     SizedBox(height: MediaQuery.of(context).size.height*.025,),


                     Text(
                       'البريد الالكتروني',style: TextStyles.textStyle18Bold.copyWith(
                         color: ColorManager.white,
                         fontSize: MediaQuery.sizeOf(context).height*.018
                     ),),

                     SizedBox(height: MediaQuery.of(context).size.height*.02,),

                     DefaultTextField(
                         controller: emailController,
                         hintText: 'البريد الالكتروني',
                         validator: (value){},
                         keyboardType: TextInputType.emailAddress,
                         textInputAction: TextInputAction.next,
                         fillColor: Colors.white
                     ),


                     SizedBox(height: MediaQuery.of(context).size.height*.025,),

                     Text(
                       'رقم الهاتف',style: TextStyles.textStyle18Bold.copyWith(
                         color: ColorManager.white,
                         fontSize: MediaQuery.sizeOf(context).height*.018
                     ),),

                     SizedBox(height: MediaQuery.of(context).size.height*.02,),

                     DefaultTextField(
                         controller: phoneController,
                         hintText: 'رقم الهاتف',
                         validator: (value){},
                         keyboardType: TextInputType.phone,
                         textInputAction: TextInputAction.next,
                         fillColor: Colors.white
                     ),

                     SizedBox(height: MediaQuery.of(context).size.height*.02,),

                   ],
                 ),
               ),

               SizedBox(height: MediaQuery.of(context).size.height*.03,),

               Text(
                 'بيانات المجموعه',style: TextStyles.textStyle18Bold.copyWith(
                   color: ColorManager.primaryBlue
               ),),

               SizedBox(height: MediaQuery.of(context).size.height*.02,),

               Container(
                 padding: EdgeInsets.symmetric(
                   horizontal: MediaQuery.of(context).size.width*.04,
                   vertical: MediaQuery.of(context).size.width*.04,
                 ),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(12),
                   color: ColorManager.primaryBlue,
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [

                     Text(
                       'اسم المستخدم',style: TextStyles.textStyle18Bold.copyWith(
                         color: ColorManager.white,
                         fontSize: MediaQuery.sizeOf(context).height*.018
                     ),),

                     SizedBox(height: MediaQuery.of(context).size.height*.02,),

                     DefaultTextField(
                         controller: userNameController,
                         hintText: 'اسم المستخدم',
                         validator: (value){},
                         keyboardType: TextInputType.name,
                         textInputAction: TextInputAction.done,
                         fillColor: Colors.white
                     ),


                     SizedBox(height: MediaQuery.of(context).size.height*.025,),


                     Text(
                       'المجموعه الرئيسيه',style: TextStyles.textStyle18Bold.copyWith(
                         color: ColorManager.white,
                         fontSize: MediaQuery.sizeOf(context).height*.018
                     ),),

                     SizedBox(height: MediaQuery.of(context).size.height*.02,),

                     Container(
                       padding: EdgeInsets.only(
                         right: SizeConfig.height * 0.02,
                       ),
                       alignment: Alignment.centerRight,
                       width: double.infinity,
                       height: MediaQuery.sizeOf(context).height *.06,
                       decoration: BoxDecoration(
                           border: Border.all(
                               color: Colors.grey
                           ),
                           borderRadius: BorderRadius.circular(12),
                           color: Colors.white
                       ),
                       child: Text(UserDataFromStorage.mainGroupFromStorage,style: TextStyles.textStyle18Bold.copyWith(
                           color: Colors.black,
                           fontSize: 14,
                           fontWeight:  FontWeight.w400
                       ),),
                     ),

                     SizedBox(height: MediaQuery.of(context).size.height*.025,),

                     Text(
                       'المجموعه الفرعيه',style: TextStyles.textStyle18Bold.copyWith(
                         color: ColorManager.white,
                         fontSize: MediaQuery.sizeOf(context).height*.018
                     ),),

                     SizedBox(height: MediaQuery.of(context).size.height*.02,),

                     Container(
                       padding: EdgeInsets.only(
                         right: SizeConfig.height * 0.02,
                       ),
                       alignment: Alignment.centerRight,
                       width: double.infinity,
                       height: MediaQuery.sizeOf(context).height *.06,
                       decoration: BoxDecoration(
                           border: Border.all(
                               color: Colors.grey
                           ),
                           borderRadius: BorderRadius.circular(12),
                           color: Colors.white
                       ),
                       child: Text(UserDataFromStorage.subGroupFromStorage,style: TextStyles.textStyle18Bold.copyWith(
                           color: Colors.black,
                           fontSize: 14,
                           fontWeight:  FontWeight.w400
                       ),),
                     ),

                     SizedBox(height: MediaQuery.of(context).size.height*.02,),

                     Text(
                       'رقم السجل',style: TextStyles.textStyle18Bold.copyWith(
                         color: ColorManager.white,
                         fontSize: MediaQuery.sizeOf(context).height*.018
                     ),),

                     SizedBox(height: MediaQuery.of(context).size.height*.02,),

                     Container(
                       padding: EdgeInsets.only(
                         right: SizeConfig.height * 0.02,
                       ),
                       alignment: Alignment.centerRight,
                       width: double.infinity,
                       height: MediaQuery.sizeOf(context).height *.06,
                       decoration: BoxDecoration(
                           border: Border.all(
                               color: Colors.grey
                           ),
                           borderRadius: BorderRadius.circular(12),
                           color: Colors.white
                       ),
                       child: Text(UserDataFromStorage.folderNumFromStorage,style: TextStyles.textStyle18Bold.copyWith(
                           color: Colors.black,
                           fontSize: 14,
                           fontWeight:  FontWeight.w400
                       ),),
                     ),

                   ],
                 ),
               ),

               SizedBox(height: MediaQuery.of(context).size.height*.02,),

               DefaultButton(
                 buttonColor:ColorManager.primaryBlue,
                 large: false,
                 buttonText: 'حفظ البيانات ',
                 onPressed: (){
                    cubit.updateMemberInfo(
                        fullName: fullNameController.text,
                        phoneNumber: phoneController.text,
                        email: emailController.text,
                        userName: userNameController.text
                    );
                 },
               ),

               SizedBox(height: MediaQuery.of(context).size.height*.02,),


             ],
           ),
         );
      },
    );
  }
}
