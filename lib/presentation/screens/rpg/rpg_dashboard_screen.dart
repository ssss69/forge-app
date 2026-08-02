import 'package:flutter/material.dart';

class RpgDashboardScreen extends StatelessWidget {
  const RpgDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('Your Journey', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              const Text('Level 4 - Iron Rank', style: TextStyle(color: Colors.white38, fontSize: 16)),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A26),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text('XP to next level', style: TextStyle(color: Colors.white54)),
                      Text('550 / 1000', style: const TextStyle(color: Color(0xFFD4A843), fontWeight: FontWeight.bold)),
                    ]),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.55,
                        backgroundColor: Colors.white.withOpacity(0.05),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4A843)),
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text('Skills', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              _buildSkill('Focus', 0.7, const Color(0xFF6C63FF)),
              _buildSkill('Productivity', 0.5, const Color(0xFFD4A843)),
              _buildSkill('Mindfulness', 0.3, const Color(0xFF4CAF50)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkill(String name, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(name, style: const TextStyle(color: Colors.white)),
            Text('${(value * 100).toInt()}%', style: const TextStyle(color: Colors.white54, fontSize: 12)),
          ]),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.white.withOpacity(0.05),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
