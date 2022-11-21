import 'package:get/get.dart';
import 'package:swiftlink/screens/authentication/sign_up/sign_up_screen_controller.dart';

class SignUpScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpScreenController>(() => SignUpScreenController());
  }
}
