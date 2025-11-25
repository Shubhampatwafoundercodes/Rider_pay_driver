import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rider_pay_driver/core/helper/network/network_api_service_dio.dart';
import 'package:rider_pay_driver/features/onboarding/data/repo_impl/user_app_url_repo_impl.dart';
import 'package:rider_pay_driver/features/onboarding/domain/repo/user_app_url_repo.dart';
import 'package:url_launcher/url_launcher.dart';

final userAppUrlNotifierProvider =
StateNotifierProvider<UserAppUrlNotifier, AsyncValue<String>>((ref) {
  return UserAppUrlNotifier(UserAppUrlRepoImpl(NetworkApiServicesDio(ref)));
});

class UserAppUrlNotifier extends StateNotifier<AsyncValue<String>> {
  final UserAppUrlRepo repo;

  UserAppUrlNotifier(this.repo) : super(const AsyncValue.loading()) {
    fetchUserAppUrl();
  }

  Future<void> fetchUserAppUrl() async {
    try {
      final res = await repo.userAppUrl();

      final url = res['data'][0]['userApplicationUrl'] as String?;
      if (url != null && url.isNotEmpty) {
        state = AsyncValue.data(url);
      } else {
        state = AsyncValue.error("URL not found", StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> openInBrowser() async {
    print("SHubhamamam");
    final currentUrl = state.value;
    if (currentUrl != null) {
      final uri = Uri.parse(currentUrl);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception("Could not launch $currentUrl");
      }
    }
  }
}
