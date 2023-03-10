import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
// import 'package:timezone/browser.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';
bool iswebPlatform = false;

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  /// Defines a iOS/MacOS notification category for plain actions.
  static const String? darwinNotificationCategoryPlain = 'plainCategory';
  // static const DarwinNotificationDetails darwinNotificationDetails =
  //     DarwinNotificationDetails(
  //   categoryIdentifier: darwinNotificationCategoryText,
  // );
  static Future _notificationDetails() async {
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain,
    );
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel descriptioon',
        importance: Importance.max,
      ),
      iOS: iosNotificationDetails,
      // iOS: IOSNotificationDetails(),
      // iOS:  IOSFlutterLocalNotificationsPlugin,
    );
  }

  // بعد النقر على زر الملاحظات في ستارة الاشعارات
  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      // onDidReceiveLocalNotification: (id, title, body, payload) => ,
    );

    final initializationSettings = InitializationSettings(
      android: android, // iOS: ios,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    // when app is closed
    NotificationAppLaunchDetails? details;
    if (iswebPlatform || Platform.isLinux) {
      details == null;
    } else
      details = await _notifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      onNotifications.add(details.notificationResponse!.payload);
    }

    //
    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            onNotifications.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              onNotifications.add(notificationResponse.payload);
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      // onSelectNotification: (payload) async {
      //   onNotifications.add(payload);
      // },
    );

    if (initScheduled) {
      if (iswebPlatform || Platform.isLinux) {
        return;
      }
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
      Future.delayed(
        Duration(seconds: 10),
        () async => await NotificationApi._scheduleDailyTenAMNotification(),
      );
    }
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );

  // الاشعارات في الخلفية
  static Future showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDate,
  }) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
  // الاشعارات في الخلفية كل يوم
  static Future showScheduledNotificationDaily({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDate,
  }) async {
    _notifications.zonedSchedule(
      id,
      title,
      body,
      _scheduleDaily(Time(1, 2)),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // الاشعارات في الخلفية الاسبوع
  static Future showScheduledNotificationWeekly({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDate,
  }) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        _scheduleWeekly(Time(8), days: [DateTime.monday, DateTime.tuesday]),
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
    );

    return scheduledDate.isBefore(now)
        ? scheduledDate.add(Duration(days: 1))
        : scheduledDate;
  }

  static tz.TZDateTime _scheduleWeekly(Time time, {required List<int> days}) {
    tz.TZDateTime scheduledDate = _scheduleDaily(time);

    while (!days.contains(scheduledDate.weekday)) {
      scheduledDate = scheduledDate.add(Duration(seconds: 1));
    }
    return scheduledDate;
  }

  // اشعار يومي عند الساعة عشر صباحا
  static Future<void> _scheduleDailyTenAMNotification() async {
    await _notifications.zonedSchedule(
      0,
      'شاهد العروض اليومية 😍',
      'متجر بديل الذهب اكسوارات راقية متميزة.. شاهد الان🥰😁',
      _nextInstanceOfTenAM(),
      await _notificationDetails(),
      payload: 'rice',
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, 17); //here 17 is for 17:00 AM
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

// run notification in evrey day
// https://stackoverflow.com/questions/68607890/flutter-local-notification-the-hour-of-the-day-expressed-as-in-a-24-hour-clock

tz.TZDateTime _nextInstanceOfTenAM() {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, 10); //here 10 is for 10:00 AM
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}


// https://stackoverflow.com/questions/71031037/how-to-schedule-multiple-time-specific-local-notifications-in-flutter
// https://stackoverflow.com/questions/63723467/daily-recurring-notifications-in-flutter

// https://www.raywenderlich.com/21458686-local-notifications-getting-started#toc-anchor-006