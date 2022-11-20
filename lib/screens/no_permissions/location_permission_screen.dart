import 'package:flutter/material.dart';
import 'package:swiftlink/common/utils/colors.dart';
import 'package:swiftlink/common/utils/static_decoration.dart';
import 'package:permission_handler/permission_handler.dart';

class NoLocationScreen extends StatefulWidget {
  const NoLocationScreen({Key? key}) : super(key: key);

  @override
  State<NoLocationScreen> createState() => _NoLocationScreenState();
}

class _NoLocationScreenState extends State<NoLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Action Required '),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.location_on_outlined,
            size: 50,
          ),
          height16,
          const Text(
            'Allow your location',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          height15,
          const Text(
            'We will need your location to give you better experience.',
            textAlign: TextAlign.center,
          ),
          height15,
          ElevatedButton(
            onPressed: () async {
              await openAppSettings();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.blue,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Go to Settings',
                style: TextStyle(
                  color: whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
