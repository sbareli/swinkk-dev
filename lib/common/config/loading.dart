part of '../config.dart';

/// For Loading Widget
Widget kLoadingWidget(context) {
  var size = 30.0;
  var color = Theme.of(context).primaryColor;
  return Center(
    child: SpinKitPouringHourGlassRefined(
      color: color,
      size: size,
    ),
  );
}
