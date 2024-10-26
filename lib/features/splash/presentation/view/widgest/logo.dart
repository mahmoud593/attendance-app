import 'package:attendience_app/styles/assets/asset_manager.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return  Image.asset(
      AssetsManager.logo,
      color: Colors.white,
      height: MediaQuery.of(context).size.height*.2,
    );
  }
}
