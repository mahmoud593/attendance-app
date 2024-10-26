import 'package:attendience_app/core/shared_preference/shared_preference.dart';
import 'package:attendience_app/features/applogize/presentation/controller/applogize_cubit.dart';
import 'package:attendience_app/features/applogize/presentation/controller/applogize_states.dart';
import 'package:attendience_app/styles/assets/asset_manager.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:attendience_app/styles/widets/default_button.dart';
import 'package:attendience_app/styles/widets/default_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../styles/size_config/app_size_config.dart';

class AddApplogizeViewBody extends StatefulWidget {
  AddApplogizeViewBody({super.key});

  @override
  State<AddApplogizeViewBody> createState() => _AddApplogizeViewBodyState();
}

class _AddApplogizeViewBodyState extends State<AddApplogizeViewBody> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApplogizeCubit,ApplogizeStates>(
        listener: (context, state) {
          if(state is ApplogizeSuccessState){
            Navigator.pop(context);
            ApplogizeCubit.get(context).startDate='';
            ApplogizeCubit.get(context).startDate='';
            ApplogizeCubit.get(context).reasonController.text='';
            ApplogizeCubit.get(context).image=null;
          }
        },
        builder: (context, state) {
          var cubit = ApplogizeCubit.get(context);
          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'يبدا من يوم',style: TextStyles.textStyle18Bold.copyWith(
                      color: ColorManager.primaryBlue,
                      fontSize: MediaQuery.sizeOf(context).height*.018
                  ),),

                  SizedBox(height: MediaQuery.of(context).size.height*.02,),

                  GestureDetector(
                    onTap: (){
                      showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate:  DateTime.now().add(const Duration(days: 365)),
                          initialDate: DateTime.now()
                      ).then((value){
                         setState(() {
                           cubit.startDate=DateFormat.yMd().format(value!);
                         });
                      });
                    },
                    child: Container(
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
                        color: Colors.grey.withOpacity(.25)
                      ),
                      child: Text(cubit.startDate !='' ?'${cubit.startDate}':'تاريخ البدايه',style: TextStyles.textStyle18Bold.copyWith(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight:  FontWeight.w400
                      ),),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height*.025,),


                  Text(
                    'ينتهي يوم',style: TextStyles.textStyle18Bold.copyWith(
                      color: ColorManager.primaryBlue,
                      fontSize: MediaQuery.sizeOf(context).height*.018
                  ),),

                  SizedBox(height: MediaQuery.of(context).size.height*.02,),

                  GestureDetector(
                    onTap: (){
                      showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate:  DateTime.now().add(const Duration(days: 365)),
                          initialDate: DateTime.now()
                      ).then((value){
                        setState(() {
                          cubit.endDate=DateFormat.yMd().format(value!);
                        });
                      });
                    },
                    child: Container(
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
                          color: Colors.grey.withOpacity(.25)
                      ),
                      child: Text(cubit.endDate !='' ?'${cubit.endDate}':'تاريخ النهايه',style: TextStyles.textStyle18Bold.copyWith(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight:  FontWeight.w400
                      ),),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height*.025,),


                  Text(
                    'سبب طلب الاذان',style: TextStyles.textStyle18Bold.copyWith(
                      color: ColorManager.primaryBlue,
                      fontSize: MediaQuery.sizeOf(context).height*.018
                  ),),

                  SizedBox(height: MediaQuery.of(context).size.height*.02,),

                  DefaultTextField(
                    validator: (value){
                      if(value!.isEmpty){
                        return 'سبب الطلب مطلوب';
                      }
                    },
                    maxLines:7 ,
                    keyboardType: TextInputType.emailAddress ,
                    fillColor: ColorManager.gray ,
                    textInputAction: TextInputAction.done,
                    hintText: 'السبب ...',
                    controller: cubit.reasonController,
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height*.025,),

                  Text(
                    'ارفق صور (اختياري)',style: TextStyles.textStyle18Bold.copyWith(
                      color: ColorManager.primaryBlue,
                      fontSize: MediaQuery.sizeOf(context).height*.018
                  ),),

                  SizedBox(height: MediaQuery.of(context).size.height*.02,),

                  GestureDetector(
                    onTap: (){
                      cubit.pickImage();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.width*.02,
                      ),
                      height:  MediaQuery.of(context).size.height*.25,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: ColorManager.gray,
                      ),
                      child: cubit.image == null? const Image(
                        image: AssetImage(AssetsManager.logo),
                      ): Image.file(cubit.image!),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height*.02,),

                  DefaultButton(
                    buttonColor:ColorManager.primaryBlue,
                    large: false,
                    buttonText: 'ارسال الطلب',
                    onPressed: (){
                      if(formKey.currentState!.validate()){

                        DateTime start = DateTime.parse(cubit.formatDate(cubit.startDate));
                        DateTime end = DateTime.parse(cubit.formatDate(cubit.endDate));

                        int differenceInDays = end.difference(start).inDays;

                        cubit.image !=null?
                        cubit.uploadImage(
                            email: UserDataFromStorage.emailFromStorage,
                            mainGroup: UserDataFromStorage.mainGroupFromStorage,
                            subGroup: UserDataFromStorage.subGroupFromStorage,
                            organizationId: UserDataFromStorage.organizationIdFromStorage,
                            userName: UserDataFromStorage.userNameFromStorage,
                            fullName: UserDataFromStorage.fullNameFromStorage,
                            folderNum: UserDataFromStorage.folderNumFromStorage,
                            uId: UserDataFromStorage.uIdFromStorage,
                            startDay: cubit.startDate,
                            numDays: differenceInDays.toString(),
                            endDay: cubit.endDate,
                            reason: cubit.reasonController.text
                        ):
                        cubit.createApplogize(
                            email: UserDataFromStorage.emailFromStorage,
                            mainGroup: UserDataFromStorage.mainGroupFromStorage,
                            subGroup: UserDataFromStorage.subGroupFromStorage,
                            organizationId: UserDataFromStorage.organizationIdFromStorage,
                            userName: UserDataFromStorage.userNameFromStorage,
                            fullName: UserDataFromStorage.fullNameFromStorage,
                            folderNum: UserDataFromStorage.folderNumFromStorage,
                            uId: UserDataFromStorage.uIdFromStorage,
                            startDay: cubit.startDate,
                            numDays: differenceInDays.toString(),
                            endDay: cubit.endDate,
                            reason: cubit.reasonController.text
                        );

                      }
                    },
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height*.02,),

                ],
              ),
            ),
          );
        },
    );
  }
}
