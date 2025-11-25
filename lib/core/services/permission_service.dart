import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> check(Permission permission) async {
    return (await permission.status).isGranted;
  }

  Future<bool> request(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  Future<void> openSettingsIfDenied(Permission permission) async {
    final status = await permission.status;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}
