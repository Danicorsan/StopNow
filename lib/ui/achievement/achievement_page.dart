import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/models/achievement_model.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).currentUser;
    final now = DateTime.now();
    final fechaDejarFumar = user?.fechaDejarFumar ?? now;
    final tiempoSinFumar = now.difference(fechaDejarFumar);

    int unlocked =
        achievements.where((a) => tiempoSinFumar >= a.duration).length;

    return Scaffold(
      drawer: baseDrawer(context),
      appBar: baseAppBar("Logros"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                Text(
                  "¡Has desbloqueado $unlocked de ${achievements.length} logros!",
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
                return Card(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
