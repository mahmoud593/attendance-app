import 'package:attendience_app/core/helper/app_size_config.dart';
import 'package:attendience_app/features/applogize/presentation/controller/applogize_cubit.dart';
import 'package:attendience_app/features/applogize/presentation/controller/applogize_states.dart';
import 'package:attendience_app/features/applogize/presentation/view/widgets/add_applogize_view_body.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddApplogizeScreen extends StatelessWidget {
  const AddApplogizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
              color: Colors.white
          ),
          backgroundColor: ColorManager.primaryBlue,
          title: Text("انشاء استاذان",style: TextStyles.textStyle18Bold,),
          centerTitle: true,
        ),
        body:  BlocBuilder<ApplogizeCubit,ApplogizeStates>(
          builder: (context, state) {
            return ModalProgressHUD(
              inAsyncCall: state is ApplogizeLoadingState || state is UploadImageLoadingState,
              progressIndicator: const CupertinoActivityIndicator(),
              child: Padding(
                padding:  EdgeInsets.symmetric(
                  horizontal: SizeConfig.height * 0.02,
                  vertical: SizeConfig.height * 0.02,
                ),
                child: AddApplogizeViewBody(),
              ),
            );
          },
        )
      ),
    );
  }
}
