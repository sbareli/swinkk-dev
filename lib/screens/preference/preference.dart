import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexagon/hexagon.dart';
import 'package:swiftlink/common/theme/theme.dart';
import 'package:swiftlink/common/utils/colors.dart';
import 'package:swiftlink/screens/preference/preference_screen_controller.dart';

class PreferenceScreen extends GetView<PreferenceScreenController> {
  const PreferenceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  "Tell us what you’re into",
                  style: Theme.of(context).textTheme.headline6,
                ),
                // const SizedBox(height: 300),
                SizedBox(
                  height: 300,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: GetBuilder<PreferenceScreenController>(
                      builder: (_) => HexagonOffsetGrid.oddPointy(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                        columns: (controller.servicesList.length / 3).round() + 3,
                        rows: 3,
                        buildTile: (col, row) {
                          bool validRange;
                          if ((controller.servicesList.length) > row + col * 3) {
                            validRange = true;
                          } else {
                            validRange = false;
                          }
                          return HexagonWidgetBuilder(
                            elevation: validRange
                                ? controller.selectedServices.contains(controller.servicesList[row + col].serviceCategory)
                                    ? 0
                                    : 5
                                : 5,
                            padding: 3.0,
                            cornerRadius: 8.0,
                            color: validRange
                                ? controller.selectedServices.contains(controller.servicesList[row + col].serviceCategory)
                                    ? Colors.green.shade200
                                    : backgroundGrey
                                : Constants.grey08,
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: validRange
                                    ? Obx(
                                        () => Text(
                                          controller.servicesList[row + col].serviceCategory!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: controller.selectedServices.contains(controller.servicesList[row + col].serviceCategory) ? textBlack : textGrey,
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        'NA',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: textGrey,
                                        ),
                                      ),
                              ),
                              onTap: () {
                                controller.selectService(validRange, row + col);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: TextButton(
                    onPressed: () {
                      controller.saveServiceCategory();
                    },
                    style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('Next'),
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                const Text.rich(
                  TextSpan(
                    text: 'skip',
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
