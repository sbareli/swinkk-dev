import 'package:get/get.dart';
import 'package:swiftlink/models/entities/index.dart';
import 'package:swiftlink/screens/preference/preference_screen_controller.dart';

class PreferenceScreenBindings implements Bindings {
  User user = User();
  PreferenceScreenBindings({
    required this.user,
  });
  @override
  void dependencies() {
    Get.lazyPut<PreferenceScreenController>(() => PreferenceScreenController(
          user: user,
        ));
  }
}
