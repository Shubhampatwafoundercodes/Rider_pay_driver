import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart' show FirebaseMessaging, RemoteMessage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_driver/core/res/app_device.dart';
import 'package:rider_pay_driver/core/utils/routes/routes.dart';
import 'package:rider_pay_driver/features/firebase_service/fcm_token/fcm_token_provider.dart';
import 'package:rider_pay_driver/features/firebase_service/notification/notification_service.dart';
import 'package:rider_pay_driver/features/map/presentation/booking_details/map_booking_details.dart';
import 'package:rider_pay_driver/features/settings/language/language_controller.dart';
import 'package:rider_pay_driver/features/settings/theme/app_theme.dart';
import 'package:rider_pay_driver/features/settings/theme/theme_controller.dart';
import 'package:rider_pay_driver/firebase_options.dart';
import 'package:rider_pay_driver/l10n/app_localizations.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart';

import 'features/firebase_service/ride/notifer/ride_notifer.dart' show driverRideNotifierProvider;
import 'features/internet_checker/internet_provider.dart' show InternetBanner;

double screenWidth = 0;
double screenHeight = 0;

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Connectivity().checkConnectivity();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  runApp(const ProviderScope(child: MyApp()));
}


@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage massage) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Hit massage delivered API here
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.listen<User?>(userProvider, (previous, next) {
    //   if (previous != null && next == null && context.mounted) {
    //     // router.go(RoutesName.login);
    //   }
    // });
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        screenWidth = 1.sw;
        screenHeight = 1.sh;
        final size = MediaQuery.of(context).size;
        AppDevice.init(size);

        return MaterialApp.router(
          title: 'RiderPay Driver',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          locale: locale,
          supportedLocales: const [Locale('en'), Locale('hi')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            final brightness = Theme.of(context).brightness;
            final overlayStyle =
                (themeMode == ThemeMode.dark ||
                    (themeMode == ThemeMode.system &&
                        brightness == Brightness.dark))
                ? const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.light,
                    systemNavigationBarColor: Colors.black,
                    systemNavigationBarIconBrightness: Brightness.light,
                  )
                : const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark,
                    systemNavigationBarColor: Color(0xff0D0B21),
                    systemNavigationBarIconBrightness: Brightness.light,
                  );

            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: overlayStyle,
              child: GlobalApp(child: child),
            );
          },
          routerConfig: router,
        );
      },
    );
  }
}


class GlobalApp extends ConsumerWidget {
  final Widget? child;
  const GlobalApp({super.key, this.child});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideState = ref.watch(driverRideNotifierProvider);
    final driverId = ref.watch(userProvider.notifier).userId.toString();

    final shouldShowOverlay = rideState.rides.any(
          (r) =>
      r.status.toLowerCase() == 'pending' ||
          (r.acceptedByDriver == true && r.driverId == driverId),
    );

    return Material(
      child: Stack(
        children: [
          child ?? const SizedBox.shrink(),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: InternetBanner(),
          ),
          // MaterialApp.router(
          //   title: 'RiderPay Driver',
          //   routerConfig: router,
          //   debugShowCheckedModeBanner: false,
          //   theme: AppTheme.lightTheme,
          // ),
          if (shouldShowOverlay)
            MapBookingDetailsOverlay(
              rides: rideState.rides,
              driverId: driverId,
            ),
        ],
      ),
    );
  }
}