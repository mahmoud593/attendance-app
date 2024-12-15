import 'dart:io';

import 'package:attendience_app/core/helper/material_navigation.dart';
import 'package:attendience_app/features/home/presentation/controller/home_cubit.dart';
import 'package:attendience_app/features/home/presentation/controller/home_states.dart';
import 'package:attendience_app/styles/assets/asset_manager.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:attendience_app/styles/widets/default_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class StudentBehaverBody extends StatefulWidget {
  const StudentBehaverBody({super.key});

  @override
  State<StudentBehaverBody> createState() => _StudentBehaverBodyState();
}

class _StudentBehaverBodyState extends State<StudentBehaverBody> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    // Try to set the front camera as the default camera
    controller.getCameraInfo().then((cameras) async{
      if(cameras ==CameraFacing.back) {
        setState(()async {
          await controller.flipCamera();
        });
      }
    });

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        HomeCubit.get(context).getEducationalMemberInfo(memberId: result!.code.toString(),context: context, attendence: false);
        return;
      });
    });


  }


  @override
  void initState() {
    super.initState();
    controller?.flipCamera();
  }
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
        builder:(context, state) {
          return  ModalProgressHUD(
            inAsyncCall: state is GetEducationalMembersLoadingState || state is RecordEducationalAttendenceLoadingState,
            progressIndicator: const CupertinoActivityIndicator() ,
            child: Column(
              children: <Widget>[
                Container(
                  padding:  const EdgeInsets.only(
                    left:  10.0,
                    top:  15.0,
                  ),
                  alignment: Alignment.centerLeft,
                  color: ColorManager.primaryBlue,
                  height:  MediaQuery.of(context).size.height*.12,
                  width:  MediaQuery.of(context).size.width,
                  child: IconButton(
                        onPressed: (){
                          setState(()async {
                            await controller?.flipCamera();
                          });
                        },
                        icon: Icon(Icons.cameraswitch_outlined, color: ColorManager.white,)
                    ),
                ),

                Expanded(
                  flex: 5,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    color: ColorManager.primaryBlue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('مرر الباركود لتقيم السلوك',style: TextStyles.textStyle18Bold.copyWith(
                            color: ColorManager.white
                        ),),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }
    );
  }
}


