import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeController extends GetxController
{
  HomeController()
  {
    checkUserGps();
    checkLoginStatus();
  }
  var tabIndex = 0;
    RxBool isLoggedin = false.obs;
  late LocationPermission permission;
    checkLoginStatus() async
    {
      User? user =  await FirebaseAuth.instance.currentUser;
      if(user!=null)
      {
        isLoggedin.value = true;
      }else{
        isLoggedin.value = false;
      }
    }

  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }

  checkUserGps() async
  {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

  }
}