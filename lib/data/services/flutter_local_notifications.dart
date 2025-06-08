import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:stopnow/data/models/achievement_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timezone/timezone.dart';

class AchievementsNotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notifications.initialize(settings);
  }

  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  static Future<void> scheduleAchievementNotifications({
    required DateTime fechaDejarFumar,
    required AppLocalizations localizations,
  }) async {
    await _notifications.cancelAll();

    final achievements =
        AchievementModel.getLocalizedAchievements(localizations);

    for (int i = 0; i < achievements.length; i++) {
      final achievement = achievements[i];
      TZDateTime fechaDejarFumarTZ =
          tz.TZDateTime.from(fechaDejarFumar, tz.local);
      TZDateTime scheduledDate = fechaDejarFumarTZ.add(achievement.duration);

      if (scheduledDate.isAfter(DateTime.now())) {
        await _notifications.zonedSchedule(
            i + 100, // Unique id
            "${localizations.logroCompletado}: ${achievement.title}",
            achievement.description,
            scheduledDate,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'achievements_channel',
                'Logros',
                channelDescription: 'Notificaciones de logros StopNow',
                importance: Importance.max,
                priority: Priority.high,
              ),
            ),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.dateAndTime);
      }
    }
  }
}
