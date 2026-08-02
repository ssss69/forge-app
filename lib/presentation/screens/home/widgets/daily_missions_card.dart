import 'package:flutter/material.dart';

class DailyMissionsCard extends StatelessWidget {
  const DailyMissionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final missions = [
      {'title': 'Complete 3 tasks', 'xp': 50, 'done': true},
      {'title': '25 min focus session', 'xp': 75, 'done': false},
      {'title': 'Review daily notes', 'xp': 30, 'done': false},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A26),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Daily Missions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
              Text('+155 XP', style: TextStyle(color: const Color(0xFFD4A843), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ...missions.map((m) => _buildMissionItem(
            m['title'] as String,
            m['xp'] as int,
            m['done'] as bool,
          )),
        ],
      ),
    );
  }

  Widget _buildMissionItem(String title, int xp, bool done) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? const Color(0xFF4CAF50) : Colors.white.withOpacity(0.05),
            ),
            child: done ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: done ? Colors.white54 : Colors.white,
                decoration: done ? TextDecoration.lineThrough : null,
                fontSize: 14,
              ),
            ),
          ),
          Text('+$xp XP', style: const TextStyle(color: Color(0xFFD4A843), fontSize: 12)),
        ],
      ),
    );
  }
}
