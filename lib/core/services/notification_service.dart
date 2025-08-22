// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:injectable/injectable.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../../router/app_router.dart';
//
// class NotificationService {
//   final NotificationsRepository notificationsRepository;
//
//   NotificationService({required this.notificationsRepository});
//
//   Future<void> initNotifications() async {
//     requestPermission();
//     initFcmNotification();
//     initLocalNotificationInfo();
//   }
//
//   void notificationClicked(
//       {required String notificationId, required int type, required String recordId}) {
//     // mark notification is read
//     // make navigation
//   }
//
//   Future<void> markNotificationRead({required String notificationId}) async {
//     final res = await notificationsRepository.markNotificationRead(notificationId: notificationId);
//
//     res.fold((data) {
//       debugPrint('Success');
//     }, (error) {
//       debugPrint('Error ${error.toString()}');
//     });
//   }
// }
//
// void requestPermission() async {
//   if (Platform.isAndroid) {
//     /// Requesting permissions on Android 13 or higher
//     // FlutterLocalNotificationsPlugin()
//     //     .resolvePlatformSpecificImplementation<
//     //         AndroidFlutterLocalNotificationsPlugin>()
//     //     ?.requestNotificationsPermission();
//
//     final notificationStatus = await Permission.notification.status;
//     if (notificationStatus.isDenied) {
//       Permission.notification.request();
//     }
//     if (notificationStatus.isPermanentlyDenied) {
//       openAppSettings();
//     }
//   }
//
//   if (Platform.isIOS) {
//     FlutterLocalNotificationsPlugin()
//         .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//   }
// }
//
// void initLocalNotificationInfo() {
//   AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings(
//     '@mipmap/ic_launcher',
//   );
//   DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
//     requestAlertPermission: false,
//     requestBadgePermission: false,
//     requestSoundPermission: false,
//     onDidReceiveLocalNotification: (id, title, body, payload) {
//       debugPrint('++++++++++ onDidReceiveLocalNotification ++++++++++');
//       debugPrint(
//           '++++++++++ This property is only applicable to iOS versions older than 10 ++++++++++');
//       debugPrint('id: $id');
//       debugPrint('title: $title');
//       debugPrint('body: $body');
//       debugPrint('payload: $payload');
//     },
//     notificationCategories: [
//       /// when you edit here you must reinstall app again
//       const DarwinNotificationCategory(
//         'hbr_categoryIdentifier',
//         // actions: [
//         //   DarwinNotificationAction.plain(
//         //     'id_1',
//         //     'name 1',
//         //     options: {
//         //       DarwinNotificationActionOption.foreground,
//         //       DarwinNotificationActionOption.authenticationRequired,
//         //     },
//         //   ),
//         //   DarwinNotificationAction.plain(
//         //     'id_2',
//         //     'name 2',
//         //     options: {
//         //       DarwinNotificationActionOption.foreground,
//         //       DarwinNotificationActionOption.authenticationRequired,
//         //       DarwinNotificationActionOption.destructive,
//         //     },
//         //   ),
//         // ],
//         options: {DarwinNotificationCategoryOption.hiddenPreviewShowTitle},
//       ),
//     ],
//   );
//
//   final InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsIOS,
//   );
//
//   FlutterLocalNotificationsPlugin().initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
//     onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
//   );
// }
//
// Future initFcmNotification() async {
//   FirebaseMessaging.instance.getInitialMessage().then(firebaseMessageInitialMessageHandler).onError(
//     (error, stackTrace) {
//       debugPrint('++++++++++ stackTrace ${stackTrace.toString()}');
//       debugPrint('++++++++++ error ${error.toString()}');
//     },
//   );
//
//   ///  opened app when notification clicked on background
//   FirebaseMessaging.onMessageOpenedApp.listen(firebaseMessageOpenAppHandler);
//
//   /// notification received when app in background
//   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//
//   /// notification received when app in foreground
//   FirebaseMessaging.onMessage.listen((message) {
//     debugPrint('++++++++++ onMessage ++++++++++');
//     if (message.notification == null) return;
//
//     if (message.data['isFromChat'] == "false") {
//       showNotification(message);
//     }
//   });
// }
//
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   debugPrint('++++++++++ Notification received onBackground Or Terminated ++++++++++');
// }
//
// void firebaseMessageOpenAppHandler(RemoteMessage? message) {
//   debugPrint('++++++++++ openApp from notification ++++++++++');
//   if (message == null) return;
//
//   notificationClickedHandler(message: message);
// }
//
// void firebaseMessageInitialMessageHandler(RemoteMessage? message) {
//   // debugPrint('++++++++++ Notification Clicked In Terminated ++++++++++');
//   debugPrint('++++++++++ FlutterFirebaseMessagingBackgroundService started! ++++++++++');
//   if (message == null) return;
//   // showNotification(message);
// }
//
// @pragma('vm:entry-point')
// void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) {
//   debugPrint('++++++++++ Local Notification Clicked (or action) In Background ++++++++++');
//   localNotificationClickedHandler(notificationResponse: notificationResponse);
// }
//
// @pragma('vm:entry-point')
// void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
//   debugPrint('++++++++++ local Notification Clicked (or action) In Foreground ++++++++++');
//   localNotificationClickedHandler(notificationResponse: notificationResponse);
// }
//
// void showNotification(RemoteMessage message) async {
//   FlutterLocalNotificationsPlugin().show(
//     message.hashCode,
//     message.notification!.title,
//     message.notification!.body,
//     await setLocalNotificationDetails(message),
//     // passed back data to app in NotificationResponse payload -> json.decode(payload)
//     payload: json.encode(message.data),
//   );
// }
//
// Future<NotificationDetails> setLocalNotificationDetails(RemoteMessage message) async {
//   // BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
//   //   // body['Content'] ?? 'Empty Content',
//   //   message.notification!.title ?? 'Empty Content',
//   //   contentTitle: message.notification!.body,
//   //   // summaryText: "-----",
//   //   // htmlFormatContentTitle: true,
//   //   // htmlFormatBigText: true,
//   //   // htmlFormatSummaryText: true,
//   //   // htmlFormatTitle: true,
//   //   // htmlFormatContent: true,
//   // );
//   // Map<String, dynamic> test = jsonDecode(message.notification.toString());
//   // debugPrint('message: ${message.notification['data'].toString()}');
//
//   // final BigPictureStyleInformation bigPictureStyleInformation =
//   //     BigPictureStyleInformation(
//   //         ByteArrayAndroidBitmap(message.data['ExternalURL']),
//   //         largeIcon: ByteArrayAndroidBitmap(message.data['ExternalURL']),
//   //         contentTitle: message.notification!.title,
//   //         htmlFormatContentTitle: true,
//   //         summaryText: message.notification!.body,
//   //         htmlFormatSummaryText: true);
//
//   final String imgUrl = message.data['Image'] ?? '';
//   AndroidBitmap<Uint8List>? largeIcon;
//   if (imgUrl != '') {
//     Uint8List bigPicture =
//         (await NetworkAssetBundle(Uri.parse(imgUrl)).load(imgUrl)).buffer.asUint8List();
//     largeIcon = ByteArrayAndroidBitmap(bigPicture);
//   }
//
//   AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
//     'hbr-global-channel', 'hbr-global-channel',
//     importance: Importance.high,
//     playSound: true,
//     priority: Priority.max,
//     // styleInformation: bigPictureStyleInformation,
//     largeIcon: largeIcon,
//     // actions: [
//     //   AndroidNotificationAction('id_1', 'name 1',
//     //       titleColor: AppColors.green, showsUserInterface: true),
//     //   AndroidNotificationAction('id_2', 'name 2',
//     //       titleColor: AppColors.red, showsUserInterface: true),
//     // ],
//   );
//
//   return NotificationDetails(
//     android: androidNotificationDetails,
//     iOS: const DarwinNotificationDetails(categoryIdentifier: 'app_categoryIdentifier'),
//   );
// }
//
// void notificationClickedHandler({required RemoteMessage message}) {
//   debugPrint('message:: ${message.data.toString()}');
//   getIt<NotificationService>().notificationClicked(
//       notificationId: message.data['Id'],
//       recordId: message.data['RecordId'],
//       type: int.parse(message.data['Type']));
// }
//
// void localNotificationClickedHandler({required NotificationResponse notificationResponse}) {
//   if (notificationResponse.payload != null) {
//     final messageData = json.decode(notificationResponse.payload!);
//     RemoteMessage message = RemoteMessage(data: messageData);
//     debugPrint('message-body: ${message.data['body']}');
//     debugPrint('message-RecordId: ${message.data['RecordId']}');
//     debugPrint('message-Image: ${message.data['Image']}');
//     debugPrint('message-Type: ${message.data['Type']}');
//     notificationClickedHandler(message: message);
//   }
// }
