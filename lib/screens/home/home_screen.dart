import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiftlink/models/index.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserModel>(context).user;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('this is home screen'),
            Text('Username: ${user!.username}'),
            Text('Firstname: ${user.firstName}'),
            Text('Lastname: ${user.lastName}'),
            Text('Email: ${user.email}'),
          ],
        ),
      ),  
    );
  }
}
