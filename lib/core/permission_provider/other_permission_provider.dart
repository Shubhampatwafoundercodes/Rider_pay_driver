// ignore_for_file: unused_import

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/permission_service.dart';

final otherPermissionsProvider =
StateNotifierProvider<OtherPermissionsNotifier, Map<Permission, bool>>(
      (ref) => OtherPermissionsNotifier(PermissionService()),
);

class OtherPermissionsNotifier extends StateNotifier<Map<Permission, bool>> {
  final PermissionService _service;

  OtherPermissionsNotifier(this._service)
      : super({
    // Permission.locationAlways: false,
    Permission.notification: false,
  }) {
    _init();
  }

  /// Initialize all permission statuses
  Future<void> _init() async {
    final Map<Permission, bool> status = {};
    for (var permission in state.keys) {
      status[permission] = await _service.check(permission);
    }
    state = status;
  }

  /// Request a single permission
  Future<void> request(Permission permission) async {
    final granted = await _service.request(permission);
    state = {...state, permission: granted};

    if (!granted) {
      await _service.openSettingsIfDenied(permission);
    }
  }

  /// Request notification permission specifically
  Future<void> requestNotificationPermission() async {
    final permission = Permission.notification;
    final granted = await _service.request(permission);
    state = {...state, permission: granted};

    if (!granted) {
      await _service.openSettingsIfDenied(permission);
    }
  }

  /// Request contacts permission specifically
  Future<void> requestContactsPermission() async {
    final permission = Permission.contacts;
    final granted = await _service.request(permission);
    state = {...state, permission: granted};

    if (!granted) {
      await _service.openSettingsIfDenied(permission);
    }
  }

  /// Grant all permissions at once
  Future<void> grantAll() async {
    for (var permission in state.keys) {
      await request(permission);
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }
}
