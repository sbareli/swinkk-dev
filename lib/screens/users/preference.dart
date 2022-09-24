import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:swiftlink/common/theme/theme.dart';
import 'package:swiftlink/generated/l10n.dart';
import 'package:swiftlink/screens/home/home_screen.dart';
import 'package:swiftlink/services/services.dart';

class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({Key? key}) : super(key: key);

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  // String email = '';
  // String password = '';
  var rows = 3, columns = 9;
  Future<QuerySnapshot>? servicesList;
  var selectedServices = [];

  @override
  void initState() {
    super.initState();
    // servicesList = Services().firebase.getServices();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: servicesList,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/preference.png'), fit: BoxFit.cover),
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        S.of(context).tellUsWhatYoureInto,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      // const SizedBox(height: 300),
                      SizedBox(
                        height: 300,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: HexagonOffsetGrid.oddPointy(
                            // color: Colors.black54,
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                            columns: columns,
                            rows: rows,
                            buildTile: (col, row) {
                              bool validRange;
                              if ((snapshot.data?.docs.length ?? 0) > row + col * rows) {
                                validRange = true;
                              } else {
                                validRange = false;
                              }
                              return HexagonWidgetBuilder(
                                elevation: validRange
                                    ? selectedServices.contains(snapshot.data!.docs[row + col]['service_category'])
                                        ? 0
                                        : 5
                                    : 5,
                                padding: 3.0,
                                cornerRadius: 8.0,
                                color: validRange
                                    ? selectedServices.contains(snapshot.data!.docs[row + col]['service_category'])
                                        ? Colors.green.shade200
                                        : Colors.pinkAccent.shade100
                                    : Constants.grey08, //col.isOdd || row.isOdd ? Colors.lightBlue.shade200 : Colors.grey.shade300,
                                child: InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: validRange ? Text(snapshot.data!.docs[row + col]['service_category']) : Text('NA'),
                                  ),
                                  onTap: () {
                                    if (validRange) {
                                      var selectedValue = snapshot.data!.docs[row + col]['service_category'];
                                      if (selectedServices.contains(selectedValue)) {
                                        selectedServices.remove(selectedValue);
                                      } else {
                                        selectedServices.add(selectedValue);
                                      }
                                      print('tapped');
                                      setState(() {});
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Services().firebase.saveUserPreferences(selectedServices);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ));
                        },
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: Text(S.of(context).next),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Text.rich(
                        TextSpan(
                          text: S.of(context).skip,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
