import 'package:attendience_app/biometric_screen.dart';
import 'package:attendience_app/core/shared_preference/shared_preference.dart';
import 'package:attendience_app/face_regocantion.dart';
import 'package:attendience_app/features/applogize/presentation/controller/applogize_cubit.dart';
import 'package:attendience_app/features/auth/presentaion/controller/auth_cubit.dart';
import 'package:attendience_app/features/auth/presentaion/controller/auth_states.dart';
import 'package:attendience_app/features/home/presentation/controller/home_cubit.dart';
import 'package:attendience_app/features/notification/controller/notification_cubit.dart';
import 'package:attendience_app/features/splash/presentation/view/splash_screen.dart';
import 'package:attendience_app/firebase_options.dart';
import 'package:attendience_app/styles/theme_manger/theme_manager.dart';
import 'package:face_camera/face_camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await UserDataFromStorage.getData();
  await SharedPreferences.getInstance();
  await FaceCamera.initialize(); //Add this

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()..getMacAddress()),
        BlocProvider(create: (context) => ApplogizeCubit()),
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(create: (context) => NotificationCubit()),
      ],
      child: BlocConsumer<AuthCubit,AuthStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: getApplicationTheme(context),
            home:  const Directionality(
                textDirection: TextDirection.rtl,
                child: SplashScreen()
            ),
          );
        },
      ),
    );
  }
}


