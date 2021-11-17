import 'dart:async';
import 'dart:io';
// import 'package:admob_flutter/admob_flutter.dart';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_geofence/geofence.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:businesslistingapi/config/router.dart' as router;
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:businesslistingapi/provider/ps_provider_dependencies.dart';
import 'package:businesslistingapi/viewobject/common/language.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:businesslistingapi/config/ps_theme_data.dart';
import 'package:businesslistingapi/provider/common/ps_theme_provider.dart';
import 'package:businesslistingapi/repository/ps_theme_repository.dart';
import 'package:businesslistingapi/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_ios/in_app_purchase_ios.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'config/ps_colors.dart';
import 'config/ps_config.dart';
import 'constant/ps_dimens.dart';
import 'db/common/ps_shared_preferences.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';


Future<void> main() async {
  // add this, and it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();

  // final FirebaseMessaging _fcm = FirebaseMessaging();
  // if (Platform.isIOS) {
  //   _fcm.requestNotificationPermissions(const IosNotificationSettings());
  // }

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getString('codeC') == null) {
   await prefs.setString('codeC', ''); //null);
    await prefs.setString('codeL', ''); //null);
  }

   // Firebase.initializeApp();

  await Firebase.initializeApp();

  // FirebaseMessaging.onBackgroundMessage(Utils.myBackgroundMessageHandler);

  await Firebase.initializeApp();
  NativeAdmob(adUnitID: Utils.getAdAppId());


    if (Platform.isIOS) {
    FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
      );

  }

  /// Update the iOS foreground notification presentation options to allow

  /// heads up notifications.

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,

  );



  // Admob.initialize(Utils.getAdAppId());

  if (Platform.isIOS) {
    FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
      );
  }

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  //check is apple signin is available
  await Utils.checkAppleSignInAvailable();

  // Inform the plugin that this app supports pending purchases on Android.
  // An error will occur on Android if you access the plugin `instance`
  // without this call.
  //
  // On iOS this is a no-op.
  if (Platform.isAndroid) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }else {
     InAppPurchaseIosPlatform.registerPlatform();
  }

  MobileAds.instance.initialize();

  runApp(EasyLocalization(
      path: 'assets/langs',
      saveLocale: true,
      startLocale: PsConfig.defaultLanguage.toLocale(),
      supportedLocales: getSupportedLanguages(),
      child: PSApp()));
}

List<Locale> getSupportedLanguages() {
  final List<Locale> localeList = <Locale>[];
  for (final Language lang in PsConfig.psSupportedLanguageList) {
    localeList.add(Locale(lang.languageCode, lang.countryCode));
  }
  print('Loaded Languages');
  return localeList;
}

class PSApp extends StatefulWidget {
  @override
  _PSAppState createState() => _PSAppState();
}

// Future<dynamic> initAds() async {
//   if (PsConfig.showAdMob && await Utils.checkInternetConnectivity()) {
//     // FirebaseAdMob.instance.initialize(appId: Utils.getAdAppId());
//   }
// }

class _PSAppState extends State<PSApp> {
  Completer<ThemeData> themeDataCompleter;
  PsSharedPreferences psSharedPreferences;

  @override
  void initState() {
    super.initState();
  }

  Future<ThemeData> getSharePerference(
      EasyLocalization provider, dynamic data) {
    Utils.psPrint('>> get share perference');
    if (themeDataCompleter == null) {
      Utils.psPrint('init completer');
      themeDataCompleter = Completer<ThemeData>();
    }

    if (psSharedPreferences == null) {
      Utils.psPrint('init ps shareperferences');
      psSharedPreferences = PsSharedPreferences.instance;
      Utils.psPrint('get shared');
      psSharedPreferences.futureShared.then((SharedPreferences sh) {
        psSharedPreferences.shared = sh;

        Utils.psPrint('init theme provider');
        final PsThemeProvider psThemeProvider = PsThemeProvider(
            repo: PsThemeRepository(psSharedPreferences: psSharedPreferences));

        Utils.psPrint('get theme');
        final ThemeData themeData = psThemeProvider.getTheme();
        themeDataCompleter.complete(themeData);
        Utils.psPrint('themedata loading completed');
      });
    }

    return themeDataCompleter.future;
  }

  List<Locale> getSupportedLanguages() {
    final List<Locale> localeList = <Locale>[];
    for (final Language lang in PsConfig.psSupportedLanguageList) {
      localeList.add(Locale(lang.languageCode, lang.countryCode));
    }
    print('Loaded Languages');
    return localeList;
  }

