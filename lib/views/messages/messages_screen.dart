import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_provider.dart';
import '../../viewmodels/rental_provider.dart';
import 'chat_detail_screen.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final rentalProvider = context.watch<RentalProvider>();
    final userId = authProvider.currentUser?.id;

    if (userId == null) {
      return const Scaffold(body: Center(child: Text('Авторизуйтесь, чтобы открыть чат')));
    }

    final messages = rentalProvider.getMessagesForUser(userId);
    final latestByPeer = <String, dynamic>{};
    for (final message in messages) {
      final peerId = message.fromUserId == userId ? message.toUserId : message.fromUserId;
      latestByPeer.putIfAbsent(peerId, () => message);
    }
    final chats = latestByPeer.entries.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: chats.isEmpty
          ? const Center(child: Text('Чатов пока нет'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: chats.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, index) {
                final peerId = chats[index].key.toString();
                final lastMessage = chats[index].value;
                final title = peerId == 'support' ? 'Support' : 'User $peerId';
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(title[0].toUpperCase()),
                    ),
                    title: Text(title),
                    subtitle: Text(
                      lastMessage.text.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatDetailScreen(
                            peerUserId: peerId,
                            peerTitle: title,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ChatDetailScreen(
                peerUserId: 'support',
                peerTitle: 'Support',
              ),
            ),
          );
        },
        icon: const Icon(Icons.chat),
        label: const Text('Новый чат'),
      ),
    );
  }
}
