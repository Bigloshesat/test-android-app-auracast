/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionWidget extends StatefulWidget {
  final Permission permission;

  const PermissionWidget(this.permission);

  @override
  State<StatefulWidget> createState() => _PermissionState(permission);
}

class _PermissionState extends State<PermissionWidget> {
  final Permission _permission;

  _PermissionState(this._permission);

  PermissionStatus _permissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    final status = await _permission.status;
    setState(() => _permissionStatus = status);
  }

  Color getPermissionColor() {
    switch (_permissionStatus) {
      case PermissionStatus.denied:
        return Colors.red;
      case PermissionStatus.granted:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_permission.toString()),
      subtitle: Text(
        _permissionStatus.toString(),
        style: TextStyle(color: getPermissionColor()),
      ),
      trailing: IconButton(
          icon: Icon(Icons.info),
          onPressed: () {
            checkServiceStatus(context, _permission);
          }),
      onTap: () {
        requestPermission(_permission);
      },
    );
  }

  void checkServiceStatus(BuildContext context, Permission permission) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text((await permission.status).toString()),
    ));
  }

  Future<void> requestPermission(Permission permission) async {
    PermissionStatus permissionStatus = await permission.request();
    setState(() {
      _permissionStatus = permissionStatus;
    });
  }
}
