import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:swiftlink/common/constants/local_storage_key.dart';
import 'package:swiftlink/models/entities/user.dart';
import 'package:swiftlink/models/user_contact.dart';
import 'package:swiftlink/screens/preference/preference.dart';
import 'package:swiftlink/screens/preference/preference_screen_binding.dart';
import 'package:swiftlink/services/base_firebase_services.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

class RegistrationScreenController extends GetxController {
  TextEditingController userName = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController location = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final kGoogleApiKey = "AIzaSyAOt_IitFgSXD5oc1o6RJntfr0ypZtOfzQ";
  int searchSkipCount = 0;
  RxString searchData = 'Search'.obs;
  GetStorage getStorage = GetStorage();
  User user = User();

  RegistrationScreenController({
    required this.user,
  });

  Future<void> checkEmailAvailable() async {
    bool? isAvailable = await BaseFirebaseServices.checkIfUserNameAvailable(userName: userName.text);
    if (isAvailable == true) {
      await createUser();
    }
  }

  Future<void> createUser() async {
    user.userName = userName.text;
    user.firstName = firstName.text;
    user.lastName = lastName.text;
    user.jwtToken = await FirebaseMessaging.instance.getToken() ?? '';
    user.systemId = getStorage.read(LocalStorageKey.systemId);
    User? getUser = await BaseFirebaseServices.createNewUser(user: user);
    if (getUser != null) {
      getStorage.write(LocalStorageKey.currentUser, getUser);
      getStorage.write(LocalStorageKey.currentUserUid, user.id);
      getStorage.write(LocalStorageKey.currentUserUsereName, userName.text);
      UserContact? userContact = await BaseFirebaseServices.userContact(
        userContact: UserContact(
          optAddressOne: location.text,
          systemId: getStorage.read(LocalStorageKey.systemId),
          userName: userName.text,
        ),
        userId: user.id!,
      );
      if (userContact != null) {
        getStorage.write(LocalStorageKey.isLogging, true);
        Get.to(
          () => const PreferenceScreen(),
          binding: PreferenceScreenBindings(
            user: user,
          ),
        );
      }
    }
  }

  Future<void> handleSearchButton(context) async {
    Mode _mode = Mode.overlay;
    try {
      Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: "en",
        types: [],
        components: [],
        strictbounds: false,
      );
      displayPrediction(p);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    Get.snackbar('Error', response.errorMessage.toString());
  }

  Future displayPrediction(Prediction? p) async {
    if (p != null) {
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse details = await _places.getDetailsByPlaceId(p.placeId ?? '000');
      location.text = details.result.name.toString();
    } else {
      searchData.value = 'Search';
    }
  }
}
