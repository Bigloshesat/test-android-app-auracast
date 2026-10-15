import 'package:base_flutter/resources/s_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:framework/utils/device_util.dart';
import 'package:framework/utils/router_manager.dart';
import 'package:framework/utils/screen_util.dart';
import 'package:provider/provider.dart';

import 'configs/app_config.dart';
import 'ui/art_shell.dart';
import 'controllers/extra/application_controller.dart';
import 'controllers/extra/bluetooth_controller.dart';
import 'controllers/extra/locale_controller.dart';
import 'controllers/extra/theme_controller.dart';
import 'generated/l10n.dart';

//flutter build apk --no-tree-shake-icons --no-sound-null-safety    (if flutter is 1.20 or 1.21)
//flutter run --no-sound-null-safety
//flutter run -d chrome --no-sound-null-safety
//flutter build web --no-tree-shake-icons --no-sound-null-safety
//python -m http.server 80

//D:\develop\flutter\github\flutter3.16\bin\flutter build apk --no-tree-shake-icons

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (DeviceUtil.isAndroid()) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ApplicationController()),
        ChangeNotifierProvider(create: (context) => BluetoothController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget contentView = MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeController()),
        ChangeNotifierProvider(create: (context) => LocaleController())
      ],
      child: Consumer2<ThemeController, LocaleController>(
          builder: (context, themeController, localeController, child) {
        MaterialApp materialApp = MaterialApp(
          locale: localeController.getLocale(),
          theme: ThemeData(
              primaryColor: SColors.primary,
              fontFamily: "HelveticaNeue",

              // backgroundColor: SColors.main_help
          ),
          home: const ArtSoundApp(),
          debugShowCheckedModeBanner: false,
          navigatorKey: AppConfig.navigatorStateKey,
          onGenerateRoute: RouterManager().router.generator,
          navigatorObservers: [RouterManager().routeRecorder],
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          supportedLocales: S.delegate.supportedLocales,
        );
        return ScreenUtil.buildScreenChangeRefreshWidget(
            AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.dark, child: materialApp),
            (bool isPortrait, double width, double height) {
          setState(() {});
        });
      }),
    );
    return FutureBuilder<bool>(
      future: AppConfig.initBase(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return contentView;
        }
        // Keep native launch black — never flash a white empty Container.
        return const ColoredBox(color: Color(0xFF000000));
      },
    );
  }
}
