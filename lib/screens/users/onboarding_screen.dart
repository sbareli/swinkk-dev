import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:swiftlink/common/utils/logs.dart';
import 'package:swiftlink/generated/l10n.dart';
import 'package:swiftlink/models/index.dart';
import 'package:swiftlink/modules/firebase/firebase_service.dart';
import 'package:swiftlink/screens/home/home_screen.dart';
import 'package:swiftlink/screens/users/preference.dart';

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
  @override
  void initState() {
    super.initState();
    user = FirebaseServices().userExistInDB();
  }

  @override
  void dispose() {
    username.dispose();
    firstname.dispose();
    lastname.dispose();
    location.dispose();
    super.dispose();
  }

  _locationDialog() {
    return Dialog(
      child: TypeAheadField<dynamic>(
        // debounceDuration: Duration(seconds: 5),
        textFieldConfiguration: const TextFieldConfiguration(autofocus: true, decoration: InputDecoration(border: OutlineInputBorder())),
        suggestionsCallback: (pattern) async {
          var res = await httpGet(Uri.parse('https://maps.googleapis.com/maps/api/place/textsearch/json?query=$pattern&key=AIzaSyAiwXSWUZ0x_St3L0fYUVFQp23G-khElWU'));
          var body = jsonDecode(res.body);
          return body['results'];
        },
        loadingBuilder: (context) => Text('Loading...'),
        itemBuilder: (context, suggestion) {
          printLog('called');
          return ListTile(
            // leading: Icon(Icons.shopping_cart),
            title: Text(suggestion['formatted_address']),
            // subtitle: Text('\$${suggestion['price']}'),
          );
        },
        onSuggestionSelected: (suggestion) {
          location.text = suggestion['formatted_address'];
          Navigator.of(context).pop();
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductPage(product: suggestion)));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    gotoHomeScreen(user) {
      Provider.of<UserModel>(context, listen: false).saveUser(User.fromJson(user));
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
                              TextField(
                                controller: username,
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
                                        await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return _locationDialog();
                                          },
                                        );
                                        setState(() {});
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
                                  var user = User(
                                    username: username.text.trim(),
                                    firstName: firstname.text.trim(),
                                    lastName: lastname.text.trim(),
                                    location: location.text.trim(),
                                  );
                                  FirebaseServices().saveUserToFirestore(user: user);
                                  Provider.of<UserModel>(context, listen: false).saveUser(user);
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const PreferenceScreen(),
                                  ));
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
                );
        });
  }
}
