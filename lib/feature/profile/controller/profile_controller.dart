import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:streetary/routes/app_routes.dart';

class ProfileController extends GetxController
{
  ProfileController(){
    checkLoginStatus();
  }
  RxBool isLoggedin = false.obs;

  checkLoginStatus() async
  {
    User? user =  await FirebaseAuth.instance.currentUser;
    if(user!=null)
    {
      isLoggedin.value = true;
      update();
    }else{
      isLoggedin.value = false;
      update();
    }
  }

  signOut() async
  {
    await FirebaseAuth.instance.signOut();
    Get.offAndToNamed(Routes.HOME);
  }
}