import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:flutter/material.dart';


class DefaultButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  double? width;
  final Color buttonColor;
  bool large;

   DefaultButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.width = double.infinity,
    required this.buttonColor,
     required this.large,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: MediaQuery.sizeOf(context).height*0.05,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).height*0.01),
        color: buttonColor,
      ),

      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: large?TextStyles.textStyle24Bold:TextStyles.textStyle18Medium,
        ),
      ),
    );
  }
}

