import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/config/env/tlf_environnments.dart';
import 'package:e_loan_mobile/routes/routing.dart';
import 'package:e_loan_mobile/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'Helpers/helpers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ! local storage
  await GetStorage.init();

  await setupFirebaseRequirements();

  setupAllowedDeviceOrientation();

  TLFEnvrionnments.disableTestMode(); // optional

  DioRequestsInterceptor.initialiseConnectivityMonitorListener();

  setupEnvironnment(Environnement.prod);

  configureGlobalLoader();

  setupStatusBarTransparency();

  runApp(AppWidget(key: UniqueKey()));
}

class AppWidget extends StatelessWidget {
  const AppWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BackPressInterceptorManager.configureInterceptor();

    Get.put(NotificationsController(), permanent: true);

    return GetMaterialApp(
      navigatorKey: KeysStorage.mainNavigatorKey,
      debugShowCheckedModeBanner: fakeData,

      //? Themes
      theme: AppThemes.defaultAppTheme,
      darkTheme: AppThemes.defaultAppTheme,
      themeMode: ThemeMode.light,

      //? Locales management
      locale: TLFEnvrionnments.supportedLocales.first,
      fallbackLocale: TLFEnvrionnments.supportedLocales.first,
      supportedLocales: TLFEnvrionnments.supportedLocales,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
      ],

      builder: (BuildContext context, Widget child) {
        //? EasyLoading
        return FlutterEasyLoading(
          //? Menu
          child: Menu(
            navigator: child.key as GlobalKey<NavigatorState>,
            child: child,
          ),
        );
      },

      //? Routing
      defaultTransition: Transition.cupertino,
      getPages: AppPages.pages,
      initialRoute: AppRoutes.login,
      enableLog: false,
    );
  }
}
