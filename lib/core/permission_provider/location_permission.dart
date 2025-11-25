import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider, StateNotifier;
import 'package:permission_handler/permission_handler.dart';
import 'package:rider_pay_driver/core/services/permission_service.dart';

final locationPermissionProvider = StateNotifierProvider<LocationPermissionNotifier, bool>(
      (ref) => LocationPermissionNotifier(PermissionService()),
);

class LocationPermissionNotifier extends StateNotifier<bool> {
  final PermissionService _service;

  LocationPermissionNotifier(this._service) : super(false) {
    checkPermission();
  }

  Future<void> checkPermission() async {
    state = await _service.check(Permission.locationWhenInUse);
  }

  Future<void> requestPermission() async {
    final granted = await _service.request(Permission.locationWhenInUse);
    state = granted;
    if (!granted) {
      await _service.openSettingsIfDenied(Permission.locationWhenInUse);
    }
  }
}
