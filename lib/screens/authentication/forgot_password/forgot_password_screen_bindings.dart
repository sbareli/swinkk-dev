import 'package:get/get.dart';
import 'package:swiftlink/screens/authentication/forgot_password/forgot_password_screen_controller.dart';

class ForgotPasswordScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordScreenController>(() => ForgotPasswordScreenController());
  }
}
