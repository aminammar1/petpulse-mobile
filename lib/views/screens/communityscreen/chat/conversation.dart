/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_model.dart';
import 'package:petpulse/model/postdata.dart';
import 'package:petpulse/provider/listechat_provider.dart';

class Conversation extends StatelessWidget {
  const Conversation({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConversationProvider(),
      child: Consumer<ConversationProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              elevation: 3,
              leading: IconButton(
                icon: const Icon(Icons.keyboard_backspace),
                onPressed: () => Navigator.pop(context),
              ),
              titleSpacing: 0,
              title: InkWell(
                onTap: provider.updateNameAndImage,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(provider.avatarImage),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            provider.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Online",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {},
                ),
              ],
            ),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: conversation.length,
                      reverse: true,
                      itemBuilder: (BuildContext context, int index) {
                        Map msg = conversation[index];
                        return Chatmodel(
                          message: msg['type'] == "text"
                              ? messages[
                                  provider.random.nextInt(messages.length)]
                              : "assets/images/cm${provider.random.nextInt(10)}.jpeg",
                          username: msg["username"],
                          time: msg["time"],
                          type: msg['type'],
                          replyText: msg["replyText"],
                          isMe: msg['isMe'],
                          isGroup: msg['isGroup'],
                          isReply: msg['isReply'],
                          replyName: provider.name,
                        );
                      },
                    ),
                  ),
                  // Bottom chat input area here
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} */
