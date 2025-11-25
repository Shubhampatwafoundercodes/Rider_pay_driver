import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/features/auth/presentation/ui/change_register_number.dart';
import 'package:rider_pay_driver/features/auth/presentation/ui/login_screen.dart';
import 'package:rider_pay_driver/features/auth/presentation/ui/otp_screen.dart'
    show OtpScreen;
import 'package:rider_pay_driver/features/auth/presentation/ui/register_section/city/city_selection.dart';
import 'package:rider_pay_driver/features/auth/presentation/ui/register_section/city/search_city.dart';
import 'package:rider_pay_driver/features/auth/presentation/ui/register_section/document_upload/document_center.dart'
    show DocumentCenter;
import 'package:rider_pay_driver/features/auth/presentation/ui/register_section/document_upload/document_uplode.dart';
import 'package:rider_pay_driver/features/auth/presentation/ui/register_section/document_upload/permission_screen.dart';
import 'package:rider_pay_driver/features/auth/presentation/ui/register_section/register_number.dart';
import 'package:rider_pay_driver/features/auth/presentation/ui/register_section/vehicle_reg/vehicle_selection_screen.dart';
import 'package:rider_pay_driver/features/drawer/data/model/get_bank_details_model.dart';
import 'package:rider_pay_driver/features/drawer/data/model/support_fq_model.dart'
    show SupportFqModelData;
import 'package:rider_pay_driver/features/drawer/presentation/ui/notification/notification_screen.dart';
import 'package:rider_pay_driver/features/drawer/presentation/ui/profile/my_profile.dart';
import 'package:rider_pay_driver/features/drawer/presentation/ui/profile/screen/document_details_screen.dart'
    show DocumentDetailScreen;
import 'package:rider_pay_driver/features/drawer/presentation/ui/profile/screen/document_view.dart'
    show DocumentView;
import 'package:rider_pay_driver/features/drawer/presentation/ui/profile/screen/driver_id_card.dart';
import 'package:rider_pay_driver/features/drawer/presentation/ui/profile/screen/language_speak_screen.dart';
import 'package:rider_pay_driver/features/drawer/presentation/ui/profile/screen/performance_screen.dart';
import 'package:rider_pay_driver/features/drawer/presentation/ui/profile/screen/profile_info_screen.dart';
import 'package:rider_pay_driver/features/drawer/presentation/ui/rate_card_screen.dart';
import 'package:rider_pay_driver/features/drawer/presentation/ui/wallet/account_details_view.dart';
import 'package:rider_pay_driver/features/drawer/presentation/ui/wallet/add_bank_account_page.dart';
import 'package:rider_pay_driver/features/drawer/presentation/ui/wallet/money_transfer_screen.dart';
import 'package:rider_pay_driver/features/map/presentation/map_screen.dart';
import 'package:rider_pay_driver/features/onboarding/onboarding_screen.dart';
import 'package:rider_pay_driver/features/onboarding/splash/splash_screen.dart';
import 'package:rider_pay_driver/features/settings/help/presentation/support_details_screen.dart';
import 'package:rider_pay_driver/features/settings/help/presentation/support_screen.dart';
import 'package:rider_pay_driver/features/settings/language/language_screen.dart'
    show LanguageScreen;

// class AppRoute {
//   static Widget generateRoute(String routeName) {
//     return Text("");
//     // switch (routeName)
//     // {
//     //   case RouteName.splash:
//     //     return const SplashScreen();
//
//     //   default:
//     //     return const SplashScreen();
//     // }
//   }
// }

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

