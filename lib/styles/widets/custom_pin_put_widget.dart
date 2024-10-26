// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pinput/pinput.dart';
// import 'package:travel_system/core/helper/app_size_config.dart';
// import 'package:travel_system/core/helper/pin_put_decortion.dart';
// import 'package:travel_system/styles/colors/color_manager.dart';
//
//
// class CustomPinPutWidget extends StatelessWidget {
//   final TextEditingController otpController ;
//   final Function(String val) onChanged;
//   final Function(String val) onSubmit;
//   final FormFieldValidator validator;
//   final bool enabled;
//   final int length;
//
//   const CustomPinPutWidget({
//     Key? key,
//     required this.otpController,
//     required this.onChanged,
//     required this.onSubmit,
//     required this.validator,
//     required this.enabled,
//     required this.length,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Directionality(
//       textDirection: TextDirection.ltr,
//       child: Pinput(
//         defaultPinTheme:defaultPinTheme.copyWith(
//           height: SizeConfig.height*0.062,
//           width: SizeConfig.height*0.07,
//           textStyle: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorManager.gray,fontWeight: FontWeight.w700, fontSize: SizeConfig.headline3Size),
//           decoration: BoxDecoration(
//             color: ColorManager.white,
//             border: Border.all(
//               color: ColorManager.gray,
//             ),
//             borderRadius: BorderRadius.circular(SizeConfig.height*0.015),
//           ),
//         ),
//         focusedPinTheme: focusedPinTheme.copyWith(
//           height: SizeConfig.height*0.062,
//           width: SizeConfig.height*0.07,
//           textStyle: Theme.of(context).textTheme.displaySmall!.copyWith(color:ColorManager.black,fontWeight: FontWeight.w500, fontSize: SizeConfig.pinPutTextSize),
//           decoration: BoxDecoration(
//             color: ColorManager.white,
//             border: Border.all(
//               color: ColorManager.primaryBlue,
//             ),
//             borderRadius: BorderRadius.circular(SizeConfig.height*0.015),
//           ),
//         ),
//         submittedPinTheme: submittedPinTheme.copyWith(
//           height: SizeConfig.height*0.062,
//           width: SizeConfig.height*0.07,
//           textStyle: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorManager.black,fontWeight: FontWeight.w500, fontSize: SizeConfig.pinPutTextSize),
//           decoration: BoxDecoration(
//             color: ColorManager.white,
//             border: Border.all(
//               color: ColorManager.primaryBlue,
//             ),
//             borderRadius: BorderRadius.circular(SizeConfig.height*0.015),
//           ),
//         ),
//         disabledPinTheme: defaultPinTheme.copyWith(
//           height: SizeConfig.height*0.062,
//           width: SizeConfig.height*0.07,
//           textStyle: Theme.of(context).textTheme.displaySmall!.copyWith(color:ColorManager.black,fontWeight: FontWeight.w500, fontSize: SizeConfig.pinPutTextSize),
//           decoration: BoxDecoration(
//             color: ColorManager.white,
//             border: Border.all(
//               color: ColorManager.gray,
//             ),
//             borderRadius: BorderRadius.circular(SizeConfig.height*0.015),
//           ),
//         ),
//         pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
//         keyboardAppearance: Brightness.light,
//         androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
//
//         showCursor: true,
//         readOnly: !enabled,
//         controller:otpController ,
//         autofocus: false,
//         enabled:enabled,
//         length: length,
//         keyboardType: TextInputType.number,
//         pinContentAlignment: Alignment.center,
//         listenForMultipleSmsOnAndroid: true,
//         closeKeyboardWhenCompleted: true,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         textInputAction: TextInputAction.done,
//         useNativeKeyboard: true,
//         pinAnimationType: PinAnimationType.scale,
//         enableSuggestions: false,
//         toolbarEnabled: false,
//         inputFormatters: [
//           FilteringTextInputFormatter.allow(RegExp("[٠-٩-0-9]"))
//         ],
//         onTap: (){},
//         onChanged:onChanged,
//         onSubmitted:onSubmit,
//       ),
//     );
//
//   }
//
//
//
// }