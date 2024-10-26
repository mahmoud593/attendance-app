import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthTextFormField extends StatefulWidget {
  final String hintText;
  TextInputAction textInputAction;
  FormFieldValidator validator;
  TextInputType keyboardType;
  bool withSuffix;
  bool isPassword;
  bool viewPassword;
  IconData? suffixIcon;
  final TextEditingController controller;

  AuthTextFormField(
      {this.withSuffix = false,
      this.isPassword = false,
      this.viewPassword = true,
      this.suffixIcon,
      required this.validator,
      required this.keyboardType,
      required this.textInputAction,
      required this.hintText,
      required this.controller,
      super.key});

  @override
  State<AuthTextFormField> createState() => _AuthTextFormFieldState();
}

class _AuthTextFormFieldState extends State<AuthTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        TextFormField(
          controller: widget.controller,
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType,
          textDirection: TextDirection.rtl,
          validator: widget.validator,
          obscureText: widget.isPassword ? widget.viewPassword : false,
          cursorColor: ColorManager.black,
          decoration: InputDecoration(

            enabled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).height*0.01),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).height*0.01),
              borderSide: const BorderSide(
                color: Color(0xFFF0F2F7),
              ),
            ),
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).height*0.01),
              borderSide:   const BorderSide(
                color: ColorManager.gray,
              ),

            ),

            contentPadding: const EdgeInsets.all(15.0),
            hintStyle: TextStyles.textStyle18Regular.copyWith(
                color: ColorManager.darkGrey.withOpacity(.5),
                fontSize: MediaQuery.sizeOf(context).height*0.015
            ),
            hintText: widget.hintText,
            fillColor: Colors.grey[300],
            suffixIcon: widget.withSuffix == true
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        widget.viewPassword = !widget.viewPassword;
                      });
                    },
                    icon: widget.viewPassword == false
                        ? const Icon(
                            Icons.visibility_outlined,
                            color: Colors.grey,
                          )
                        : const Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                  )
                : null,
          ),
          style:
              TextStyles.textStyle18Regular.copyWith(
                  color: ColorManager.black,
                  fontSize:  MediaQuery.sizeOf(context).height*0.015
              ),
        ),
      ],
    );
  }
}
