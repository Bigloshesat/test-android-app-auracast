/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

class PermissionManager {
  static PermissionManager? _permissionManager;

  PermissionManager._internal();

  factory PermissionManager() =>
      _permissionManager ??= PermissionManager._internal();

  final PermissionHandlerPlatform permissionHandler =
      PermissionHandlerPlatform.instance;

  Future<ServiceStatus> checkServiceStatus(Permission permission) {
    return permissionHandler.checkServiceStatus(permission);
  }

  Future<PermissionStatus> checkPermissionStatus(Permission permission) {
    return permissionHandler.checkPermissionStatus(permission);
  }

  Future<bool> openAppSettings() {
    return permissionHandler.openAppSettings();
  }

  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions) {
    return permissionHandler.requestPermissions(permissions);
  }

  Future<bool> shouldShowRequestPermissionRationale(Permission permission) {
    return permissionHandler.shouldShowRequestPermissionRationale(permission);
  }
}
