import 'package:attendience_app/core/helper/app_size_config.dart';
import 'package:attendience_app/core/shared_preference/shared_preference.dart';
import 'package:attendience_app/features/applogize/presentation/controller/applogize_cubit.dart';
import 'package:attendience_app/features/applogize/presentation/controller/applogize_states.dart';
import 'package:attendience_app/features/applogize/presentation/view/widgets/applogizes_view_body.dart';
import 'package:attendience_app/styles/assets/asset_manager.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ApplogizesScreen extends StatefulWidget {
  const ApplogizesScreen({super.key});

  @override
  State<ApplogizesScreen> createState() => _ApplogizesScreenState();
}

class _ApplogizesScreenState extends State<ApplogizesScreen> {

  @override
  void initState() {
    super.initState();
    ApplogizeCubit.get(context).getAllApplogize(organizationId: UserDataFromStorage.organizationIdFromStorage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApplogizeCubit,ApplogizeStates>(
        listener: (context, state) {

        },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is GetAllApplogizeLoadingState,
          progressIndicator: const CircularProgressIndicator(color: ColorManager.primaryBlue,),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(
                    color: Colors.white
                ),
                backgroundColor: ColorManager.primaryBlue,
                title: Text("طلبات الاستاذانات",style: TextStyles.textStyle18Bold,),
                centerTitle: true,
              ),
              body:  Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: AssetImage(AssetsManager.backgroundImage),
                  ),
                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(
                    horizontal: SizeConfig.height * 0.02,
                    vertical: SizeConfig.height * 0.02,
                  ),
                  child: ApplogizesViewBody(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
