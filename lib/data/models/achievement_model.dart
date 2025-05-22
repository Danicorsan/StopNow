import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Achievement {
  final String title;
  final String description;
  final Duration duration; // Tiempo necesario para desbloquear

  Achievement(this.title, this.description, this.duration);

  static List<Achievement> getLocalizedAchievements(AppLocalizations loc) {
    return [
      Achievement(
          loc.logro_1_title, loc.logro_1_desc, const Duration(minutes: 20)),
      Achievement(
          loc.logro_2_title, loc.logro_2_desc, const Duration(hours: 8)),
      Achievement(
          loc.logro_3_title, loc.logro_3_desc, const Duration(hours: 12)),
      Achievement(loc.logro_4_title, loc.logro_4_desc, const Duration(days: 1)),
      Achievement(loc.logro_5_title, loc.logro_5_desc, const Duration(days: 2)),
      Achievement(loc.logro_6_title, loc.logro_6_desc, const Duration(days: 3)),
      Achievement(loc.logro_7_title, loc.logro_7_desc, const Duration(days: 5)),
      Achievement(loc.logro_8_title, loc.logro_8_desc, const Duration(days: 7)),
      Achievement(
          loc.logro_9_title, loc.logro_9_desc, const Duration(days: 10)),
      Achievement(
          loc.logro_10_title, loc.logro_10_desc, const Duration(days: 14)),
      Achievement(
          loc.logro_11_title, loc.logro_11_desc, const Duration(days: 21)),
      Achievement(
          loc.logro_12_title, loc.logro_12_desc, const Duration(days: 30)),
      Achievement(
          loc.logro_13_title, loc.logro_13_desc, const Duration(days: 60)),
      Achievement(
          loc.logro_14_title, loc.logro_14_desc, const Duration(days: 90)),
      Achievement(
          loc.logro_15_title, loc.logro_15_desc, const Duration(days: 180)),
      Achievement(
          loc.logro_16_title, loc.logro_16_desc, const Duration(days: 365)),
      Achievement(
          loc.logro_17_title, loc.logro_17_desc, const Duration(days: 1825)),
      Achievement(
          loc.logro_18_title, loc.logro_18_desc, const Duration(days: 3650)),
      Achievement(
          loc.logro_19_title, loc.logro_19_desc, const Duration(days: 5475)),
    ];
  }
}

//TODO Gestionar las listas en español y en ingles.

