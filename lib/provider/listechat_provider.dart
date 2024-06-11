import 'package:flutter/material.dart';
import 'package:petpulse/model/postdata.dart';
import 'dart:math';

class ConversationProvider with ChangeNotifier {
  late String name;
  late String avatarImage;
  final Random random = Random();
  List<Map> chats = [];
  List<Map> groups = [];

  ConversationProvider() {
    name = names[random.nextInt(names.length)];
    avatarImage = "assets/images/user${random.nextInt(10)}.jpeg";
    initProvider();
  }

  void initProvider() {
    initializeChats();
    initializeGroups();
  }

  void initializeChats() {
    chats = List.generate(
      13,
      (index) => {
        "name": names[random.nextInt(names.length)],
        "dp": "assets/images/user${random.nextInt(10)}.jpeg",
        "msg": messages[random.nextInt(messages.length)],
        "counter": random.nextInt(20),
        "time": "${random.nextInt(50)} min ago",
        "isOnline": random.nextBool(),
      },
    );
    notifyListeners();
  }

  void initializeGroups() {
    groups = List.generate(
      13,
      (index) => {
        "name": "Group ${index + 1}",
        "dp": "assets/images/user${random.nextInt(10)}.jpeg",
        "msg": messages[random.nextInt(messages.length)],
        "counter": random.nextInt(20),
        "time": "${random.nextInt(50)} min ago",
        "isOnline": random.nextBool(),
      },
    );
    notifyListeners();
  }

  void updateNameAndImage() {
    name = names[random.nextInt(names.length)];
    avatarImage = "assets/user${random.nextInt(10)}.jpeg";
    notifyListeners();
  }
}