CupertinoPage<T> cupertinoPage<T>(Widget child) {
  return CupertinoPage<T>(child: child);
}

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RoutesName.splash,
  routes: [
    GoRoute(
      path: RoutesName.splash,
      name: RoutesName.splash,
      pageBuilder: (context, state) => cupertinoPage(const SplashScreen()),
    ),

    GoRoute(
      path: RoutesName.onBoard,
      name: RoutesName.onBoard,
      pageBuilder: (context, state) => cupertinoPage(const OnboardingScreen()),
    ),

    GoRoute(
      path: RoutesName.language,
      name: RoutesName.language,
      pageBuilder: (context, state) {
        final showButton = state.extra as bool? ?? true;
        return cupertinoPage(LanguageScreen(showProceedButton: showButton));
      },
    ),
    GoRoute(
      path: RoutesName.supportScreen,
      name: RoutesName.supportScreen,
      pageBuilder: (context, state) => cupertinoPage(const SupportScreen()),
    ),

    GoRoute(
      path: RoutesName.supportDetailsScreen,
      name: RoutesName.supportDetailsScreen,
      pageBuilder: (context, state) {
        final data = state.extra as SupportFqModelData?;
        return CupertinoPage(
          child: SupportDetailsScreen(
            data:
                data ??
                SupportFqModelData(
                  id: 0,
                  question: '',
                  answer: '',
                  status: 0,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
          ),
        );
      },
    ),

    GoRoute(
      path: RoutesName.loginScreen,
      name: "'login'",
      // name: RoutesName.loginScreen,
      pageBuilder: (context, state) => cupertinoPage(const LoginScreen()),
    ),
    GoRoute(
      path: RoutesName.changeRegisterNumber,
      name: "ChangeRegister",
      // name: RoutesName.loginScreen,
      pageBuilder: (context, state) =>
          cupertinoPage(const ChangeRegisterNumber()),
    ),

    GoRoute(
      path: RoutesName.otpScreen,
      name: "OTPScreen",
      pageBuilder: (context, state) {
        final phoneNumber = state.extra as String;
        return cupertinoPage(OtpScreen(number: phoneNumber));
      },
    ),

    GoRoute(
      path: RoutesName.selectCity,
      name: "CitySelection",
      pageBuilder: (context, state) => cupertinoPage(const CitySelection()),
    ),

    GoRoute(
      path: RoutesName.selectSearchCity,
      name: "SelectSearchCitySelection",
      pageBuilder: (context, state) => cupertinoPage(const SearchCity()),
    ),
    GoRoute(
      path: RoutesName.registerNumber,
      name: "registerScreen",
      pageBuilder: (context, state) => cupertinoPage(const RegisterNumber()),
    ),

    GoRoute(
      path: RoutesName.vehicleSelection,
      name: "vehicleScreen",
      pageBuilder: (context, state) =>
          cupertinoPage(const VehicleSelectionScreen()),
    ),

    GoRoute(
      path: RoutesName.documentCenter,
      name: "documentCenter",
      pageBuilder: (context, state) => cupertinoPage(const DocumentCenter()),
    ),
    GoRoute(
      path: RoutesName.documentUpload,
      name: "documentUpload",
      pageBuilder: (context, state) {
        final extras = state.extra as Map<String, dynamic>?;
        final docType = extras?["docType"] ?? "";
        return cupertinoPage(DocumentUploadScreen(docType: docType));
      },
    ),
    GoRoute(
      path: RoutesName.permissionsScreen,
      name: "permissionsScreen",
      pageBuilder: (context, state) => cupertinoPage(const PermissionsScreen()),
    ),
    GoRoute(
      path: RoutesName.mapScreen,
      name: "mapScreen",
      pageBuilder: (context, state) => cupertinoPage(const MapScreen()),
    ),

    GoRoute(
      path: RoutesName.notificationScreen,
      name: "notificationScreen",
      pageBuilder: (context, state) =>
          cupertinoPage(const NotificationScreen()),
    ),
    GoRoute(
      path: RoutesName.myProfileScreen,
      name: "myProfileScreen",
      pageBuilder: (context, state) => cupertinoPage(const MyProfile()),
    ),
    GoRoute(
      path: RoutesName.profileInfoScreen,
      name: "profileInfoScreen",
      pageBuilder: (context, state) => cupertinoPage(const ProfileInfoScreen()),
    ),
    GoRoute(
      path: RoutesName.performanceScreen,
      name: "performanceScreen",
      pageBuilder: (context, state) => cupertinoPage(const PerformanceScreen()),
    ),
    GoRoute(
      path: RoutesName.driverIdCard,
      name: "driverIdCard",
      pageBuilder: (context, state) => cupertinoPage(const DriverIdCard()),
    ),

    GoRoute(
      path: RoutesName.documentView,
      name: "documentView",
      pageBuilder: (context, state) => cupertinoPage(DocumentView()),
    ),
    GoRoute(
      path: RoutesName.documentDetailsView,
      name: "documentDetailsView",
      builder: (context, state) {
        final doc = state.extra;
        return DocumentDetailScreen(document: doc);
      },
    ),

    GoRoute(
      path: RoutesName.languageSpeakScreen,
      name: "languageSpeakScreen",
      pageBuilder: (context, state) =>
          cupertinoPage(const LanguageSpeakScreen()),
    ),

    GoRoute(
      path: RoutesName.rateCardScreen,
      name: "rateCardScreen",
      pageBuilder: (context, state) => cupertinoPage(const RateCardScreen()),
    ),
    GoRoute(
      path: RoutesName.addBankAccountScreen,
      name: "addBankAccountScreen",
      pageBuilder: (context, state) {
        // Get parameters from extra
        final args = state.extra as Map<String, dynamic>? ?? {};
        final isBankAccount = args['isBankAccount'] as bool? ?? true;

        return cupertinoPage(AddBankAccountPage( isAddBankAcc: isBankAccount,));
      },
    ),
    GoRoute(
      path: RoutesName.moneyTransferScreen,
      name: "moneyTransferScreen",
      pageBuilder: (context, state) => cupertinoPage(const MoneyTransferPage()),
    ),

    GoRoute(
      path: RoutesName.paymentDetailsScreen,
      builder: (context, state) {
        final method = state.extra as BankDetailsOnlyOneData;
        return PaymentDetailsScreen(method: method);
      },
    ),
  ],
);
