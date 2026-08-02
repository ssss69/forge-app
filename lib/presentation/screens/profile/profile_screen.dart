import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              CircleAvatar(
                radius: 48,
                backgroundColor: const Color(0xFF6C63FF).withOpacity(0.2),
                child: const Icon(Icons.person, size: 48, color: Color(0xFF6C63FF)),
              ),
              const SizedBox(height: 16),
              const Text('Forge User', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 4),
              const Text('Level 4 - Iron', style: TextStyle(color: Color(0xFFD4A843), fontSize: 14)),
              const SizedBox(height: 40),
              _buildMenuItem(Icons.stars_outlined, 'Achievements', '12 unlocked'),
              _buildMenuItem(Icons.bar_chart_rounded, 'Analytics', 'View insights'),
              _buildMenuItem(Icons.groups_outlined, 'Communities', '3 joined'),
              _buildMenuItem(Icons.settings_outlined, 'Settings', ''),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A26),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFD4A843)),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: subtitle.isNotEmpty ? Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)) : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.white24),
        onTap: () {},
      ),
    );
  }
}
