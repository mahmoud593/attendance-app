
import 'package:attendience_app/features/start/presentation/view/widgets/start_view_body.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: ColorManager.primaryBlue,
        body: StartViewBody()
      ),
    );
  }
}
