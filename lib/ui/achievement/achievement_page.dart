import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/models/achievement_model.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  String _formatDuration(Duration d, AppLocalizations localizations) {
    if (d.inSeconds <= 0) return localizations.yaDesbloqueado;
    final years = d.inDays ~/ 365;
    final days = d.inDays % 365;
    final hours = d.inHours % 24;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;
    List<String> parts = [];
    if (years > 0) parts.add("$years ${localizations.anios}");
    if (days > 0) parts.add("$days ${localizations.dias}");
    if (hours > 0) parts.add("$hours ${localizations.horas}");
    if (minutes > 0) parts.add("$minutes ${localizations.min}");
    if (seconds > 0 && parts.isEmpty) parts.add("$seconds ${"localizations.segundos"}");
    return parts.join(" ");
  }

  void _showAchievementDialog(BuildContext context, AchievementModel achievement, bool unlocked, Duration restante, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: unlocked ? Colors.green[50] : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: unlocked ? Colors.green : Colors.grey,
                  radius: 36,
                  child: Icon(
                    unlocked ? Icons.emoji_events : Icons.lock_outline,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  achievement.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: unlocked ? Colors.green[900] : Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  achievement.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: unlocked ? Colors.black : Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (!unlocked)
                  Column(
                    children: [
                      Text(
                        localizations.teQuedaParaDesbloquearlo,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _formatDuration(restante, localizations),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                if (unlocked)
                  Column(
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            localizations.yaDesbloqueado,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                        height: 6,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.green[300],
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(localizations.cerrar),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).currentUser;
    final now = DateTime.now();
    final fechaDejarFumar = user?.fechaDejarFumar ?? now;
    final tiempoSinFumar = now.difference(fechaDejarFumar);
    final localizations = AppLocalizations.of(context)!;

    final achievements = AchievementModel.getLocalizedAchievements(localizations);

    int unlocked = achievements.where((a) => tiempoSinFumar >= a.duration).length;

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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF153866),
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
                    color: unlocked ? Colors.green[50] : Colors.grey[200],
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
                          color: unlocked ? Colors.green[900] : Colors.grey[700],
                        ),
                      ),
                      subtitle: Text(
                        achievement.description,
                        style: TextStyle(
                          color: unlocked ? Colors.black : Colors.grey[600],
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
