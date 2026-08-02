import 'package:flutter/material.dart';

class QuickStats extends StatelessWidget {
  const QuickStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Total XP', '2,450', const Color(0xFFD4A843), Icons.stars_rounded)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Streak', '7 days', const Color(0xFFFF6B35), Icons.local_fire_department_rounded)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Rank', 'Iron', const Color(0xFF6C63FF), Icons.shield_rounded)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
        ],
      ),
    );
  }
}
