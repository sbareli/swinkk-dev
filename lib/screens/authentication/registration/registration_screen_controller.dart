import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:swiftlink/common/constants/local_storage_key.dart';
import 'package:swiftlink/models/user_model.dart';
import 'package:swiftlink/models/user_contact.dart';
import 'package:swiftlink/screens/no_permissions/location_permission_screen.dart';
import 'package:swiftlink/screens/preference/preference.dart';
import 'package:swiftlink/screens/preference/preference_screen_binding.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:swiftlink/services/firebase_helper.dart';
import 'package:swiftlink/services/locale_service.dart';

class RegistrationScreenController extends GetxController {
  TextEditingController userName = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController postalCode = TextEditingController();
  TextEditingController administrativeAreaLevel1 = TextEditingController();
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
    bool isAvailable = await FireStoreUtils.checkIfUserNameAvailable(userName: userName.text.trim());
    if (isAvailable == true) {
      if (location.text == '') {
        Position? currentLocaiton = await LocaleService().currentPosition();
        if (currentLocaiton != null) {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            currentLocaiton.latitude,
            currentLocaiton.longitude,
          );
          location.text = placemarks[0].locality.toString();
          country.text = placemarks[0].country.toString();
          postalCode.text = placemarks[0].postalCode.toString();
          administrativeAreaLevel1.text = placemarks[0].administrativeArea.toString();
        } else {
          Get.to(
            () => const NoLocationScreen(),
          );
        }
      }
      await createUser();
    }
  }

  Future<void> createUser() async {
    user.userName = userName.text.trim();
    user.firstName = firstName.text.trim();
    user.lastName = lastName.text.trim();
    user.jwtToken = await FirebaseMessaging.instance.getToken() ?? '';
    user.systemId = getStorage.read(LocalStorageKey.systemId);
    User? getUser = await FireStoreUtils.createNewAccount(user: user);
    if (getUser != null) {
      getStorage.write(LocalStorageKey.currentUser, getUser);
      getStorage.write(LocalStorageKey.currentUserUid, user.id);
      getStorage.write(LocalStorageKey.currentUserUsereName, userName.text);
      UserContact? userContact = await FireStoreUtils.addUserContact(
        userContact: UserContact(
          optAddressOne: location.text.trim(),
          administrativeAreaLevel1: administrativeAreaLevel1.text.trim(),
          postalCode: postalCode.text.trim(),
          country: country.text.trim(),
          systemId: getStorage.read(LocalStorageKey.systemId),
          userName: userName.text.trim(),
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
    FireStoreUtils.showError(title: 'Error', errorMessage: response.errorMessage.toString());
  }

  Future displayPrediction(Prediction? p) async {
    if (p != null) {
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse details = await _places.getDetailsByPlaceId(p.placeId ?? '000');
      location.text = details.result.name.toString();
      for (var element in details.result.addressComponents) {
        if (element.types.contains('country')) {
          country.text = element.longName;
        } else if (element.types.contains('postal_code')) {
          postalCode.text = element.longName;
        } else if (element.types.contains('administrative_area_level_1')) {
          administrativeAreaLevel1.text = element.longName;
        }
      }
    } else {
      searchData.value = 'Search';
    }
  }
}
