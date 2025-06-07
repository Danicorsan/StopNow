import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AchievementModel {
  final String title;
  final String description;
  final Duration duration; // Tiempo necesario para desbloquear

  AchievementModel(this.title, this.description, this.duration);

  static List<AchievementModel> getLocalizedAchievements(AppLocalizations loc) {
    return [
      AchievementModel(
          loc.logro_1_title, loc.logro_1_desc, const Duration(minutes: 20)),
      AchievementModel(
          loc.logro_2_title, loc.logro_2_desc, const Duration(hours: 8)),
      AchievementModel(
          loc.logro_3_title, loc.logro_3_desc, const Duration(hours: 12)),
      AchievementModel(
          loc.logro_4_title, loc.logro_4_desc, const Duration(days: 1)),
      AchievementModel(
          loc.logro_5_title, loc.logro_5_desc, const Duration(days: 2)),
      AchievementModel(
          loc.logro_6_title, loc.logro_6_desc, const Duration(days: 3)),
      AchievementModel(
          loc.logro_7_title, loc.logro_7_desc, const Duration(days: 5)),
      AchievementModel(
          loc.logro_8_title, loc.logro_8_desc, const Duration(days: 7)),
      AchievementModel(
          loc.logro_9_title, loc.logro_9_desc, const Duration(days: 10)),
      AchievementModel(
          loc.logro_10_title, loc.logro_10_desc, const Duration(days: 14)),
      AchievementModel(
          loc.logro_11_title, loc.logro_11_desc, const Duration(days: 21)),
      AchievementModel(
          loc.logro_12_title, loc.logro_12_desc, const Duration(days: 30)),
      AchievementModel(
          loc.logro_13_title, loc.logro_13_desc, const Duration(days: 60)),
      AchievementModel(
          loc.logro_14_title, loc.logro_14_desc, const Duration(days: 90)),
      AchievementModel(
          loc.logro_15_title, loc.logro_15_desc, const Duration(days: 180)),
      AchievementModel(
          loc.logro_16_title, loc.logro_16_desc, const Duration(days: 365)),
      AchievementModel(
          loc.logro_17_title, loc.logro_17_desc, const Duration(days: 1825)),
      AchievementModel(
          loc.logro_18_title, loc.logro_18_desc, const Duration(days: 3650)),
      AchievementModel(
          loc.logro_19_title, loc.logro_19_desc, const Duration(days: 5475)),
    ];
  }
}
