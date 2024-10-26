import 'package:attendience_app/styles/assets/asset_manager.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:flutter/material.dart';

class FingurePrintWidget extends StatelessWidget {
  const FingurePrintWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.symmetric(
        vertical:  MediaQuery.sizeOf(context).height * .02,
        horizontal: MediaQuery.sizeOf(context).width * .05,
      ),
      height: MediaQuery.sizeOf(context).height * .22,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: ColorManager.primaryBlue,
        ),
        color: ColorManager.gray.withOpacity(.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Image(
          image:AssetImage(AssetsManager.fingerPrint)
      ),
    );
  }
}
