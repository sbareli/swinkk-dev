import 'package:get/get.dart';
import 'package:swiftlink/models/user_model.dart';
import 'package:swiftlink/screens/authentication/otp_verify/otp_verify_screen_controller.dart';

class OtpVerifyScreenBinding implements Bindings {
  OtpVerifyScreenBinding({required this.user});

  User user = User();
  @override
  void dependencies() {
    Get.lazyPut<OtpVerifyScreenController>(() => OtpVerifyScreenController(
          user: user,
        ));
  }
}
