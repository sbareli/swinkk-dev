import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swiftlink/modules/firebase/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<DocumentSnapshot>? user;
  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
      user = FirebaseServices().userExistInDB();
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
              ? Container(
                  height: 50,
                  width: 50,
                  color: Colors.red,
                )
              : Container(
                  height: 50,
                  width: 50,
                  color: Colors.yellow,
                );
        });
    // Scaffold(
    //   body: FutureBuilder<DocumentSnapshot>(
    //       future: user,
    //       builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //         if (snapshot.connectionState != ConnectionState.done) {
    //           return const Center(
    //             child: CircularProgressIndicator(),
    //           );
    //         }
    //         return snapshot.data!.exists
    //             ? Container(
    //                 height: 50,
    //                 width: 50,
    //                 color: Colors.red,
    //               )
    //             : Container(
    //                 height: 50,
    //                 width: 50,
    //                 color: Colors.red,
    //               );
    //       }),
    // );
    // Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       const Text('this is home screen'),
    //       Text('Username: ${user}'),
    //       // Text('Firstname: ${user.firstName}'),
    //       // Text('Lastname: ${user.lastName}'),
    //       // Text('Email: ${user.email}'),
    //     ],
    //   ),
    // ),
  }
}
