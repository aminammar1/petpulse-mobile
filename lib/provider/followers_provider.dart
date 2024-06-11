import 'package:flutter/material.dart';
import 'dart:math';
import 'package:petpulse/model/postdata.dart';

class FriendsProvider with ChangeNotifier {
  final Random random = Random();
  late List<Map<String, dynamic>> _friends;

  FriendsProvider() {
    _friends = List.generate(
      13,
      (index) => {
        "name": names[random.nextInt(10)],
        "dp": "assets/images/user${random.nextInt(10)}.jpeg",
        "status": "Anything could be here",
        "isAccept": random.nextBool(),
      },
    );
  }

  List<Map<String, dynamic>> get friendsList => _friends;

  void toggleFollowStatus(int index) {
    _friends[index]['isAccept'] = !_friends[index]['isAccept'];
    notifyListeners();
  }
}
