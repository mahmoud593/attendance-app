import 'package:attendience_app/core/helper/app_size_config.dart';
import 'package:attendience_app/features/notification/controller/notification_cubit.dart';
import 'package:attendience_app/features/notification/controller/notification_states.dart';
import 'package:attendience_app/styles/assets/asset_manager.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:attendience_app/styles/widets/default_text_field.dart';
import 'package:attendience_app/styles/widets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GeneralNotificationRepliesScreen extends StatefulWidget {
  const GeneralNotificationRepliesScreen({super.key,required this.notificationId});
  final String notificationId;

  @override
  State<GeneralNotificationRepliesScreen> createState() => _GeneralNotificationRepliesScreenState();
}

class _GeneralNotificationRepliesScreenState extends State<GeneralNotificationRepliesScreen> {

  @override
  void initState() {
    super.initState();
    NotificationCubit.get(context).getRepliesGeneralNotificationNotification(notificationId: widget.notificationId);
  }

  TextEditingController messageController = TextEditingController();

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
          title: Text("الردود",style: TextStyles.textStyle18Bold,),
          centerTitle: true,
        ),
        body:BlocConsumer<NotificationCubit,NotificationStates>(
          builder: (context, state) {
            var cubit=NotificationCubit.get(context);
            return Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: AssetImage(AssetsManager.backgroundImage),
                ),
              ),
              child: state is GetGeneralNotificationLoadingState?
              const Center(child: CircularProgressIndicator(color: ColorManager.primaryBlue,),)
                  :Column(
                children: [

                  SizedBox( height: MediaQuery.sizeOf(context).height*.02, ),

                  Expanded(
                    child: ListView.separated(

                        itemBuilder: (context, index) {
                          return cubit.replies[index].fromSystem==true?
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.sizeOf(context).height*.02,
                              vertical: MediaQuery.sizeOf(context).height*.02,
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: MediaQuery.sizeOf(context).height*.02,
                              vertical: MediaQuery.sizeOf(context).height*.003,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(SizeConfig.height * .02),
                                topRight: Radius.circular(SizeConfig.height * .02),
                                bottomLeft: Radius.circular(SizeConfig.height * .02),
                              ),
                              color: ColorManager.darkWhite,
                            ),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.computer
                                  ),
                                  SizedBox(width:  MediaQuery.sizeOf(context).height*.01,),
                                  Text(cubit.replies[index].message!,
                                    style: TextStyles.textStyle18Bold.copyWith(
                                        color: ColorManager.primaryBlue,
                                        fontSize: MediaQuery.sizeOf(context).height*.018
                                    ),),

                                ]
                            ),
                          ):
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.sizeOf(context).height*.02,
                              vertical: MediaQuery.sizeOf(context).height*.02,
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: MediaQuery.sizeOf(context).height*.02,
                              vertical: MediaQuery.sizeOf(context).height*.003,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(SizeConfig.height * .02),
                                topRight: Radius.circular(SizeConfig.height * .02),
                                bottomRight: Radius.circular(SizeConfig.height * .02),
                              ),
                              color: ColorManager.primaryBlue,
                            ),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                  ),
                                  SizedBox(width:  MediaQuery.sizeOf(context).height*.01,),
                                  Text(cubit.replies[index].message!,
                                    style: TextStyles.textStyle18Medium.copyWith(
                                        color: ColorManager.white,
                                        fontSize: MediaQuery.sizeOf(context).height*.018
                                    ),),
                                  SizedBox(height:  MediaQuery.sizeOf(context).height*.01,),
                                ]
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox( height: 10, ),
                        itemCount: cubit.replies.length
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: DefaultTextField(
                              controller: messageController,
                              hintText: 'اكتب ردكً',
                              validator: (value) {
                                if(value!.isEmpty){
                                  return "اكتب ردكً";
                                }
                              },
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              fillColor: ColorManager.gray
                          ),
                        ),
                        SizedBox( width:  MediaQuery.sizeOf(context).height*.005,),
                        CircleAvatar(
                            backgroundColor:  ColorManager.primaryBlue,
                            child: IconButton(onPressed: (){
                              cubit.addGeneralNotificationReplies(notificationId: widget.notificationId,message:  messageController.text);
                            }, icon: const Icon(Icons.send,color: ColorManager.gray,size: 20,)
                            ))
                      ],
                    ),
                  ),




                ],
              ),
            );
          },
          listener: (context, state) {
            if(state is AddReplySuccessState){
              customToast(title: 'تم ارسال الرد', color: ColorManager.primaryBlue);
              messageController.clear();
            }
          },
        ),
      ),
    );
  }
}
