import 'package:flutter/material.dart';
import 'coach_chat_screen.dart';

class CoachScreen extends StatelessWidget {
  const CoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
          alignment: Alignment.bottomLeft,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(Icons.auto_awesome, color: Color(0xFF6C63FF), size: 24),
                SizedBox(width: 8),
                Text('AI Coach', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              ]),
              SizedBox(height: 4),
              Text('Powered by Groq - free Llama 70B', style: TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
        ),
      ),
      body: const SafeArea(child: CoachChatScreen()),
    );
  }
}
