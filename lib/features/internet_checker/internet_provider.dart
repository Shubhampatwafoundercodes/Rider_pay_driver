import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateNotifier, StateNotifierProvider;

enum NetworkStatus { connected, disconnected }

final networkStatusProvider =
StateNotifierProvider<NetworkStatusNotifier, NetworkStatus>(
      (ref) => NetworkStatusNotifier(),
);

class NetworkStatusNotifier extends StateNotifier<NetworkStatus> {
  late final StreamSubscription _subscription;

  NetworkStatusNotifier() : super(NetworkStatus.connected) {
    _init();
  }

  Future<void> _init() async {
    final connectivity = Connectivity();

    // initial check
    final results = await connectivity.checkConnectivity();
    state = _getStatusFromResults(results);

    // listen to changes (v6+ returns a List)
    _subscription =
        connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
          state = _getStatusFromResults(results);
        });
  }

  NetworkStatus _getStatusFromResults(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet) ||
        results.contains(ConnectivityResult.vpn)) {
      return NetworkStatus.connected;
    }
    return NetworkStatus.disconnected;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}


/// 🔴 Global banner to show internet connectivity status
class InternetBanner extends ConsumerWidget {
  const InternetBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkStatus = ref.watch(networkStatusProvider);

    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: networkStatus == NetworkStatus.disconnected
          ? Offset.zero
          : const Offset(0, -1),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: networkStatus == NetworkStatus.disconnected ? 1 : 0,
        child: Material(
          elevation: 2,
          color: Colors.redAccent,
          child: Container(

            height: 100,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            alignment: Alignment.bottomCenter,
            child: const Text(
              '🚫 No Internet Connection',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
