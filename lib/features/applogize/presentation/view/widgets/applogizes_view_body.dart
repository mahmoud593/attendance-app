import 'package:attendience_app/core/helper/app_size_config.dart';
import 'package:attendience_app/features/applogize/presentation/controller/applogize_cubit.dart';
import 'package:attendience_app/features/applogize/presentation/controller/applogize_states.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplogizesViewBody extends StatelessWidget {
  ApplogizesViewBody({super.key});

  TextEditingController controller =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplogizeCubit,ApplogizeStates>(
        builder: (context, state) {
          var cubit=ApplogizeCubit.get(context);
          return SingleChildScrollView(
            child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.height * 0.02,
                      vertical: SizeConfig.height * 0.02,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: ColorManager.primaryBlue
                    ),
                    child:Column(
                        children: [
                          Row(
                            children: [
                              Text("تاريخ الطلب :",style: TextStyles.textStyle18Medium.copyWith(
                                  color: ColorManager.gray,
                                  fontSize: MediaQuery.sizeOf(context).height*.018
                              ),),
                              SizedBox(width: MediaQuery.of(context).size.height*.02,),
                              Text(cubit.applogizeList[index].day!,style: TextStyles.textStyle18Bold.copyWith(
                                  color: ColorManager.white,
                                  fontSize: MediaQuery.sizeOf(context).height*.018
                              ),),
                            ],
                          ),

                          SizedBox(height: MediaQuery.of(context).size.height*.02,),


                          Row(
                            children: [
                              Text("عدد الايام :",style: TextStyles.textStyle18Medium.copyWith(
                                  color: ColorManager.gray,
                                  fontSize: MediaQuery.sizeOf(context).height*.018
                              ),),
                              SizedBox(width: MediaQuery.of(context).size.height*.02,),
                              Text(cubit.applogizeList[index].numDays!,style: TextStyles.textStyle18Bold.copyWith(
                                  color: ColorManager.white,
                                  fontSize: MediaQuery.sizeOf(context).height*.018
                              ),),
                            ],
                          ),

                          SizedBox(height: MediaQuery.of(context).size.height*.02,),

                          Row(
                            children: [
                              Text("يبدا من يوم :",style: TextStyles.textStyle18Medium.copyWith(
                                  color: ColorManager.gray,
                                  fontSize: MediaQuery.sizeOf(context).height*.018
                              ),),
                              SizedBox(width: MediaQuery.of(context).size.height*.02,),
                              Text(cubit.applogizeList[index].startDay!,style: TextStyles.textStyle18Bold.copyWith(
                                  color: ColorManager.white,
                                  fontSize: MediaQuery.sizeOf(context).height*.018
                              ),),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*.02,),
                          Row(
                            children: [
                              Text("ينتهي يوم :",style: TextStyles.textStyle18Medium.copyWith(
                                  color: ColorManager.gray,
                                  fontSize: MediaQuery.sizeOf(context).height*.018
                              ),),
                              SizedBox(width: MediaQuery.of(context).size.height*.02,),
                              Text(cubit.applogizeList[index].endDay!,style: TextStyles.textStyle18Bold.copyWith(
                                  color: ColorManager.white,
                                  fontSize: MediaQuery.sizeOf(context).height*.018
                              ),),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*.02,),

                          Row(
                            children: [
                              Text(cubit.applogizeList[index].reason!,style: TextStyles.textStyle18Bold.copyWith(
                                  color: ColorManager.white,
                                  fontSize: MediaQuery.sizeOf(context).height*.018
                              ),),

                            ],
                          ),

                          SizedBox(height: MediaQuery.of(context).size.height*.02,),

                          if(cubit.applogizeList[index].image!="")
                          Container(
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
                            child:  Image(
                              image: NetworkImage(cubit.applogizeList[index].image!),
                            ),
                          ),


                          SizedBox(height: MediaQuery.of(context).size.height*.02,),


                          Row(
                            children: [
                              const Spacer(),
                              Text(cubit.applogizeList[index].status!,style: TextStyles.textStyle18Bold.copyWith(
                                  color: ColorManager.success,
                                  fontSize: MediaQuery.sizeOf(context).height*.018
                              ),),

                            ],
                          ),

                        ]
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: MediaQuery.of(context).size.height*.02,);
                },
                itemCount: cubit.applogizeList.length
            ),
            SizedBox(height: MediaQuery.of(context).size.height*.02,),

          ],
        ),
      );
    });
  }
}
