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
    print('[Notificaciones] Cancelando notificaciones previas...');
    await _notifications.cancelAll();

    final achievements =
        AchievementModel.getLocalizedAchievements(localizations);
    print('[Notificaciones] Logros a programar: ${achievements.length}');

    for (int i = 0; i < achievements.length; i++) {
      final achievement = achievements[i];
      TZDateTime fechaDejarFumarTZ =
          tz.TZDateTime.from(fechaDejarFumar, tz.local);
      TZDateTime scheduledDate = fechaDejarFumarTZ.add(achievement.duration);

      print('[Notificaciones] Logro: ${achievement.title}');
      print('[Notificaciones] Fecha programada: $scheduledDate');

      if (scheduledDate.isAfter(DateTime.now())) {
        print(
            '[Notificaciones] Programando notificación para "${achievement.title}" en $scheduledDate');
        await _notifications.zonedSchedule(
            i + 100, // Unique id
            achievement.title,
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
      } else {
        print('[Notificaciones] No se programa porque la fecha ya pasó.');
      }
    }
    print('[Notificaciones] Programación de notificaciones finalizada.');
  }
}
