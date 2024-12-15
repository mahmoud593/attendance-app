import 'package:attendience_app/core/helper/app_size_config.dart';
import 'package:attendience_app/styles/assets/asset_manager.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:attendience_app/styles/widets/default_button.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helper/material_navigation.dart';
import '../../../../scan_qr_code/presentation/view/scan_qr_code_body.dart';

class DoneRecordStudentBody extends StatelessWidget {
  const DoneRecordStudentBody({super.key,required this.image,required this.title,required this.color});

  final String image;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
        onPressed: (){
          customPushAndRemoveUntil(context, ScanQrCodeBody());
        }, icon: const Icon(Icons.arrow_back_ios,color: ColorManager.black,),),
        backgroundColor: ColorManager.white,
        elevation: 0,
        centerTitle: true,
        title: Text('تسجيل الحضور',style: TextStyles.textStyle18Bold.copyWith(
            color: ColorManager.black
        ),
        ),
      ),
      body: WillPopScope(
        onWillPop: (){
          customPushAndRemoveUntil(context, const ScanQrCodeBody());
          return Future.value(true);
        },
        child: Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              fit: BoxFit.fitHeight,
              image: AssetImage(AssetsManager.backgroundImage),
            ),
            color: ColorManager.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.height * .07),
              topRight: Radius.circular(SizeConfig.height * .07),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image(
                height: MediaQuery.sizeOf(context).height * .2,
                width: MediaQuery.sizeOf(context).height * .2,
                image: AssetImage(image),
              ),
              SizedBox(height:  MediaQuery.sizeOf(context).height * .05,),


              Text('تسجيل الحضور',style: TextStyles.textStyle24Bold.copyWith(
                  color: ColorManager.black
              ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height:  MediaQuery.sizeOf(context).height * .05,),

              Text(title,style: TextStyles.textStyle18Bold.copyWith(
                  color: color
              ),
                textAlign: TextAlign.center,
              ),


              Padding(
                padding:  EdgeInsets.all(MediaQuery.sizeOf(context).height * .1,),
                child: DefaultButton(

                    buttonColor: ColorManager.primaryBlue,
                    onPressed: () {
                      customPushAndRemoveUntil(context, ScanQrCodeBody());
                    },
                    large: false,
                    buttonText: ' تسجيل حضور طالب اخر'
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
