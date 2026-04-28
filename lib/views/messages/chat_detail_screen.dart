import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_provider.dart';
import '../../viewmodels/rental_provider.dart';

class ChatDetailScreen extends StatefulWidget {
  final String peerUserId;
  final String peerTitle;

  const ChatDetailScreen({
    super.key,
    required this.peerUserId,
    required this.peerTitle,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final rentalProvider = context.watch<RentalProvider>();
    final userId = authProvider.currentUser?.id;

    if (userId == null) {
      return const Scaffold(body: Center(child: Text('Авторизуйтесь, чтобы открыть чат')));
    }

    final messages = rentalProvider
        .getMessagesForUser(userId)
        .where(
          (message) =>
              (message.fromUserId == userId && message.toUserId == widget.peerUserId) ||
              (message.fromUserId == widget.peerUserId && message.toUserId == userId),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.peerTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(child: Text('Начните переписку'))
                : ListView.separated(
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, index) {
                      final item = messages[index];
                      final mine = item.fromUserId == userId;
                      return Align(
                        alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 280),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: mine
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(item.text),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(hintText: 'Напишите сообщение...'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      if (_controller.text.trim().isEmpty) return;
                      rentalProvider.sendMessage(
                        fromUserId: userId,
                        toUserId: widget.peerUserId,
                        productId: 'general',
                        text: _controller.text,
                      );
                      _controller.clear();
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
