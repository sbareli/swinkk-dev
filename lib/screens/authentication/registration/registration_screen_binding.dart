import 'package:get/get.dart';
import 'package:swiftlink/models/user_model.dart';
import 'package:swiftlink/screens/authentication/registration/registration_screen_controller.dart';

class RegistrationScreenBinding implements Bindings {
  User user;
  RegistrationScreenBinding({required this.user});
  @override
  void dependencies() {
    Get.lazyPut<RegistrationScreenController>(
      () => RegistrationScreenController(
        user: user,
      ),
    );
  }
}
