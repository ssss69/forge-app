import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../env.dart';

class CoachService {
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String _primaryModel = 'llama3-70b-8192';
  static const String _fallbackModel = 'llama3-8b-8192';
  static const int _maxRetries = 4;
  static const Duration _requestTimeout = Duration(seconds: 30);

  final _retryController = StreamController<RetryInfo>.broadcast();
  Stream<RetryInfo> get onRetry => _retryController.stream;

  Future<CoachResponse> sendMessage(String message) async {
    String model = _primaryModel;
    int retryCount = 0;
    bool usedFallback = false;

    while (retryCount <= _maxRetries) {
      try {
        if (retryCount > 0) {
          _retryController.add(RetryInfo(attempt: retryCount, model: model));
        }

        final response = await http.post(
          Uri.parse(_baseUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${Env.groqApiKey}',
          },
          body: jsonEncode({
            'model': model,
            'messages': [
              {
                'role': 'system',
                'content': 'You are Forge AI Coach, a personal growth and productivity coach. Provide concise, actionable advice. Respond with 2-4 sentences. Occasionally tag your response type: [MOTIVATION], [INSIGHT], or [ACTION].'
              },
              {'role': 'user', 'content': message},
            ],
            'temperature': 0.7,
            'max_tokens': 300,
          }),
        ).timeout(_requestTimeout);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final content = data['choices'][0]['message']['content'] as String;
          final messageType = _parseMessageType(content);
          final cleanText = content.replaceAll(RegExp(r'\[(MOTIVATION|INSIGHT|ACTION)\]'), '').trim();

          return CoachResponse(
            text: cleanText,
            messageType: messageType,
            retryInfo: RetryInfo(
              attemptsUsed: retryCount + 1,
              usedFallbackModel: usedFallback,
              wasRateLimited: false,
              didTimeout: false,
              errorMessage: null,
              statusLabel: usedFallback ? 'Fallback model' : retryCount > 0 ? 'Retry #$retryCount' : 'Success',
            ),
          );
        } else if (response.statusCode == 429) {
          final retryAfter = _parseRetryAfter(response.headers['retry-after']);
          if (retryCount >= 2 && !usedFallback) {
            model = _fallbackModel;
            usedFallback = true;
          }
          await Future.delayed(Duration(milliseconds: retryAfter));
          retryCount++;
        } else {
          return CoachResponse(
            text: _getFallbackMessage(),
            messageType: MessageType.insight,
            retryInfo: RetryInfo(
              attemptsUsed: retryCount + 1,
              usedFallbackModel: usedFallback,
              wasRateLimited: false,
              didTimeout: false,
              errorMessage: 'HTTP ${response.statusCode}',
              statusLabel: 'Error ${response.statusCode}',
            ),
          );
        }
      } on TimeoutException {
        if (retryCount >= 2 && !usedFallback) {
          model = _fallbackModel;
          usedFallback = true;
        }
        await Future.delayed(_exponentialDelay(retryCount));
        retryCount++;
      } catch (e) {
        return CoachResponse(
          text: _getFallbackMessage(),
          messageType: MessageType.insight,
          retryInfo: RetryInfo(
            attemptsUsed: retryCount + 1,
            usedFallbackModel: usedFallback,
            wasRateLimited: false,
            didTimeout: false,
            errorMessage: e.toString(),
            statusLabel: 'Error',
          ),
        );
      }
    }

    return CoachResponse(
      text: _getOfflineFallback(),
      messageType: MessageType.insight,
      retryInfo: RetryInfo(
        attemptsUsed: _maxRetries + 1,
        usedFallbackModel: usedFallback,
        wasRateLimited: true,
        didTimeout: true,
        errorMessage: 'Max retries exceeded',
        statusLabel: 'Offline mode',
      ),
    );
  }

  Duration _exponentialDelay(int attempt) {
    final baseMs = pow(2, attempt).toInt() * 1000;
    final jitter = Random().nextDouble() * 0.4 - 0.2;
    return Duration(milliseconds: (baseMs * (1 + jitter)).toInt());
  }

  int _parseRetryAfter(String? header) {
    if (header == null) return 2000;
    final parsed = int.tryParse(header);
    if (parsed != null) return parsed * 1000;
    try {
      return DateTime.tryParse(header)?.millisecondsSinceEpoch ?? 2000;
    } catch (_) {
      return 2000;
    }
  }

  MessageType _parseMessageType(String content) {
    if (content.contains('[MOTIVATION]')) return MessageType.motivation;
    if (content.contains('[INSIGHT]')) return MessageType.insight;
    if (content.contains('[ACTION]')) return MessageType.action;
    return MessageType.insight;
  }

  String _getFallbackMessage() => 'Take a moment to reflect on your goals. What is one small step you can take right now?';

  String _getOfflineFallback() => 'I am having trouble connecting. Check your API key and internet connection, then try again.';

  void dispose() => _retryController.close();
}

class CoachResponse {
  final String text;
  final MessageType messageType;
  final RetryInfo retryInfo;

  CoachResponse({required this.text, required this.messageType, required this.retryInfo});
}

class RetryInfo {
  final int attemptsUsed;
  final bool usedFallbackModel;
  final bool wasRateLimited;
  final bool didTimeout;
  final String? errorMessage;
  final String statusLabel;
  final int attempt;

  RetryInfo({
    this.attemptsUsed = 0,
    this.usedFallbackModel = false,
    this.wasRateLimited = false,
    this.didTimeout = false,
    this.errorMessage,
    this.statusLabel = '',
    this.attempt = 0,
  });
}

enum MessageType { user, motivation, insight, action }
