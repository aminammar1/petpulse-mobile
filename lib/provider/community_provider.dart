import 'package:flutter/material.dart';
import 'dart:math';

class PostsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _posts = [];

  final Random random = Random();
  List<Map<String, dynamic>> get posts => List.unmodifiable(_posts);

  PostsProvider() {
    initializePosts();
  }

  void initializePosts() {
    _posts = [
      {
        "name": "User1",
        "dp": "assets/images/user2.jpeg",
        "time":
            DateTime.now().subtract(Duration(minutes: random.nextInt(1000))),
        "img": "assets/images/cm1.jpeg",
        "isLiked": false,
        "likeCount": 0,
        "shareCount": 0,
        "friendsCount": random.nextInt(10000),
        "isFollowing": false,
        "isOnline": true,
      },
      {
        "name": "User2",
        "dp": "assets/images/user7.jpeg",
        "time":
            DateTime.now().subtract(Duration(minutes: random.nextInt(1000))),
        "img": "assets/images/cm7.jpeg",
        "isLiked": false,
        "likeCount": 0,
        "shareCount": 0,
        "friendsCount": random.nextInt(10000),
        "isFollowing": false,
        "isOnline": true,
      },
      {
        "name": "User3",
        "dp": "assets/images/user6.jpeg",
        "time":
            DateTime.now().subtract(Duration(minutes: random.nextInt(1000))),
        "img": "assets/images/cm3.jpeg",
        "isLiked": false,
        "likeCount": 0,
        "shareCount": 0,
        "friendsCount": random.nextInt(10000),
        "isFollowing": false,
        "isOnline": true,
      },
      {
        "name": "User4",
        "dp": "assets/images/user4.jpeg",
        "time":
            DateTime.now().subtract(Duration(minutes: random.nextInt(1000))),
        "img": "assets/images/cm4.jpeg",
        "isLiked": false,
        "likeCount": 0,
        "shareCount": 0,
        "friendsCount": random.nextInt(10000),
        "isFollowing": false,
        "isOnline": true,
      },
    ];
  }

  void toggleLike(int index) {
    _posts[index]["isLiked"] = !_posts[index]["isLiked"];
    if (_posts[index]["isLiked"]) {
      _posts[index]["likeCount"]++;
    } else {
      _posts[index]["likeCount"]--;
    }
    notifyListeners();
  }

  void incrementShare(int index) {
    if (_posts[index].containsKey("shareCount")) {
      _posts[index]["shareCount"]++;
    } else {
      _posts[index]["shareCount"] = 1;
    }
    notifyListeners();
  }

  void addPost(Map<String, dynamic> newPost) {
    _posts.add(newPost);
    notifyListeners();
  }

  void removePost(int index) {
    _posts.removeAt(index);
    notifyListeners();
  }

  void addPostFromImage(String imagePath, String userName, String userimage) {
    Map<String, dynamic> newPost = {
      "name": userName,
      "dp": userimage,
      "time": DateTime.now(),
      "img": imagePath,
      "isLiked": false,
      "likeCount": 0,
      "shareCount": 0,
      "friendsCount": random.nextInt(10000),
      "isFollowing": false,
    };
    addPost(newPost);
  }

  void sortPostsByTime() {
    _posts.sort((a, b) => b["time"].compareTo(a["time"]));
    notifyListeners();
  }

  void toggleFollow(String userName) {
    int index = _posts.indexWhere((post) => post['name'] == userName);
    if (index != -1) {
      _posts[index]["isFollowing"] = !_posts[index]["isFollowing"];
      if (_posts[index]["isFollowing"]) {
        _posts[index]["friendsCount"]++;
      } else {
        _posts[index]["friendsCount"]--;
      }
      notifyListeners();
    }
  }

  bool isFollowing(String userName) {
    int index = _posts.indexWhere((post) => post['name'] == userName);
    return index != -1 ? _posts[index]["isFollowing"] : false;
  }

  int getFriendsCount(String userName) {
    int index = _posts.indexWhere((post) => post['name'] == userName);
    return index != -1 ? _posts[index]["friendsCount"] : 0;
  }
}
