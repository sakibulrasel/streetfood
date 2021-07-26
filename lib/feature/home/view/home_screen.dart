import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streetary/core/widget/bottom_navigation.dart';
import 'package:streetary/feature/home/controller/home_controller.dart';
import 'package:streetary/feature/hotspot/view/hotspot_view.dart';
import 'package:streetary/feature/kuzines/view/kuzines_screen.dart';
import 'package:streetary/feature/profile/view/profile_view.dart';
import 'package:streetary/feature/vendors/view/vendors_view.dart';
import 'package:streetary/feature/streateries/view/streateries_screen.dart';
import 'package:streetary/routes/app_routes.dart';
class HomeScreen extends StatelessWidget {

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        builder: (controller){
      return Scaffold(

          body: SafeArea(
            child: IndexedStack(
              index: controller.tabIndex,
              children: [
                StreateriesScreen(),
                VendorsScreen(),
                KuzinesScreen(),
                ProfileScreen(),
              ],
            ),

          ),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.black,
            selectedItemColor: Colors.redAccent,
            selectedLabelStyle: TextStyle(
              color: Colors.black
            ),
            onTap: controller.changeTabIndex,
            currentIndex: controller.tabIndex,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            items: [
              getBottomNavigation(
                icon: CupertinoIcons.compass,
                label: 'StrEateries',
              ),

              getBottomNavigation(
                icon: CupertinoIcons.rectangle_stack_person_crop,
                label: 'Vendors',
              ),
              getBottomNavigation(
                icon: CupertinoIcons.personalhotspot,
                label: 'KuZines',
              ),
              getBottomNavigation(
                icon: CupertinoIcons.profile_circled,
                label: 'Profile',
              ),
            ],
          )
      );
    });
  }
}
