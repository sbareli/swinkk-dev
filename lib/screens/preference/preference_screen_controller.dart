import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:swiftlink/common/constants/local_storage_key.dart';
import 'package:swiftlink/models/entities/index.dart';
import 'package:swiftlink/models/service.dart';
import 'package:swiftlink/models/user_prefrence.dart';
import 'package:swiftlink/screens/home/home_screen.dart';
import 'package:swiftlink/services/base_firebase_services.dart';

class PreferenceScreenController extends GetxController {
  RxList<ServiceModel> servicesList = <ServiceModel>[].obs;
  RxList<String> selectedServices = <String>[].obs;
  User user = User();
  GetStorage getsStorage = GetStorage();
  PreferenceScreenController({
    required this.user,
  });

  @override
  void onInit() {
    getServiceList();
    super.onInit();
  }

  void getServiceList() async {
    servicesList.value = await BaseFirebaseServices.getService();
    update();
  }

  void selectService(bool isValidRange, int index) {
    if (isValidRange) {
      if (selectedServices.contains(servicesList[index].serviceCategory)) {
        selectedServices.remove(servicesList[index].serviceCategory);
      } else {
        selectedServices.add(servicesList[index].serviceCategory!);
      }
    }
    update();
  }

  Future<void> saveServiceCategory() async {
    UserPrefrence storeData = UserPrefrence(
      serviceCategory: selectedServices,
      systemId: getsStorage.read(LocalStorageKey.systemId),
      userName: user.userName,
    );
    UserPrefrence? userPrefrence = await BaseFirebaseServices.setServiceList(storeData, user.id!);
    if (userPrefrence != null) {
      Get.off(() => const HomeScreen());
    }
  }
}
