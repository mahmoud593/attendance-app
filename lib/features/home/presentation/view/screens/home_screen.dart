import 'package:attendience_app/core/helper/material_navigation.dart';
import 'package:attendience_app/core/shared_preference/shared_preference.dart';
import 'package:attendience_app/features/applogize/presentation/view/add_applogize_screen.dart';
import 'package:attendience_app/features/auth/data/auth_repo_implement/auth_repo_implement.dart';
import 'package:attendience_app/features/auth/presentaion/controller/auth_cubit.dart';
import 'package:attendience_app/features/home/presentation/controller/home_cubit.dart';
import 'package:attendience_app/features/home/presentation/controller/home_states.dart';
import 'package:attendience_app/features/home/presentation/view/widgets/darwer_widget.dart';
import 'package:attendience_app/features/home/presentation/view/widgets/face_regocantion_widget.dart';
import 'package:attendience_app/features/home/presentation/view/widgets/fingure_print_widget.dart';
import 'package:attendience_app/features/home/presentation/view/widgets/micro_record_widget.dart';
import 'package:attendience_app/features/home/presentation/view/widgets/record_view.dart';
import 'package:attendience_app/features/home/presentation/view/widgets/scan_qr_code_widget.dart';
import 'package:attendience_app/features/scan_qr_code/presentation/view/scan_qr_code_body.dart';
import 'package:attendience_app/styles/assets/asset_manager.dart';
import 'package:attendience_app/styles/colors/color_manager.dart';
import 'package:attendience_app/styles/size_config/app_size_config.dart';
import 'package:attendience_app/styles/text_styles/text_styles.dart';
import 'package:attendience_app/styles/widets/toast.dart';
import 'package:attendience_app/test_camera.dart';
import 'package:geodesy/geodesy.dart';
import 'package:attendience_app/styles/widets/default_button.dart';
import 'package:attendience_app/styles/widets/toastification_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:toastification/toastification.dart';
import '../widgets/app_bar_home_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  Location location = Location();

  LocationData ?locationData;

  bool isLocation=true;
  Future<void> getMyLocation() async {
    setState(() {
      isLocation=false;
    });
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Check for permissions
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Get the current location
    try{
      locationData = await location.getLocation();

    }catch(e){
      print(e.toString());
    }

    setState(() {
      isLocation=true;
    });
    print('Latitude: ${locationData!.latitude}');
    print('Longitude: ${locationData!.longitude}');
  }

  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  bool showPlayer = false;
  String? audioPath;

  @override
  void initState() {
    showPlayer = false;
    super.initState();

    AuthCubit.get(context).getHomeMember(memberId:UserDataFromStorage.adminUidFromStorage,macAddress: UserDataFromStorage.mainGroupFromStorage);

    HomeCubit.get(context).getFigureOrganizationSettings();

    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
          ? _SupportState.supported
          : _SupportState.unsupported),
    );
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'بصمه الاصبع',
        options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true
        ),
      );
      setState(() {
        print('done');
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        print('close');
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
            () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');

    print('User is _authorized: $_authorized');




  }

  bool isWithin100Meters({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2
  }) {
    Geodesy geodesy = Geodesy();

    LatLng location1 = LatLng(lat1, lon1); // First location
    LatLng location2 = LatLng(lat2, lon2); // Second location

    // Calculate distance in meters
    num distanceInMeters = geodesy.distanceBetweenTwoGeoPoints(location1, location2);

    print('Distance: $distanceInMeters meters');

    // Return true if the distance is within 100 meters
    return distanceInMeters <= 2000;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit,HomeStates>(
        builder: (context, state) {
          var cubit=HomeCubit.get(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: appBarHomeScreen(context: context),
              backgroundColor: ColorManager.primaryBlue,
              drawer:drawerWidget(context: context),
              body: ModalProgressHUD(
                inAsyncCall: isLocation==false ,
                progressIndicator: const CircularProgressIndicator(color: ColorManager.primaryBlue,),
                child: Container(
                  decoration: const BoxDecoration(
                    color: ColorManager.primaryBlue,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * .03,
                      ),

                      Expanded(
                        child: Container(
                          width: SizeConfig.width,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: AssetImage(AssetsManager.backgroundImage),
                            ),
                            color: ColorManager.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(SizeConfig.height * .07),
                              topRight: Radius.circular(SizeConfig.height * .07),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [

                                  cubit.isEducational==true?
                                  SizedBox( height: MediaQuery.sizeOf(context).height * .02, ):
                                  Container(),

                                  cubit.isEducational==true && UserDataFromStorage.attendenceAdminFromStorage==true?
                                  GestureDetector(
                                      onTap: (){
                                        getMyLocation().then((v){

                                          bool inLocation =  isWithin100Meters(
                                            lat1: cubit.fingureSettingsModel!.location![0],
                                            lon1: cubit.fingureSettingsModel!.location![1],
                                            lat2: locationData!.latitude!,
                                            lon2: locationData!.longitude!,
                                          );

                                          if(inLocation){
                                            customPushNavigator(context, const ScanQrCodeBody());
                                          }
                                          else{
                                            toastificationWidget(
                                                context: context,
                                                title: 'خارج نطاق المنشاه',
                                                body: 'الموقع الخاص بيك غير مطابق لموقع المنشاه',
                                                type: ToastificationType.error
                                            );
                                          }


                                        });
                                        // customPushNavigator(context, ScanQrCodeBody());
                                      },
                                      child: const ScanQrCodeWidget()
                                  ):Container(),

                                  SizedBox( height: MediaQuery.sizeOf(context).height * .02, ),

                                  GestureDetector(
                                      onTap: (){
                                        getMyLocation().then((v){

                                          bool inLocation =  isWithin100Meters(
                                             lat1: cubit.fingureSettingsModel!.location![0],
                                             lon1: cubit.fingureSettingsModel!.location![1],
                                             lat2: locationData!.latitude!,
                                             lon2: locationData!.longitude!,
                                           );

                                          if(inLocation){

                                            if(cubit.fingureSettingsModel!.isEducational==false){
                                              showDialog(context: context, builder: (builder)=>
                                                  AlertDialog(
                                                    title:Text(' مرحبا بك في نظام البصمه \n اختار نوع البصمه',style: TextStyles.textStyle18Bold.copyWith(
                                                        fontSize: 18,
                                                        color: ColorManager.primaryBlue
                                                    ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    content: Container(
                                                      height: MediaQuery.sizeOf(context).height * .17,
                                                      child:  Column(
                                                        children: [
                                                          SizedBox(height: SizeConfig.height * .02,),

                                                          DefaultButton(
                                                              buttonText: 'بصمه الحضور',
                                                              onPressed: ()async{
                                                                _authenticate().then((v)async{
                                                                  await cubit.checkUserAttendEarly();
                                                                  cubit.checkTimeToast(autherized: _authorized, context: context, flag: false);
                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                              buttonColor: ColorManager.primaryBlue,
                                                              large: false
                                                          ),

                                                          const SizedBox(height: 15,),

                                                          DefaultButton(
                                                              buttonText: 'بصمه الانصراف',
                                                              onPressed: ()async{
                                                                _authenticate().then((v)async{
                                                                  await cubit.checkUserAttendLate();
                                                                  cubit.checkTimeToast(autherized: _authorized, context: context, flag: true);
                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                              buttonColor: ColorManager.primaryBlue,
                                                              large: false
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ),);
                                            }
                                            else{

                                              showDialog(context: context, builder: (builder)=>
                                                  AlertDialog(
                                                    title:Text(' مرحبا بك في نظام البصمه \n اختار نوع البصمه',style: TextStyles.textStyle18Bold.copyWith(
                                                        fontSize: 18,
                                                        color: ColorManager.primaryBlue
                                                    ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    content: Container(
                                                      height: MediaQuery.sizeOf(context).height * .17,
                                                      child:  Column(
                                                        children: [
                                                          SizedBox(height: SizeConfig.height * .02,),

                                                          DefaultButton(
                                                              buttonText: 'بصمه الحضور',
                                                              onPressed: ()async{
                                                                _authenticate().then((v)async{
                                                                  await cubit.checkUserAttendEarly();
                                                                  cubit.checkTimeToast(autherized: _authorized, context: context, flag: false);
                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                              buttonColor: ColorManager.primaryBlue,
                                                              large: false
                                                          ),

                                                          const SizedBox(height: 15,),

                                                          DefaultButton(
                                                              buttonText: 'بصمه الانصراف',
                                                              onPressed: ()async{
                                                                _authenticate().then((v)async{
                                                                  await cubit.checkUserAttendLate();
                                                                  cubit.checkTimeToast(autherized: _authorized, context: context, flag: true);
                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                              buttonColor: ColorManager.primaryBlue,
                                                              large: false
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ),);
                                            }
                                          }else{
                                            toastificationWidget(
                                                context: context,
                                                title: 'خارج نطاق المنشاه',
                                                body: 'الموقع الخاص بيك غير مطابق لموقع المنشاه',
                                                type: ToastificationType.error
                                            );
                                          }


                                         });
                                        // customPushNavigator(context, ScanQrCodeBody());
                                      },
                                      child: const FingurePrintWidget()
                                  ),

                                  SizedBox( height: MediaQuery.sizeOf(context).height * .03, ),

                                  GestureDetector(
                                      onTap: (){
                                        getMyLocation().then((v){

                                          bool inLocation =  isWithin100Meters(
                                            lat1: cubit.fingureSettingsModel!.location![0],
                                            lon1: cubit.fingureSettingsModel!.location![1],
                                            lat2: locationData!.latitude!,
                                            lon2: locationData!.longitude!,
                                          );

                                          if(inLocation){

                                            if(cubit.fingureSettingsModel!.isEducational==false){
                                              showDialog(context: context, builder: (builder)=>
                                                  AlertDialog(
                                                    title:Text(' مرحبا بك في نظام البصمه \n اختار نوع البصمه',style: TextStyles.textStyle18Bold.copyWith(
                                                        fontSize: 18,
                                                        color: ColorManager.primaryBlue
                                                    ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    content: Container(
                                                      height: MediaQuery.sizeOf(context).height * .17,
                                                      child:  Column(
                                                        children: [
                                                          SizedBox(height: SizeConfig.height * .02,),

                                                          DefaultButton(
                                                              buttonText: 'بصمه الحضور',
                                                              onPressed: (){
                                                                 customPushNavigator(context, const CameraDedection(isFlag: false,));
                                                                 },
                                                              buttonColor: ColorManager.primaryBlue,
                                                              large: false
                                                          ),

                                                          const SizedBox(height: 15,),

                                                          DefaultButton(
                                                              buttonText: 'بصمه الانصراف',
                                                              onPressed: (){
                                                                customPushNavigator(context, const CameraDedection(isFlag: true,));
                                                              },
                                                              buttonColor: ColorManager.primaryBlue,
                                                              large: false
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ),);
                                            }
                                            else{

                                              showDialog(context: context, builder: (builder)=>
                                                  AlertDialog(
                                                    title:Text(' مرحبا بك في نظام البصمه \n اختار نوع البصمه',style: TextStyles.textStyle18Bold.copyWith(
                                                        fontSize: 18,
                                                        color: ColorManager.primaryBlue
                                                    ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    content: Container(
                                                      height: MediaQuery.sizeOf(context).height * .17,
                                                      child:  Column(
                                                        children: [
                                                          SizedBox(height: SizeConfig.height * .02,),

                                                          DefaultButton(
                                                              buttonText: 'بصمه الحضور',
                                                              onPressed: (){
                                                                customPushNavigator(context, const CameraDedection(isFlag: false,));
                                                              },
                                                              buttonColor: ColorManager.primaryBlue,
                                                              large: false
                                                          ),

                                                          const SizedBox(height: 15,),

                                                          DefaultButton(
                                                              buttonText: 'بصمه الانصراف',
                                                              onPressed: (){
                                                                customPushNavigator(context, const CameraDedection(isFlag: true,));
                                                              },
                                                              buttonColor: ColorManager.primaryBlue,
                                                              large: false
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ),);
                                            }
                                          }else{
                                            toastificationWidget(
                                                context: context,
                                                title: 'خارج نطاق المنشاه',
                                                body: 'الموقع الخاص بيك غير مطابق لموقع المنشاه',
                                                type: ToastificationType.error
                                            );
                                          }


                                        });

                                      },
                                      child: const FaceRegocantionWidget()
                                  ),

                                  SizedBox( height: MediaQuery.sizeOf(context).height * .03, ),

                                  GestureDetector(
                                      onTap: (){
                                        getMyLocation().then((v){

                                          bool inLocation =  isWithin100Meters(
                                            lat1: cubit.fingureSettingsModel!.location![0],
                                            lon1: cubit.fingureSettingsModel!.location![1],
                                            lat2: locationData!.latitude!,
                                            lon2: locationData!.longitude!,
                                          );

                                          if(inLocation){

                                            if(cubit.fingureSettingsModel!.isEducational==false){
                                              showDialog(context: context, builder: (builder)=>
                                                  AlertDialog(
                                                    title:Text(' مرحبا بك في نظام البصمه \n اختار نوع البصمه',style: TextStyles.textStyle18Bold.copyWith(
                                                        fontSize: 18,
                                                        color: ColorManager.primaryBlue
                                                    ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    content: Container(
                                                      height: MediaQuery.sizeOf(context).height * .17,
                                                      child:  Column(
                                                        children: [
                                                          SizedBox(height: SizeConfig.height * .02,),

                                                          DefaultButton(
                                                              buttonText: 'بصمه الحضور',
                                                              onPressed: (){
                                                                customPushNavigator(context, const RecordView(isFlag: false,));
                                                              },
                                                              buttonColor: ColorManager.primaryBlue,
                                                              large: false
                                                          ),

                                                          const SizedBox(height: 15,),

                                                          DefaultButton(
                                                              buttonText: 'بصمه الانصراف',
                                                              onPressed: (){
                                                                customPushNavigator(context, const RecordView(isFlag: true,));
                                                              },
                                                              buttonColor: ColorManager.primaryBlue,
                                                              large: false
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ),);
                                            }
                                            else{

                                              showDialog(context: context, builder: (builder)=>
                                                  AlertDialog(
                                                    title:Text(' مرحبا بك في نظام البصمه \n اختار نوع البصمه',style: TextStyles.textStyle18Bold.copyWith(
                                                        fontSize: 18,
                                                        color: ColorManager.primaryBlue
                                                    ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    content: Container(
                                                      height: MediaQuery.sizeOf(context).height * .17,
                                                      child:  Column(
                                                        children: [
                                                          SizedBox(height: SizeConfig.height * .02,),

                                                          DefaultButton(
                                                              buttonText: 'بصمه الحضور',
                                                              onPressed: (){
                                                                customPushNavigator(context, const RecordView(isFlag: false,));
                                                              },
                                                              buttonColor: ColorManager.primaryBlue,
                                                              large: false
                                                          ),

                                                          const SizedBox(height: 15,),

                                                          DefaultButton(
                                                              buttonText: 'بصمه الانصراف',
                                                              onPressed: (){
                                                                customPushNavigator(context, const RecordView(isFlag: true,));
                                                              },
                                                              buttonColor: ColorManager.primaryBlue,
                                                              large: false
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ),);

                                            }
                                          }else{
                                            toastificationWidget(
                                                context: context,
                                                title: 'خارج نطاق المنشاه',
                                                body: 'الموقع الخاص بيك غير مطابق لموقع المنشاه',
                                                type: ToastificationType.error
                                            );
                                          }


                                        });
                                      },
                                      child: const MicroRecordWidget()
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}