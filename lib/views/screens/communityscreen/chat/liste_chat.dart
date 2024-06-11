/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/provider/listechat_provider.dart';
import 'chat_item.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConversationProvider>(
      create: (_) => ConversationProvider(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const TextField(
              decoration: InputDecoration.collapsed(hintText: 'Search'),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {},
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(text: "Message"),
                Tab(text: "Groups"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildMessagesTab(context),
              _buildGroupsTab(context),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesTab(BuildContext context) {
    return Consumer<ConversationProvider>(
      builder: (context, provider, child) {
        if (provider.chats.isEmpty) {
          return const Center(child: Text("No messages available."));
        }
        return ListView.builder(
          itemCount: provider.chats.length,
          itemBuilder: (context, index) {
            final chat = provider.chats[index];
            return ChatItem(
              dp: chat['dp'],
              name: chat['name'],
              isOnline: chat['isOnline'],
              counter: chat['counter'],
              msg: chat['msg'],
              time: chat['time'],
            );
          },
        );
      },
    );
  }

  Widget _buildGroupsTab(BuildContext context) {
    return Consumer<ConversationProvider>(
      builder: (context, provider, child) {
        if (provider.groups.isEmpty) {
          return const Center(child: Text("No groups available."));
        }
        return ListView.builder(
          itemCount: provider.groups.length,
          itemBuilder: (context, index) {
            final group = provider.groups[index];
            return ChatItem(
              dp: group['dp'],
              name: group['name'],
              isOnline: group['isOnline'],
              counter: group['counter'],
              msg: group['msg'],
              time: group['time'],
            );
          },
        );
      },
    );
  }
}*/
