import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:swiftlink/common/theme/theme.dart';
import 'package:swiftlink/common/utils/string_extensions.dart';

import 'app_init.dart';
import 'common/constants.dart';
import 'common/utils/logs.dart';
import 'generated/l10n.dart';
import 'generated/languages/index.dart';
import 'models/index.dart';
import 'routes/route.dart';

class App extends StatefulWidget {
  final String languageCode;

  const App({
    Key? key,
    required this.languageCode,
  }) : super(key: key);

  static final GlobalKey<NavigatorState> fluxStoreNavigatorKey = GlobalKey();

  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> with WidgetsBindingObserver implements UserModelDelegate //,NotificationDelegate
{
  AppModel? _app;
  final _user = UserModel();
  // bool isFirstSeen = false;
  bool isLoggedIn = false;

  void appInitialModules() {
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        _user.delegate = this;
      },
    );
  }

  @override
  void initState() {
    printLog('[AppState] initState');
    _app = AppModel(widget.languageCode);
    WidgetsBinding.instance.addObserver(this);

    appInitialModules();

    super.initState();
  }

  @override
  Future<void> onLoaded(User? user) async {}

  @override
  Future<void> onLoggedIn(User user) async => onLoaded(user);

  @override
  Future<void> onLogout(User? user) async {}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {}
  }

  @override
  Widget build(BuildContext context) {
    printLog('[AppState] Build app.dart');
    return ChangeNotifierProvider<AppModel>.value(
      value: _app!,
      child: Consumer<AppModel>(
        builder: (context, value, child) {
          var languageCode = value.langCode!.isEmptyOrNull ? kAdvanceConfig['DefaultLanguage'] : value.langCode;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider<UserModel>.value(value: _user),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                locale: Locale(languageCode!, ''),
                navigatorKey: App.fluxStoreNavigatorKey,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  DefaultCupertinoLocalizations.delegate,
                  LocalWidgetLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                home: const Scaffold(
                  body: AppInit(),
                ),
                routes: Routes.getAll(),
                onGenerateRoute: Routes.getRouteGenerate,
                theme: Constants.lightTheme,
                darkTheme: Constants.darkTheme,
                // themeMode: value.themeMode,
              ),
            ),
          );
        },
      ),
    );
  }
}
