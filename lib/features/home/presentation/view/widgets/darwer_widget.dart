import 'package:attendience_app/core/helper/constants.dart';
import 'package:attendience_app/core/helper/material_navigation.dart';
import 'package:attendience_app/core/shared_preference/shared_preference.dart';
import 'package:attendience_app/features/applogize/presentation/view/add_applogize_screen.dart';
import 'package:attendience_app/features/applogize/presentation/view/applogizes_screen.dart';
import 'package:attendience_app/features/auth/presentaion/view/screens/login/member_login.dart';
import 'package:attendience_app/features/home/data/models/drawer_model.dart';
import 'package:attendience_app/features/home/presentation/controller/home_cubit.dart';
import 'package:attendience_app/features/home/presentation/controller/home_states.dart';
import 'package:attendience_app/features/notification/presentation/view/attendence_notification_screen.dart';
import 'package:attendience_app/features/notification/presentation/view/general_notification_screen.dart';
import 'package:attendience_app/features/profile/presentation/view/screens/profile_screen.dart';
import 'package:attendience_app/features/start/presentation/view/start_screen.dart';
import 'package:attendience_app/features/student_behaver/presentation/view/student_behaver_view.dart';
import 'package:attendience_app/styles/assets/asset_manager.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget drawerWidget({required BuildContext context}) {

  List <GestureTapCallback?>educationalFunction=[
    (){
      customPushNavigator(context, const ProfileScreen());
    },
    (){
      customPushNavigator(context, const StudentBehaverView());
    },
    (){
      customPushNavigator(context, const GeneralNotificationScreen());
    },
    (){
      customPushNavigator(context, const AttendenceNotificationScreen());
    },
    (){
      customPushNavigator(context,  const ApplogizesScreen());
    },
    (){
      customPushNavigator(context, const AddApplogizeScreen());
    },
    (){
      UserDataFromStorage.setAdminUid('');
      UserDataFromStorage.setUid('');
      customPushNavigator(context, const MemberLoginScreen());
    },

  ];

  List<GestureTapCallback?> unEducationalFunction=[
        (){
      customPushNavigator(context, const ProfileScreen());
    },
        (){
      customPushNavigator(context, const GeneralNotificationScreen());
    },
        (){
      customPushNavigator(context, const AttendenceNotificationScreen());
    },
        (){
      customPushNavigator(context,  const ApplogizesScreen());
    },
        (){
      customPushNavigator(context, const AddApplogizeScreen());
    },
        (){
          UserDataFromStorage.setAdminUid('');
          UserDataFromStorage.setUid('');
      customPushNavigator(context, const MemberLoginScreen());
    },

  ];

  //    UserDataFromStorage.setUid("")
  return BlocBuilder<HomeCubit,HomeStates>(builder:(context,state){
     return Drawer(
       backgroundColor: ColorManager.white,
       child: Column(
         children: [

           Container(
             width: double.infinity,
             color: ColorManager.primaryBlue,
             child: Column(
               children: [
                 SizedBox(height: MediaQuery.sizeOf(context).height *.05,),
                 Image(
                   height: MediaQuery.sizeOf(context).height *.15,
                   color:  ColorManager.white,
                   image: const AssetImage(AssetsManager.logo),
                 ),
                 SizedBox(height: MediaQuery.sizeOf(context).height *.02,),
                 Text(
                   "الحضور و الانصراف",
                   style: TextStyles.textStyle24Bold.copyWith(
                       color: ColorManager.white,
                       fontSize: MediaQuery.sizeOf(context).height * .022
                   ),
                 ),

                 SizedBox(height: MediaQuery.sizeOf(context).height *.04,),

               ],
             ),
           ),

           SizedBox(height: MediaQuery.sizeOf(context).height *.02,),

           Expanded(
             child: ListView.separated(
               padding: EdgeInsets.zero,
               itemBuilder: ( context, index) {
                 return  GestureDetector(
                   onTap:HomeCubit.get(context).isEducational ==true && UserDataFromStorage.gradeAdminFromStorage==true?
                       educationalFunction[index]:
                       unEducationalFunction[index],
                   child: HomeCubit.get(context).isEducational==true && UserDataFromStorage.gradeAdminFromStorage==true?
                   Row(
                       children: [

                         IconButton(
                             onPressed: (){
                             },
                             icon:  Icon(Constants.drawerEducationalData[index].icon,color: ColorManager.primaryBlue,)
                         ),

                         Text(
                           Constants.drawerEducationalData[index].title,
                           style: TextStyles.textStyle24Medium.copyWith(
                               color: ColorManager.primaryBlue,
                               fontSize: MediaQuery.sizeOf(context).height * .016
                           ),
                         ),

                       ]):
                   Row(
                       children: [

                         IconButton(
                             onPressed: (){
                             },
                             icon:  Icon(Constants.drawerUnEducationalData[index].icon,color: ColorManager.primaryBlue,)
                         ),

                         Text(
                           Constants.drawerUnEducationalData[index].title,
                           style: TextStyles.textStyle24Medium.copyWith(
                               color: ColorManager.primaryBlue,
                               fontSize: MediaQuery.sizeOf(context).height * .016
                           ),
                         ),

                       ]),
                 );
               },
               separatorBuilder: (context,index){
                 return const Divider(color: ColorManager.gray,);
               },
               itemCount: HomeCubit.get(context).isEducational==true && UserDataFromStorage.gradeAdminFromStorage==true?
               Constants.drawerEducationalData.length : Constants.drawerUnEducationalData.length,
             ),
           ),


         ],
       ),
     );
  } );
}