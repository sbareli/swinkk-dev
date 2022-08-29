import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:provider/provider.dart';
import 'package:swiftlink/generated/l10n.dart';
import 'package:swiftlink/models/index.dart';
import 'package:swiftlink/modules/firebase/firebase_service.dart';
import 'package:swiftlink/screens/home/home_screen.dart';
import 'package:swiftlink/screens/users/preference.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

class OnboardingScreenFirst extends StatefulWidget {
  const OnboardingScreenFirst({Key? key}) : super(key: key);

  @override
  _OnboardingScreenFirstState createState() => _OnboardingScreenFirstState();
}

class _OnboardingScreenFirstState extends State<OnboardingScreenFirst> {
  late Future<DocumentSnapshot> user;

  final username = TextEditingController();
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final location = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final kGoogleApiKey = "AIzaSyAwjEoNexuKC40Y7oLdoq9pSJ88hGiGhrQ";
  int searchSkipCount = 0;
  String searchData = 'Search';
  @override
  void initState() {
    super.initState();
    user = FirebaseServices().userExistInDB();
    // checkLocationPermissions();
  }

  @override
  void dispose() {
    username.dispose();
    firstname.dispose();
    lastname.dispose();
    location.dispose();
    super.dispose();
  }

  Future<void> handleSearchButton(context) async {
    Mode _mode = Mode.overlay;
    try {
      Prediction? p = await PlacesAutocomplete.show(context: context, apiKey: kGoogleApiKey, onError: onError, mode: _mode, language: "en", types: [], components: [], strictbounds: false);
      displayPrediction(p);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    SnackBar snackBar = SnackBar(
      content: Text(response.errorMessage.toString()),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future displayPrediction(Prediction? p) async {
    if (p != null) {
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse details = await _places.getDetailsByPlaceId(p.placeId ?? '000');
      location.text = details.result.name.toString();
      setState(() {});
    } else {
      searchData = 'Search';
    }
  }

  // void checkLocationPermissions() async {
  //   try {
  //     if (await Geolocator.checkPermission() == LocationPermission.whileInUse || await Geolocator.checkPermission() == LocationPermission.always) {
  //       position();
  //     } else {
  //       var newPermission = await Geolocator.requestPermission();
  //       if (newPermission == LocationPermission.whileInUse || newPermission == LocationPermission.always) {
  //         setState(() {
  //           position();
  //         });
  //       } else {}
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  // void position() {
  //   Geolocator.getCurrentPosition().then((position) {
  //     setState(() {});
  //     if (!mounted) {
  //       return;
  //     }
  //   });
  // }

  // _locationDialog() {
  //   return Dialog(
  //     child: TypeAheadField<dynamic>(
  //       // debounceDuration: Duration(seconds: 5),
  //       textFieldConfiguration: const TextFieldConfiguration(autofocus: true, decoration: InputDecoration(border: OutlineInputBorder())),
  //       suggestionsCallback: (pattern) async {
  //         var res = await httpGet(Uri.parse('https://maps.googleapis.com/maps/api/place/textsearch/json?query=$pattern&key=AIzaSyAiwXSWUZ0x_St3L0fYUVFQp23G-khElWU'));
  //         var body = jsonDecode(res.body);
  //         return body['results'];
  //       },
  //       loadingBuilder: (context) => Text('Loading...'),
  //       itemBuilder: (context, suggestion) {
  //         printLog('called');
  //         return ListTile(
  //           // leading: Icon(Icons.shopping_cart),
  //           title: Text(suggestion['formatted_address']),
  //           // subtitle: Text('\$${suggestion['price']}'),
  //         );
  //       },
  //       onSuggestionSelected: (suggestion) {
  //         location.text = suggestion['formatted_address'];
  //         Navigator.of(context).pop();
  //         // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductPage(product: suggestion)));
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    gotoHomeScreen(user) {
      // Provider.of<UserModel>(context, listen: false).saveUser(User.fromJson(user));
      FirebaseServices().updateUserLastLogin();
      return const HomeScreen();
    }

    return FutureBuilder<DocumentSnapshot>(
        future: user,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return snapshot.data!.exists
              ? gotoHomeScreen(snapshot.data!.data())
              : Scaffold(
                  body: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(image: AssetImage('assets/images/Register4.png'), fit: BoxFit.cover),
                        ),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  S.of(context).personalDetails,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: username,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Username is required';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: S.of(context).username,
                                    isDense: true,
                                    prefixIcon: Align(
                                      widthFactor: 1.0,
                                      heightFactor: 1.0,
                                      child: Image.asset(
                                        'assets/images/personIcon.png',
                                        scale: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: firstname,
                                  decoration: InputDecoration(
                                    hintText: S.of(context).firstName,
                                    isDense: true,
                                    prefixIcon: Align(
                                      widthFactor: 1.0,
                                      heightFactor: 1.0,
                                      child: Image.asset(
                                        'assets/images/personIcon.png',
                                        scale: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: lastname,
                                  decoration: InputDecoration(
                                    hintText: S.of(context).lastName,
                                    isDense: true,
                                    prefixIcon: Align(
                                      widthFactor: 1.0,
                                      heightFactor: 1.0,
                                      child: Image.asset(
                                        'assets/images/personIcon.png',
                                        scale: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: location,
                                  decoration: InputDecoration(
                                      hintText: S.of(context).homeLocation,
                                      isDense: true,
                                      prefixIcon: Align(
                                        widthFactor: 1,
                                        heightFactor: 1,
                                        child: Image.asset(
                                          'assets/images/locationIcon.png',
                                          scale: 1.5,
                                        ),
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: () async {
                                          await handleSearchButton(context);
                                          // await showDialog(
                                          //   context: context,
                                          //   builder: (context) {
                                          //     return _locationDialog();
                                          //   },
                                          // );
                                        },
                                        child: Image.asset(
                                          'assets/images/locationChooseIcon.png',
                                        ),
                                      )),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (formKey.currentState?.validate() == true) {
                                      var user = User(
                                        username: username.text.trim(),
                                        firstName: firstname.text.trim(),
                                        lastName: lastname.text.trim(),
                                        location: location.text.trim(),
                                      );
                                      FirebaseServices().saveUserToFirestore(user: user);
                                      // Provider.of<UserModel>(context, listen: false).saveUser(user);
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => const PreferenceScreen(),
                                      ));
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50),
                                  ),
                                  child: Text(S.of(context).continueText),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
        });
  }
}
