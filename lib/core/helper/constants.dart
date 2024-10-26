import 'package:attendience_app/features/home/data/models/drawer_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Constants{

  static final database = FirebaseDatabase.instance
      .refFromURL('https://attendance-app-32fc0-default-rtdb.firebaseio.com/');

  static List<DrawerModel> drawerData = [
    DrawerModel(
      title: 'المعلومات الشخصيه',
      icon: Icons.person,
    ),
    DrawerModel(
        title: 'الاشعارات العامه',
        icon: Icons.notifications_active,
    ),
    DrawerModel(
      title: 'اشعارات الحضور و الانصراف',
      icon: Icons.edit_notifications,
    ),
    DrawerModel(
      title: 'طلبات الاستاذان',
      icon: Icons.pan_tool_sharp,
    ),
    DrawerModel(
      title: 'انشاء استاذان',
      icon: Icons.border_color_outlined,
    ),
    DrawerModel(
      title: 'تسجيل الخروج',
      icon: Icons.logout,
    ),

  ];


}