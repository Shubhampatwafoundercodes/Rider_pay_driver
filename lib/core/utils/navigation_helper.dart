import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rider_pay_driver/core/utils/routes/routes_name.dart';
import 'package:rider_pay_driver/features/map/presentation/notifier/profile_notifier.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart';

class NextRouteDecider {
  static Future<void> goNextAfterProfileCheck(BuildContext context, WidgetRef ref) async {
    try {
      final userNotifier = ref.read(userProvider.notifier);
      await userNotifier.loadUser();
      final user = ref.read(userProvider);
      if (user == null || user.token.isEmpty) {
        if (!context.mounted) return;
        context.go(RoutesName.onBoard);
        return;
      }

      // 🔹 Profile API call
      await ref.read(profileProvider.notifier).getProfile();
      final profileState = ref.read(profileProvider);
      final profile = profileState.profile?.data;

      if (profile == null) {
        if (!context.mounted) return;
        context.go(RoutesName.onBoard);
        return;
      }

      final driver = profileState.profile?.data?.driver;
      final vehicle = profileState.profile?.data?.vehicleType?.verifiedStatus;
      final docs = profileState.profile?.data?.documents ?? [];

      // 🔹 Address check
      if (driver?.address == null || driver!.address!.isEmpty) {
        context.go(RoutesName.selectCity);
        return;
      }

      // 🔹 Documents check
      final hasUnverifiedDoc = docs.any(
            (doc) =>
        (doc.verifiedStatus == null) ||
            (doc.verifiedStatus!.toLowerCase() != "verified"),
      );

      // 🔹 Vehicle check
      final hasVehicleUpdate =
          vehicle == null || vehicle.toString().toLowerCase() != "verified";

      if (hasUnverifiedDoc || hasVehicleUpdate) {
        context.go(RoutesName.documentCenter);
        return;
      }

      // ✅ All done
      context.go(RoutesName.mapScreen);
    } catch (e, s) {
      debugPrint("NextRouteDecider error: $e\n$s");
      if (!context.mounted) return;
      context.go(RoutesName.onBoard);
    }
  }
}
