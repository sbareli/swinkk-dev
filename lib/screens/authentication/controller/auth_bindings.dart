import 'package:get/get.dart';
import 'package:swiftlink/screens/authentication/controller/auth_controller.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
