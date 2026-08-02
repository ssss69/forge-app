import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/coach_service.dart';

class CoachChatScreen extends ConsumerStatefulWidget {
  const CoachChatScreen({super.key});

  @override
  ConsumerState<CoachChatScreen> createState() => _CoachChatScreenState();
}

class _CoachChatScreenState extends ConsumerState<CoachChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final CoachService _coachService = CoachService();
  
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  RetryInfo? _lastRetry;
  StreamSubscription? _retrySub;

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage(
      text: 'Hello! I am your Forge AI Coach. How can I help you grow today?',
      isUser: false,
      type: MessageType.motivation,
    ));

    _retrySub = _coachService.onRetry.listen((info) {
      if (mounted) {
        setState(() => _lastRetry = info);
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _retrySub?.cancel();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true, type: MessageType.user));
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
      _lastRetry = null;
    });
    _messageController.clear();
    _scrollToBottom();

    try {
      final response = await _coachService.sendMessage(text);
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: response.text,
            isUser: false,
            type: response.messageType,
            retryInfo: response.retryInfo,
          ));
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Connection issue. Check your API key and internet.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_lastRetry != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 12, height: 12,
                  child: CircularProgressIndicator(strokeWidth: 1.5, color: Color(0xFFFF6B35)),
                ),
                const SizedBox(width: 6),
                Text(
                  'Retry #${_lastRetry!.attempt}',
                  style: const TextStyle(fontSize: 11, color: Color(0xFFFF6B35)),
                ),
              ],
            ),
          ),
        if (_hasError)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber, color: Colors.red, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(_errorMessage, style: const TextStyle(fontSize: 12, color: Colors.red))),
                TextButton(
                  onPressed: _sendMessage,
                  child: const Text('Retry', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _messages.length,
            itemBuilder: (context, index) => _buildMessageBubble(_messages[index]),
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text('Thinking...', style: TextStyle(color: Colors.white38, fontSize: 13, fontStyle: FontStyle.italic)),
          ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Ask your coach...',
                    hintStyle: const TextStyle(color: Colors.white24),
                    filled: true,
                    fillColor: const Color(0xFF1A1A26),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _isLoading ? null : _sendMessage,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD4A843),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send_rounded, color: Colors.black, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final isUser = msg.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFFD4A843).withOpacity(0.2) : const Color(0xFF1A1A26),
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isUser ? const Radius.circular(4) : null,
            bottomLeft: !isUser ? const Radius.circular(4) : null,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser && msg.type != MessageType.user)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      msg.type == MessageType.motivation ? Icons.whatshot :
                      msg.type == MessageType.insight ? Icons.lightbulb_outline :
                      Icons.play_arrow,
                      size: 14, color: msg.type == MessageType.motivation ? const Color(0xFFFF6B35) :
                      msg.type == MessageType.insight ? const Color(0xFF6C63FF) : const Color(0xFFD4A843),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      msg.type == MessageType.motivation ? 'Motivation' :
                      msg.type == MessageType.insight ? 'Insight' : 'Action',
                      style: TextStyle(
                        fontSize: 11,
                        color: msg.type == MessageType.motivation ? const Color(0xFFFF6B35) :
                        msg.type == MessageType.insight ? const Color(0xFF6C63FF) : const Color(0xFFD4A843),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            Text(
              msg.text,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.white87,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            if (!isUser && msg.retryInfo != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Attempt ${msg.retryInfo!.attemptsUsed} ${msg.retryInfo!.usedFallbackModel ? '(fallback)' : ''}',
                  style: const TextStyle(fontSize: 10, color: Colors.white24),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final MessageType type;
  final RetryInfo? retryInfo;

  ChatMessage({required this.text, required this.isUser, required this.type, this.retryInfo});
}

enum MessageType { user, motivation, insight, action }
