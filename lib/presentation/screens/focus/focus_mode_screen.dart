import 'package:flutter/material.dart';

class FocusModeScreen extends StatelessWidget {
  const FocusModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text('Focus Mode', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              const Text('Focus on what matters', style: TextStyle(color: Colors.white38, fontSize: 16)),
              const SizedBox(height: 60),
              Container(
                width: 220, height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF6C63FF), width: 4),
                  color: Colors.transparent,
                ),
                child: const Center(
                  child: Text('25:00', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 60),
              _buildModeButton('Start Session', const Color(0xFF6C63FF)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMiniButton('5 min', false),
                  const SizedBox(width: 10),
                  _buildMiniButton('25 min', true),
                  const SizedBox(width: 10),
                  _buildMiniButton('50 min', false),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(String label, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildMiniButton(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF6C63FF).withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: active ? const Color(0xFF6C63FF) : Colors.white24),
      ),
      child: Text(label, style: TextStyle(color: active ? const Color(0xFF6C63FF) : Colors.white54, fontSize: 13)),
    );
  }
}
