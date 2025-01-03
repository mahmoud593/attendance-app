import 'dart:io';

import 'package:attendience_app/core/helper/app_size_config.dart';
import 'package:attendience_app/core/helper/material_navigation.dart';
import 'package:attendience_app/core/shared_preference/shared_preference.dart';
import 'package:attendience_app/features/auth/presentaion/controller/auth_cubit.dart';
import 'package:attendience_app/features/home/presentation/controller/home_cubit.dart';
import 'package:attendience_app/features/home/presentation/controller/home_states.dart';
import 'package:attendience_app/features/home/presentation/view/screens/home_screen.dart';
import 'package:attendience_app/styles/assets/asset_manager.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:attendience_app/styles/widets/default_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQrCodeBody extends StatefulWidget {
  const ScanQrCodeBody({super.key});

  @override
  State<ScanQrCodeBody> createState() => _ScanQrCodeBodyState();
}

class _ScanQrCodeBodyState extends State<ScanQrCodeBody> {

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

  bool isProcessing = false;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    // Try to set the front camera as the default camera
    if(UserDataFromStorage.cameraFrontFromStorage==false){
      controller.getCameraInfo().then((cameras) async{
        if(cameras ==CameraFacing.back) {
          setState(()async {
            await controller.flipCamera();
          });
        }
      });
    }

    controller.scannedDataStream.listen((scanData) async{

      if (isProcessing) return;

      setState(() {
        isProcessing = true;
        result = scanData;
      });

      try {
        // Navigator.pop(context);
        HomeCubit.get(context).getEducationalMemberInfo(
            memberId: result!.code.toString()
            ,context: context , attendence: true);

      } catch (e) {
        print(e);
      } finally {
        setState(() {
          isProcessing = false;
        });
      }

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
    return BlocConsumer<HomeCubit, HomeStates>(
      builder:(context, state) {
        return WillPopScope(
          onWillPop: (){
            AuthCubit.get(context).getHomeMember(
                memberId: UserDataFromStorage.adminUidFromStorage,
                macAddress: UserDataFromStorage.macAddressFromStorage
            ).then((value){
            });
            customPushAndRemoveUntil(context, const HomeScreen());
            return Future.value(true);
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: ColorManager.primaryBlue,
              leading:IconButton(
                    onPressed: (){
                      AuthCubit.get(context).getHomeMember(
                          memberId: UserDataFromStorage.adminUidFromStorage,
                          macAddress: UserDataFromStorage.macAddressFromStorage
                      ).then((value){
                      });
                      customPushAndRemoveUntil(context, const HomeScreen());
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )
                ),
              actions: [
                IconButton(
                    onPressed: (){
                      setState(()async {
                        UserDataFromStorage.setCameraFront(UserDataFromStorage.cameraFrontFromStorage==false?true:false);
                        await controller?.flipCamera();
                      });
                      },
                    icon: const Icon(Icons.cameraswitch_outlined, color: ColorManager.white,)
                ),
              ],
            ),
            body: state is GetEducationalMembersLoadingState || state is RecordEducationalAttendenceLoadingState?
            Container(
              width: SizeConfig.width,
              height:  SizeConfig.height,
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
              child: const Center(
                child: CircularProgressIndicator(
                  color: ColorManager.primaryBlue,
                ),
              ),
            ):
            Column(
              children: <Widget>[
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
                        Text('مرر الباركود لتسجيل الحضور',style: TextStyles.textStyle18Bold.copyWith(
                          color: ColorManager.white
                        ),),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
      listener: (context, state)async {
        if(state is GetEducationalMembersSuccess1State){
          await HomeCubit.get(context).recordEducationalAttendence(context: context);
        }
      },
    );
  }
}


