import 'package:easy_localization/easy_localization.dart';
import '../../../../generated/locale_keys.g.dart';

class GreetingService {
   static String getGreetingKey() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return LocaleKeys.good_morning;
    } else if (hour >= 12 && hour < 17) {
      return LocaleKeys.good_afternoon;
    } else if (hour >= 17 && hour < 21) {
      return LocaleKeys.good_evening;
    } else {
      return LocaleKeys.good_night;
    }
  }

   static String getGreeting() {
    final key = getGreetingKey();
    return key.tr();
  }
}
