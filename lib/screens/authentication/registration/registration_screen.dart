import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swiftlink/common/constants/app_asset.dart';
import 'package:swiftlink/screens/authentication/registration/registration_screen_controller.dart';

class RegistrationScreen extends GetView<RegistrationScreenController> {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/register_four.png'), fit: BoxFit.cover),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Personal Details',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: controller.userName,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'User Name',
                        isDense: true,
                        prefixIcon: Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: Image.asset(
                            AppAsset.person,
                            scale: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: controller.firstName,
                      decoration: InputDecoration(
                        hintText: 'First Name',
                        isDense: true,
                        prefixIcon: Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: Image.asset(
                            AppAsset.person,
                            scale: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: controller.lastName,
                      decoration: InputDecoration(
                        hintText: 'Last Name',
                        isDense: true,
                        prefixIcon: Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: Image.asset(
                            AppAsset.person,
                            scale: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: controller.location,
                      decoration: InputDecoration(
                        hintText: 'Home Location',
                        isDense: true,
                        prefixIcon: Align(
                          widthFactor: 1,
                          heightFactor: 1,
                          child: Image.asset(
                            AppAsset.loationIcon,
                            scale: 1.5,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            await controller.handleSearchButton(context);
                          },
                          child: Image.asset(
                            AppAsset.locationChoose,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TextButton(
                      onPressed: () {
                        if (controller.formKey.currentState!.validate()) {
                          controller.checkEmailAvailable();
                        }
                      },
                      style: TextButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text('Continue'),
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
  }
}
