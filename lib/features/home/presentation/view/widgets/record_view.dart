import 'dart:async';

import 'package:attendience_app/features/home/presentation/controller/home_cubit.dart';
import 'package:attendience_app/features/home/presentation/controller/home_states.dart';
import 'package:attendience_app/styles/assets/asset_manager.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class RecordView extends StatefulWidget {
  const RecordView({super.key,required this.isFlag});

  final bool isFlag;

  @override
  State<RecordView> createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> {

  Timer ?timer;

  int seconds = 0;


  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: BlocConsumer<HomeCubit,HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage(AssetsManager.backgroundImage),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height*.1,),

                Lottie.asset(
                    'asstes/images/record.json',
                    height: MediaQuery.sizeOf(context).height*.3,
                    width: MediaQuery.sizeOf(context).height*.3
                ),

                SizedBox(height: MediaQuery.sizeOf(context).height*.08,),


                Text('${seconds} ثانية',style: TextStyles.textStyle18Bold.copyWith(
                    color: ColorManager.primaryBlue
                )),

                Lottie.asset(
                    'asstes/images/wave.json',
                    height: 100,
                    width: double.infinity
                ),

                SizedBox(height: MediaQuery.sizeOf(context).height*.1,),


                MaterialButton(
                  minWidth:  MediaQuery.sizeOf(context).width*.8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: ColorManager.primaryBlue,
                  onPressed: ()async{
                    if(widget.isFlag){
                      await HomeCubit.get(context).checkUserAttendEarly();
                      HomeCubit.get(context).checkTimeToast(autherized: 'Authorized', context: context, flag: true);
                    }else{
                      await HomeCubit.get(context).checkUserAttendEarly();
                      HomeCubit.get(context).checkTimeToast(autherized: 'Authorized', context: context, flag: false);
                    }
                    Navigator.pop(context);
                  },
                  child: Text('تسجيل الصوت',style: TextStyles.textStyle18Bold.copyWith(
                      color: Colors.white
                  ),
                  ),
                ),

              ],
            ),
          );
        },
      )
    );
  }
}
