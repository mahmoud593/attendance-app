import 'package:attendience_app/features/home/presentation/view/screens/home_screen.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:flutter/material.dart';

class LoginAttandence extends StatelessWidget {
  const LoginAttandence({super.key});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).height*.02,
          vertical: MediaQuery.sizeOf(context).height*.04,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).height*.02,
          vertical: MediaQuery.sizeOf(context).height*.003,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorManager.gray,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(" تسجيل الحضور و الانصراف",
                style: TextStyles.textStyle24Bold.copyWith(
                    color: ColorManager.black,
                    fontSize: MediaQuery.sizeOf(context).height*.017
                ),),

            ]
        ),
      ),
    );
  }
}
