import 'package:get/get.dart';
import 'package:swiftlink/screens/authentication/sign_in/sign_in_screen_controller.dart';

class SignInScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInScreenController>(() => SignInScreenController());
  }
}
