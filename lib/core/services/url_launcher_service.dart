import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  Future<void> sendMail() async {
    final Uri mail = Uri.parse("mailto:");
    launchUrl(mail, mode: LaunchMode.externalApplication);
  }
}
