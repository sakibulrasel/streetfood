import 'package:get/get.dart';
import 'package:streetary/feature/profile/controller/profile_controller.dart';
class ProfileBinding extends Bindings
{
  @override
  void dependencies() {
    Get.put(ProfileController());
    // TODO: implement dependencies
  }

}

