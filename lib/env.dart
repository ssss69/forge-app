import 'dart:convert';
import 'package:flutter/foundation.dart';

class Env {
  static String groqApiKey = '';

  static void init() {
    const fromDefine = String.fromEnvironment('GROQ_API_KEY', defaultValue: '');
    if (fromDefine.isNotEmpty) {
      groqApiKey = fromDefine;
      debugPrint('[Forge] Groq API key loaded from --dart-define');
    } else {
      const fromEnv = String.fromEnvironment('GROQ_API_KEY', defaultValue: '');
      if (fromEnv.isNotEmpty) {
        groqApiKey = fromEnv;
      }
    }
  }
}
