import 'package:attendience_app/features/notification/controller/notification_cubit.dart';
import 'package:attendience_app/features/notification/controller/notification_states.dart';
import 'package:attendience_app/styles/assets/asset_manager.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GeneralNotificationScreen extends StatefulWidget {
  const GeneralNotificationScreen({super.key});

  @override
  State<GeneralNotificationScreen> createState() => _GeneralNotificationScreenState();
}

class _GeneralNotificationScreenState extends State<GeneralNotificationScreen> {

  @override
  void initState() {
    super.initState();
    NotificationCubit.get(context).getGeneralNotificationNotification();
  }

  @override
  Widget build(BuildContext context) {
    return  Directionality(
      textDirection:  TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
              color: Colors.white
          ),
          backgroundColor: ColorManager.primaryBlue,
          title: Text("الاشعارات العامه",style: TextStyles.textStyle18Bold,),
          centerTitle: true,
        ),
        body:BlocConsumer<NotificationCubit,NotificationStates>(
            builder: (context, state) {
              var cubit=NotificationCubit.get(context);
              return Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: AssetImage(AssetsManager.backgroundImage),
                  ),
                ),
                child: SingleChildScrollView(
                  child: state is GetGeneralNotificationLoadingState?
                    const Center(child: CupertinoActivityIndicator(),)
                    :Column(
                    children: [

                      SizedBox( height: MediaQuery.sizeOf(context).height*.02, ),

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
                                    Text(cubit.generalNotificationList[index].title!,
                                      style: TextStyles.textStyle24Bold.copyWith(
                                          color: ColorManager.primaryBlue,
                                          fontSize: MediaQuery.sizeOf(context).height*.02
                                      ),),
                                    const SizedBox( height: 10, ),
                                    Text(cubit.generalNotificationList[index].body!,
                                      style: TextStyles.textStyle24Bold.copyWith(
                                          color: ColorManager.black,
                                          fontSize: MediaQuery.sizeOf(context).height*.014
                                      ),),
                                    const SizedBox( height: 10, ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(cubit.generalNotificationList[index].date!,
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
                          itemCount: cubit.generalNotificationList.length
                      ),

                    ],
                                    ),
                ),
              );
            },
            listener: (context, state) {},
        ),
      ),
    );
  }
}
