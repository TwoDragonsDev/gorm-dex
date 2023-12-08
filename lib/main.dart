import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screens/checkList.dart';
import 'screens/detail.dart';
import 'screens/gormitaList.dart';
import 'screens/powered_by.dart';
import 'screens/profile.dart';
import 'screens/search_bar_screen.dart';
import 'screens/series_list.dart';
import 'utility/colors.dart';

Future main() async {
  runApp(GetMaterialApp(
    initialRoute: '/PoweredBy',
    getPages: [
      GetPage(name: '/PoweredBy', page: () => PoweredBy()),
      GetPage(name: '/Series', page: () => const SeriesList()),
      GetPage(name: '/Popoli', page: () => const PopoliList()),
      GetPage(name: '/Profile', page: () => const Profile()),
      GetPage(name: '/CheckList', page: () => const CheckList()),
      GetPage(name: "/SearchBar", page: () => const SearchBarScreen()),
      GetPage(name: '/Detail', page: () => const Detail()),
    ],
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundColor,
    );
  }
}
