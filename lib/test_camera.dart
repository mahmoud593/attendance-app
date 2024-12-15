import 'dart:io';

import 'package:attendience_app/features/home/presentation/controller/home_cubit.dart';
import 'package:attendience_app/features/home/presentation/controller/home_states.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraDedection extends StatefulWidget {
  const CameraDedection({super.key,required this.isFlag});

  final bool isFlag;

  @override
  State<CameraDedection> createState() => _CameraDedectionState();
}

class _CameraDedectionState extends State<CameraDedection> {
  File? _capturedImage;

  late FaceCameraController controller;

  @override
  void initState() {
    controller = FaceCameraController(
      autoCapture: true,
      defaultCameraLens: CameraLens.front,
      onCapture: (File? image) {
        setState(() => _capturedImage = image);
      },
      onFaceDetected: (Face? face) {
        print('Face ! ${face!.boundingBox}');
        print('Face headEulerAngleX! ${face.headEulerAngleX}');
        print('Face headEulerAngleY! ${face.headEulerAngleY}');
        print('Face headEulerAngleZ! ${face.headEulerAngleZ}');
        print('Face leftEyeOpenProbability! ${face.leftEyeOpenProbability}');
        print('Face rightEyeOpenProbability! ${face.rightEyeOpenProbability}');
        print('Face smilingProbability! ${face.smilingProbability}');
        //Do something
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: BlocConsumer<HomeCubit,HomeStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return SafeArea(
                child: Builder(builder: (context) {
                  if (_capturedImage != null) {
                    return Center(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Image.file(
                            _capturedImage!,
                            width: double.maxFinite,
                            fit: BoxFit.fitWidth,
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 10,),

                              Expanded(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      if(widget.isFlag){
                                        await HomeCubit.get(context).checkUserAttendEarly();
                                        HomeCubit.get(context).checkTimeToast(autherized: 'Authorized', context: context, flag: true);
                                      }else{
                                        await HomeCubit.get(context).checkUserAttendEarly();
                                        HomeCubit.get(context).checkTimeToast(autherized: 'Authorized', context: context, flag: false);
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'اعتماد الصوره',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: ColorManager.primaryBlue,
                                          fontSize: 14, fontWeight: FontWeight.w700),
                                    )),
                              ),

                              const SizedBox(width: 10,),

                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await controller.startImageStream();
                                    setState(() => _capturedImage = null);
                                  },
                                  child: const Text(
                                    'التقاط صوره اخري',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ColorManager.primaryBlue,
                                        fontSize: 14, fontWeight: FontWeight.w700
                                    ),
                                  ),),
                              ),
                              const SizedBox(width: 10,),

                            ],
                          )
                        ],
                      ),
                    );
                  }
                  return SmartFaceCamera(
                      controller: controller,
                      messageBuilder: (context, face) {
                        if (face == null) {
                          return _message('Place your face in the camera');
                        }
                        if (!face.wellPositioned) {
                          return _message('Center your face in the square');
                        }
                        return const SizedBox.shrink();
                      });
                }),
              );
            },
        ),
    );
  }

  Widget _message(String msg) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
    child: Text(msg,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 14, height: 1.5, fontWeight: FontWeight.w400)),
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}