import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/models/achievement_model.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/ui/achievement/achievement_detail.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Refresca cada segundo
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showAchievementDialog(
      BuildContext context,
      AchievementModel achievement,
      bool unlocked,
      Duration restante,
      AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (_) => AchievementDetailDialog(
        achievement: achievement,
        unlocked: unlocked,
        restante: restante,
        localizations: localizations,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).currentUser;
    final now = DateTime.now();
    final fechaDejarFumar = user?.fechaDejarFumar ?? now;
    final tiempoSinFumar = now.difference(fechaDejarFumar);
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final achievements =
        AchievementModel.getLocalizedAchievements(localizations);

    int unlocked =
        achievements.where((a) => tiempoSinFumar >= a.duration).length;

    return Scaffold(
      drawer: baseDrawer(context),
      appBar: baseAppBar(localizations.logros),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                Text(
                  localizations.hasDesbloqueadoLogros(
                      unlocked, achievements.length),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? const Color.fromARGB(255, 76, 141, 227)
                        : const Color(0xFF153866),
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: unlocked / achievements.length,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  color: const Color(0xFF608AAE),
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: achievements.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final achievement = achievements[index];
                final unlocked = tiempoSinFumar >= achievement.duration;
                final restante = unlocked
                    ? Duration.zero
                    : achievement.duration - tiempoSinFumar;
                return GestureDetector(
                  onTap: () => _showAchievementDialog(
                      context, achievement, unlocked, restante, localizations),
                  child: Card(
                    elevation: unlocked ? 6 : 2,
                    color: unlocked
                        ? isDarkMode
                            ? const Color.fromARGB(255, 33, 73, 36)
                            : Colors.green[50]
                        : isDarkMode
                            ? const Color.fromARGB(255, 35, 35, 35)
                            : Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: unlocked ? Colors.green : Colors.grey,
                        child: Icon(
                          unlocked ? Icons.emoji_events : Icons.lock_outline,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        achievement.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: unlocked
                              ? const Color.fromARGB(255, 1, 137, 10)
                              : Colors.grey[700],
                        ),
                      ),
                      subtitle: Text(
                        achievement.description,
                        style: TextStyle(
                          color: unlocked
                              ? isDarkMode
                                  ? Colors.white70
                                  : Colors.black
                              : Colors.grey[600],
                        ),
                      ),
                      trailing: unlocked
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
