import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_rated_app/dummy/controller/get_data_fb.dart';
import 'package:top_rated_app/src/pages/login/login_page.dart';
import 'package:top_rated_app/src/pages/main/main_page.dart';
import 'package:top_rated_app/src/pages/register/register_page.dart';
import 'package:top_rated_app/src/pages/vendor_main/vendor_main_page.dart';
import 'package:top_rated_app/src/pages/vendor_register/vendor_register_page.dart';
import 'package:top_rated_app/src/pages/verify_code/verify_code_page.dart';
import 'package:top_rated_app/src/services/push_notification_service.dart';
import 'package:top_rated_app/static_vars.dart';
import '../config.dart';
import '../sdk/constants/app_constants.dart';
import 'app_provider.dart';
import 'app_theme.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var dbController= Get.put(MyDatabaseController());
  AppBloc _appBloc;

  getLocaleStatus()async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    StaticVars.localeStatus= prefs.getBool('localeStatus');
    print(StaticVars.localeStatus);
  }

  @override
  void initState() {
    super.initState();
    getLocaleStatus();
    dbController.getPostData();
    _appBloc = AppBloc.instance;
    PushNotificationService.instance.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _appBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return getRootWidget(context);
  }

  Widget getRootWidget(BuildContext context) {
    final colorScheme = AppTheme.light;
    return AppProvider(
      child: FutureBuilder<FirebaseApp>(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            print(snapshot);
            return
           GetMaterialApp(
             localizationsDelegates: translator.delegates,
             locale: translator.locale,
             supportedLocales: translator.locals(),


                title: Config.APP_NAME,
                debugShowCheckedModeBanner: false,
                debugShowMaterialGrid: false,
                theme: ThemeData(
                  colorScheme: colorScheme,
                  primaryColor: colorScheme.primary,
                  accentColor: colorScheme.secondary,
                  backgroundColor: colorScheme.background,
                  appBarTheme: AppBarTheme(
                    color: Colors.white,
                    elevation: 4,
                  ),
                  iconTheme: IconThemeData(color: colorScheme.secondary, size: 24),
                  accentTextTheme: Theme.of(context).textTheme.apply(
                        bodyColor: colorScheme.onSecondary,
                        displayColor: AppColor.accentDisplayColor,
                      ),
                  primaryTextTheme: Theme.of(context).textTheme.apply(
                        bodyColor: AppColor.primaryTextColor,
                        displayColor: AppColor.primaryDisplayColor,
                      ),
                  buttonTheme: ButtonThemeData(
                    buttonColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(WidgetConstants.cornerRadius)),
                  ),
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                    foregroundColor: colorScheme.onSecondary,
                    backgroundColor: colorScheme.secondary,
                  ),
                  cardTheme: CardTheme(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(WidgetConstants.cornerRadius),
                    ),
                    elevation: 2,
                    shadowColor: Colors.black38,
                    color: colorScheme.surface,
                  ),
                  textTheme: AppTextTheme.normal,
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(WidgetConstants.cornerRadius),
                      ),
                    ),
                    filled: true,
                    isDense: true,
                    fillColor: colorScheme.onPrimary,
                  ),
                ),
                routes: {
                  Routes.login: (context) => LoginPage(),
                  Routes.userRegister: (context) => RegisterPage(),
                  Routes.vendorRegister: (context) => VendorRegisterPage(),
                  Routes.home: (context) => MainPage(),
                  Routes.verification: (context) => VerifyCodePage(),
                  Routes.vendorHome: (context) => VendorMainPage(),
                },


                home: LoginPage(),
                // home: TestHome(),


                builder: (BuildContext context, Widget child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaleFactor: 0.85,
                    ), //set desired text scale factor here
                    child: child,
                  );
                },
              );

          }),
    );
  }
}
