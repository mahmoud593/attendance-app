import 'package:attendience_app/core/helper/app_size_config.dart';
import 'package:attendience_app/features/notification/controller/notification_cubit.dart';
import 'package:attendience_app/features/notification/controller/notification_states.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendenceNotificationScreen extends StatefulWidget {
  const AttendenceNotificationScreen({super.key});

  @override
  State<AttendenceNotificationScreen> createState() => _AttendenceNotificationScreenState();
}

class _AttendenceNotificationScreenState extends State<AttendenceNotificationScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationCubit.get(context).getAttendenceNotification(DateTime.now(),false);
  }

  @override
  Widget build(BuildContext context) {
    return  Directionality(
      textDirection:  TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions:  [
            GestureDetector(
              onTap: () {
                NotificationCubit.get(context).getAttendenceNotification(DateTime.now(),false);
              },
              child: const Padding(
                padding:  EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                child: Icon(
                Icons.filter_alt_off
                ),
              ),
            ),
          ],
          iconTheme: const IconThemeData(
            color: Colors.white
          ),
           backgroundColor: ColorManager.primaryBlue,
           title: Text("اشعارات الحضور و الانصراف",style: TextStyles.textStyle18Bold,),
           centerTitle: true,
        ),
        body: BlocConsumer<NotificationCubit,NotificationStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var cubit=NotificationCubit.get(context);
              return SingleChildScrollView(
                child: state is GetAttendenceNotificationLoadingState ?
                const Center(child: CupertinoActivityIndicator(),):
                Container(
                  child: Column(
                    children: [

                      GestureDetector(
                        onTap:  (){
                          showDatePicker(
                              context: context,
                              firstDate: DateTime.now().subtract(const Duration(days: 20000)) ,
                              lastDate: DateTime.now().add(const Duration(days: 20000)),
                          ).then((value){
                            setState(() {
                              NotificationCubit.get(context).getAttendenceNotification(value!,true);
                            });

                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.sizeOf(context).height*.02,
                            vertical: MediaQuery.sizeOf(context).height*.015,
                          ),
                          width: double.infinity,
                          height: MediaQuery.sizeOf(context).height*.05,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox( width: SizeConfig.height * .02 , ),

                              const Icon(Icons.search,color: ColorManager.primaryBlue,),

                              SizedBox( width: SizeConfig.height * .01 , ),

                              Text(' بحث في اشعارات الحضور و الانصراف بيوم معين ... ؟',
                                style: TextStyles.textStyle18Bold.copyWith(
                                  fontSize: MediaQuery.sizeOf(context).height*.012,
                                  color: ColorManager.primaryBlue,
                                ))

                            ],
                          ),
                        ),
                      ),

                      SizedBox( height: MediaQuery.sizeOf(context).height*.005, ),

                      ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.sizeOf(context).height*.02,
                                vertical: MediaQuery.sizeOf(context).height*.02,
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: MediaQuery.sizeOf(context).height*.02,
                                vertical: MediaQuery.sizeOf(context).height*.003,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: ColorManager.gray,
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(cubit.notificationList[index].title!,
                                      style: TextStyles.textStyle24Bold.copyWith(
                                          color: ColorManager.primaryBlue,
                                          fontSize: MediaQuery.sizeOf(context).height*.02
                                      ),),
                                    const SizedBox( height: 10, ),
                                    Text(cubit.notificationList[index].body!,
                                      style: TextStyles.textStyle24Bold.copyWith(
                                          color: ColorManager.black,
                                          fontSize: MediaQuery.sizeOf(context).height*.014
                                      ),),
                                    const SizedBox( height: 10, ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(cubit.notificationList[index].date!,
                                        style: TextStyles.textStyle24Bold.copyWith(
                                            color: ColorManager.black,
                                            fontSize: MediaQuery.sizeOf(context).height*.014
                                        ),),
                                    ),

                                  ]
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox( height: 10, ),
                          itemCount: cubit.notificationList.length
                      ),

                    ],
                  ),
                ),
              );
            },
        )
      ),
    );
  }
}
