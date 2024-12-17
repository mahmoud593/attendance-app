import 'package:attendience_app/core/helper/material_navigation.dart';
import 'package:attendience_app/core/shared_preference/shared_preference.dart';
import 'package:attendience_app/features/auth/data/auth_repo_implement/auth_repo_implement.dart';
import 'package:attendience_app/features/auth/presentaion/controller/auth_cubit.dart';
import 'package:attendience_app/features/home/presentation/view/screens/home_screen.dart';
import 'package:attendience_app/features/student_behaver/presentation/widget/record_student_grade_body.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:flutter/material.dart';

class RecordStudentGradeView extends StatelessWidget {
  const RecordStudentGradeView({
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed:()async{
              AuthCubit.get(context).getHomeMember(
                  memberId: UserDataFromStorage.adminUidFromStorage,
                  macAddress: UserDataFromStorage.macAddressFromStorage
              ).then((value){
              });
              customPushAndRemoveUntil(context, HomeScreen());
            } ,
            icon: const Icon(
                Icons.arrow_back
            )
        ),
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        backgroundColor: ColorManager.primaryBlue,
        title: Text("تقييم سلوك الطالب",style: TextStyles.textStyle18Bold,),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: ()async{
          AuthCubit.get(context).getHomeMember(
              memberId: UserDataFromStorage.adminUidFromStorage,
              macAddress: UserDataFromStorage.macAddressFromStorage
          ).then((value){
          });
          customPushAndRemoveUntil(context, const HomeScreen());
          return true;
        } ,
        child: RecordStudentGradeBody(
          studentId: studentId,
          studentName: studentName,
          studentMainGroup: studentMainGroup,
          studentSubGroup: studentSubGroup ,
        ),
      ),
    );
  }
}
