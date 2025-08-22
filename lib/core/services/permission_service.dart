import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  void storagePermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Permission.storage.request();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
