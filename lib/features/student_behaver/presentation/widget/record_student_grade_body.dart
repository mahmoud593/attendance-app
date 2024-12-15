import 'package:attendience_app/core/shared_preference/shared_preference.dart';
import 'package:attendience_app/features/student_behaver/presentation/controller/student_grade_cubit.dart';
import 'package:attendience_app/features/student_behaver/presentation/controller/student_grade_states.dart';
import 'package:attendience_app/styles/assets/asset_manager.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:attendience_app/styles/widets/default_button.dart';
import 'package:attendience_app/styles/widets/default_text_field.dart';
import 'package:attendience_app/styles/widets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordStudentGradeBody extends StatelessWidget {
   RecordStudentGradeBody({
    super.key,
    required this.studentName,
    required this.studentId,
    required this.studentMainGroup,
    required this.studentSubGroup
  });

  final String studentName;
  final String studentId;
  final String studentMainGroup;
  final String studentSubGroup;


  static TextEditingController gradeController = TextEditingController();
  static TextEditingController commentController = TextEditingController();
   GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentGradeCubit,StudentGradeStates>(
      builder: (context, state) {
        var cubit=StudentGradeCubit.get(context);
        return Form(
          key: formKey,
          child: Container(
            height: double.infinity,
            width:  double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage(AssetsManager.backgroundImage),
              ),
            ),
            child: SingleChildScrollView(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).height*.02,
                  ),
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [

                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin:  EdgeInsets.symmetric(
                            horizontal: MediaQuery.sizeOf(context).width*.05,
                            vertical: MediaQuery.sizeOf(context).height*.02,
                          ),
                          padding:  EdgeInsets.symmetric(
                            horizontal: MediaQuery.sizeOf(context).width*.05,
                            vertical: MediaQuery.sizeOf(context).height*.02,
                          ),
                          decoration: BoxDecoration(
                            color: ColorManager.primaryBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: MediaQuery.sizeOf(context).height*.3,
                          width: MediaQuery.sizeOf(context).width*.8,
                          child: Column(
                            mainAxisAlignment:  MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: MediaQuery.sizeOf(context).width*.1,
                                backgroundColor: ColorManager.white,
                                child: Image(
                                  height: MediaQuery.sizeOf(context).height*.065,
                                  width: MediaQuery.sizeOf(context).width*.22,
                                  image: const AssetImage(AssetsManager.studentImage),
                                ),
                              ),
                              SizedBox( height: MediaQuery.sizeOf(context).height*.02, ),

                              Text(studentName,style: TextStyles.textStyle18Bold,),

                              SizedBox( height: MediaQuery.sizeOf(context).height*.02, ),

                              Text(studentMainGroup,style: TextStyles.textStyle18Bold,),

                              SizedBox( height: MediaQuery.sizeOf(context).height*.02, ),

                              Text(studentSubGroup,style: TextStyles.textStyle18Bold,),
                            ],
                          ),
                        ),
                      ),

                      Text(' التقيم',style: TextStyles.textStyle24Bold.copyWith(color: ColorManager.primaryBlue),),

                      SizedBox( height: MediaQuery.sizeOf(context).height*.02, ),

                      DefaultTextField(
                          controller: gradeController,
                          hintText: 'ادخل الدرجات',
                          validator: (value) {
                              if(value!.isEmpty){
                                return 'ادخل الدرجات';
                              }
                          },
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          fillColor: ColorManager.gray
                      ),

                      SizedBox( height: MediaQuery.sizeOf(context).height*.02, ),

                      Text(' تعليق',style: TextStyles.textStyle24Bold.copyWith(color: ColorManager.primaryBlue),),

                      SizedBox( height: MediaQuery.sizeOf(context).height*.02, ),

                      DefaultTextField(
                          controller: commentController,
                          maxLines: 3,
                          hintText: 'ادخل التعليق',
                          validator: (value) {
                            if(value!.isEmpty){
                              return 'ادخل التعليق';
                            }
                          },
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.done,
                          fillColor: ColorManager.gray
                      ),

                      SizedBox( height: MediaQuery.sizeOf(context).height*.02, ),

                      Text(' نوع السلوك',style: TextStyles.textStyle24Bold.copyWith(color: ColorManager.primaryBlue),),

                      SizedBox( height: MediaQuery.sizeOf(context).height*.02, ),

                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                cubit.setPassive();
                              },
                              child: Container(
                                padding:  EdgeInsets.symmetric(
                                  horizontal: MediaQuery.sizeOf(context).height*.02,
                                  vertical: MediaQuery.sizeOf(context).height*.02,
                                ),
                                decoration: BoxDecoration(
                                  color: cubit.isPassive? ColorManager.primaryBlue:ColorManager.gray,
                                  borderRadius:  BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Image(
                                      height: MediaQuery.sizeOf(context).height*.065,
                                      width: MediaQuery.sizeOf(context).width*.22,
                                      image: const AssetImage(AssetsManager.happy),
                                    ),

                                    SizedBox( height: MediaQuery.sizeOf(context).height*.02, ),

                                    Text('سلوك ايجابي',style: TextStyles.textStyle18Bold.copyWith(
                                        color: cubit.isPassive? ColorManager.gray:ColorManager.primaryBlue
                                    ),),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox( width: MediaQuery.sizeOf(context).height*.02, ),

                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                cubit.setPassive();
                              },
                              child: Container(
                                padding:  EdgeInsets.symmetric(
                                  horizontal: MediaQuery.sizeOf(context).height*.02,
                                  vertical: MediaQuery.sizeOf(context).height*.02,
                                ),
                                decoration: BoxDecoration(
                                  color: cubit.isFail? ColorManager.primaryBlue: ColorManager.gray,
                                  borderRadius:  BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Image(
                                      height: MediaQuery.sizeOf(context).height*.065,
                                      width: MediaQuery.sizeOf(context).width*.22,
                                      image: const AssetImage(AssetsManager.sad),
                                    ),
                                    SizedBox( height: MediaQuery.sizeOf(context).height*.02, ),

                                    Text('سلوك سلبي',style: TextStyles.textStyle18Bold.copyWith(
                                        color: cubit.isFail? ColorManager.gray: ColorManager.primaryBlue
                                    ),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox( height: MediaQuery.sizeOf(context).height*.05, ),

                      DefaultButton(
                          buttonText: 'ارسال التقيم',
                          onPressed: (){
                            if(formKey.currentState!.validate()){
                              cubit.isPassive?
                              cubit.uploadStudentPassiveGrades(
                                  type: 'passive',
                                  reason: commentController.text,
                                  grade: gradeController.text ,
                                  studentId: studentId
                              ):cubit.uploadStudentFailGrades(
                                  type: 'fail',
                                  grade: gradeController.text ,
                                  studentId: studentId
                              );
                            }

                          },
                          buttonColor: ColorManager.primaryBlue,
                          large: false
                      ),

                      SizedBox( height: MediaQuery.sizeOf(context).height*.02, ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if(state is UploadGradeSuccessState){
          gradeController.clear();
          commentController.clear();
          StudentGradeCubit.get(context).isFail=false;
          StudentGradeCubit.get(context).isPassive=false;
        }
      },
    );
  }
}
