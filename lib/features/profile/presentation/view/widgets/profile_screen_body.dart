
import 'package:attendience_app/core/helper/app_size_config.dart';
import 'package:attendience_app/core/shared_preference/shared_preference.dart';
import 'package:attendience_app/styles/assets/asset_manager.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:attendience_app/styles/widets/default_button.dart';
import 'package:attendience_app/styles/widets/default_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({super.key});

  static TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
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
                  child: Text(UserDataFromStorage.fullNameFromStorage,style: TextStyles.textStyle18Bold.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight:  FontWeight.w400
                  ),),
                ),

                SizedBox(height: MediaQuery.of(context).size.height*.025,),


                Text(
                  'البريد الالكتروني',style: TextStyles.textStyle18Bold.copyWith(
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
                  child: Text(UserDataFromStorage.emailFromStorage,style: TextStyles.textStyle18Bold.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight:  FontWeight.w400
                  ),),
                ),


                SizedBox(height: MediaQuery.of(context).size.height*.025,),

                Text(
                  'رقم الهاتف',style: TextStyles.textStyle18Bold.copyWith(
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
                  child: Text(UserDataFromStorage.phoneNumberFromStorage,style: TextStyles.textStyle18Bold.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight:  FontWeight.w400
                  ),),
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
                  child: Text(UserDataFromStorage.userNameFromStorage,style: TextStyles.textStyle18Bold.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight:  FontWeight.w400
                  ),),
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

          // DefaultButton(
          //     buttonColor:ColorManager.primaryBlue,
          //     large: false,
          //     buttonText: 'حفظ البيانات ',
          //     onPressed: (){},
          // ),
          //
          // SizedBox(height: MediaQuery.of(context).size.height*.02,),


        ],
      ),
    );
  }
}
