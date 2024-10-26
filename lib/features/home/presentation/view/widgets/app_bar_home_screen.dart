
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:flutter/material.dart';

AppBar appBarHomeScreen({required BuildContext context}) {
  return AppBar(
    centerTitle: true,
    title:Text(
      "نظام البصمة",
      style: TextStyles.textStyle24Bold.copyWith(
          color: ColorManager.white,
          fontSize: MediaQuery.sizeOf(context).height * .022
      ),
    ),
    iconTheme: const IconThemeData(
        color: Colors.white
    ),
    elevation: 0.0,
    backgroundColor: Colors.transparent,
  );
}