  @override
  Widget build(BuildContext context) {
    // return Container();
    // init Color
    PsColors.loadColor(context);
    Utils.psPrint(EasyLocalization.of(context).locale.languageCode);

    Future<void> requestPermission() async {

      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.camera,
      ].request();
      print(statuses[Permission.storage]);

      if(await Permission.locationAlways.isDenied) {
        showDialog<void>(context: context, builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      height: 60,
                      width: double.infinity,
                      padding: const EdgeInsets.all(PsDimens.space8),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          color: PsColors.mainColor),
                      child: Row(
                        children: <Widget>[
                          const SizedBox(width: PsDimens.space4),
                          Icon(
                            Icons.pin_drop,
                            color: PsColors.white,
                          ),
                          const SizedBox(width: PsDimens.space4),
                          Text(
                            'Special Permission',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: PsColors.white,
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: PsDimens.space20),
                  Container(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space16,
                        right: PsDimens.space16,
                        top: PsDimens.space8,
                        bottom: PsDimens.space8),
                    child: Text(
                      'To alert you when you are near a registered business, '
                          'this app requires special permission to access your location while working in the background. '
                          'We respect user privacy. Your location will never be recorded or shared for any reason.'
                          "Tap 'Deny' to proceed without receiving notification alerts. "
                          "Tap 'Continue' and select 'Allow all the time' from the next screen to receive alerts.",
                      style: Theme
                          .of(context)
                          .textTheme
                          .subtitle2,
                    ),
                  ),
                  const SizedBox(height: PsDimens.space20),
                  Divider(
                    thickness: 0.5,
                    height: 1,
                    color: Theme
                        .of(context)
                        .iconTheme
                        .color,
                  ),
                  ButtonBar(
                    children: [
                      MaterialButton(
                        height: 50,
                        minWidth: 100,
                        onPressed: () async {
                          Navigator.of(context).pop();

                          Map<Permission, PermissionStatus> statuses = await [
                            Permission.locationAlways,
                          ].request();
                          print(statuses[Permission.locationAlways]);

                          // Geofence.initialize();
                        },
                        child: Text(
                          'Continue',
                          style: Theme
                              .of(context)
                              .textTheme
                              .button
                              .copyWith(color: PsColors.mainColor),
                        ),
                      ),
                      MaterialButton(
                        height: 50,
                        minWidth: 100,
                        onPressed: () {
                          Navigator.of(context).pop();
                          showDeniedDialog();
                        },
                        child: Text(
                          'No',
                          style: Theme
                              .of(context)
                              .textTheme
                              .button
                              .copyWith(color: PsColors.mainColor),
                        ),
                      )
                    ],
                  )

                ],
              ),
            ),
          );
        },);
      }else{

        // Geofence.initialize();
      }
    }
    // requestPermission();
    return MultiProvider(
        providers: <SingleChildWidget>[
          ...providers,
        ],
        child: DynamicTheme(
            defaultBrightness: Brightness.light,
            data: (Brightness brightness) {
              // return themeData(ThemeData.dark());
              if (brightness == Brightness.light) {
                return themeData(ThemeData.light());
              } else {
                return themeData(ThemeData.dark());
              }
            },

            themedWidgetBuilder: (BuildContext context, ThemeData theme) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Panacea-Soft',
                theme: theme,
                initialRoute: '/',
                onGenerateRoute: router.generateRoute,
                localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  EasyLocalization.of(context).delegate,
                ],
                supportedLocales: EasyLocalization.of(context).supportedLocales,
                locale: EasyLocalization.of(context).locale,
              );
            }));


  }

  void showDeniedDialog() {

    showDialog<void>(context: context, builder: (context) {

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  height: 60,
                  width: double.infinity,
                  padding: const EdgeInsets.all(PsDimens.space8),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)),
                      color: PsColors.mainColor),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: PsDimens.space4),
                      Icon(
                        Icons.pin_drop,
                        color: PsColors.white,
                      ),
                      const SizedBox(width: PsDimens.space4),
                      Text(
                        'Special Permission',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: PsColors.white,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: PsDimens.space20),
              Container(
                padding: const EdgeInsets.only(
                    left: PsDimens.space16,
                    right: PsDimens.space16,
                    top: PsDimens.space8,
                    bottom: PsDimens.space8),
                child: Text(
                  "You will not be alerted when you are near a registered black owned business. "
                      "We respect user privacy. You location will never be recorded or shared for any reason. "
                      "Tap 'Continue' to proceed without receiving alerts. "
                      "To enable alerts when near a registered black owned business select 'allow all the time' at [Go to Settings] > [Permissions]"
                      "Tap 'Continue' and select 'Allow all the time' from the next screen to receive alerts.",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              const SizedBox(height: PsDimens.space20),
              Divider(
                thickness: 0.5,
                height: 1,
                color: Theme.of(context).iconTheme.color,
              ),
              ButtonBar(
                children: [
                  MaterialButton(
                    height: 50,
                    minWidth: 100,
                    onPressed: () async {
                      Navigator.of(context).pop();

                      AppSettings.openAppSettings(asAnotherTask: true);
                    },
                    child: Text(
                      'Go to Settings',
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: PsColors.mainColor),
                    ),
                  ),
                  MaterialButton(
                    height: 50,
                    minWidth: 100,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'No',
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: PsColors.mainColor),
                    ),
                  )
                ],
              )

            ],
          ),
        ),
      );
    },);
  }
}
