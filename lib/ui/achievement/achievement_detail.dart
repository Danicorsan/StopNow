import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stopnow/data/models/achievement_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AchievementDetailDialog extends StatefulWidget {
  final AchievementModel achievement;
  final bool unlocked;
  final Duration restante;
  final AppLocalizations localizations;

  const AchievementDetailDialog({
    super.key,
    required this.achievement,
    required this.unlocked,
    required this.restante,
    required this.localizations,
  });

  @override
  State<AchievementDetailDialog> createState() =>
      _AchievementDetailDialogState();
}

class _AchievementDetailDialogState extends State<AchievementDetailDialog> {
  late Duration tiempoRestante;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    tiempoRestante = widget.restante;
    if (!widget.unlocked) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted && tiempoRestante.inSeconds > 0) {
          setState(() {
            tiempoRestante = tiempoRestante - const Duration(seconds: 1);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d, AppLocalizations localizations) {
    if (d.inSeconds <= 0) return localizations.yaDesbloqueado;
    final years = d.inDays ~/ 365;
    final days = d.inDays % 365;
    final hours = d.inHours % 24;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;
    List<String> parts = [];
    if (years > 0) parts.add("$years ${localizations.anios}");
    if (days > 0) {
      parts.add(days == 1
          ? "1 ${localizations.diaMinusculaSingular}"
          : "$days ${localizations.diasMinusculaPlural}");
    }
    if (hours > 0) {
      parts.add(hours == 1
          ? "1 ${localizations.horaMinusculaSingular}"
          : "$hours ${localizations.horasMinusculaPlural}");
    }
    if (minutes > 0) {
      parts.add(minutes == 1
          ? "1 ${localizations.minutoMinusculaSingular}"
          : "$minutes ${localizations.minutosMinusculaPlural}");
    }
    if (seconds > 0 && parts.isEmpty) {
      parts.add("$seconds ${localizations.segundos}");
    }
    return parts.join(" ");
  }

  @override
  Widget build(BuildContext context) {
    final unlocked = widget.unlocked || tiempoRestante.inSeconds <= 0;
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
              widget.achievement.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: unlocked ? Colors.green[900] : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              widget.achievement.description,
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
                    widget.localizations.teQuedaParaDesbloquearlo,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _formatDuration(tiempoRestante, widget.localizations),
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
                        widget.localizations.yaDesbloqueado,
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
              child: Text(widget.localizations.cerrar),
            ),
          ],
        ),
      ),
    );
  }
}
