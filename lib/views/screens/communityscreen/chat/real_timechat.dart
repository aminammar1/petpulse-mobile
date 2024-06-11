import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/provider/chat_provider.dart';
import 'package:petpulse/provider/community_provider.dart';
import 'chat_model.dart';
import 'package:image_picker/image_picker.dart';

class ChatInterface extends StatelessWidget {
  final int userIndex;

  const ChatInterface({super.key, required this.userIndex});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final postsProvider = Provider.of<PostsProvider>(context);
    final user = postsProvider.posts[userIndex];

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.initializeSocket(user['name']!);

    Future<void> sendImage(BuildContext context) async {
      final provider = Provider.of<ChatProvider>(context, listen: false);
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        provider.addImageMessage(
          user['name']!,
          pickedFile.path,
          user['dp']!,
          true,
        );
      }
    }

    return PopScope(
      canPop: true,
      onPopInvoked: (_) async {
        chatProvider.disconnectSocket(user['name']!);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(user['dp']!),
                radius: 20,
              ),
              const SizedBox(width: 8.0),
              Text(user['name']!),
              if (user['isOnline'] ?? false)
                const Icon(Icons.circle, color: Colors.green, size: 10),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, provider, child) {
                  final userMessages =
                      provider.getMessagesForUser(user['name']!);
                  final serverMessages = provider.getMessagesForUser('Server');
                  final messages = [...userMessages, ...serverMessages];
                  messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final userImage = message.username == 'Server'
                          ? 'assets/images/user1.jpeg'
                          : message.userImage;
                      return Chatmodel(
                        message: message.message,
                        time: 'Just now',
                        isMe: message.isMe,
                        isGroup: false,
                        username: message.username,
                        type: message.imageUrl.isEmpty ? 'text' : 'image',
                        replyText: '',
                        isReply: false,
                        replyName: '',
                        userImage: userImage,
                        isOnline: message.isOnline,
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.photo),
                    onPressed: () => sendImage(context),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Send a message',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final provider =
                          Provider.of<ChatProvider>(context, listen: false);
                      final message = ChatMessage(
                        message: controller.text,
                        isMe: true,
                        username: user['name']!,
                        userImage: user['dp']!,
                        isOnline: user['isOnline'] ?? true,
                        timestamp: DateTime.now(),
                      );
                      provider.sendMessage(message);
                      controller.clear();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
