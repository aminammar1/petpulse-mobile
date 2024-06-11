// data.dart

List names = [
  "User1",
  "User2",
  "User3",
  "User4",
  "User5",
  "User6",
  "User7",
  "User8",
  "User9",
  "User10",
];

List messages = [
  "Hey, how are you doing?",
  "Are you available tomorrow?",
  "It's late. Go to bed!",
  "This cracked me up 😂😂",
];

List<Map<String, dynamic>> posts = [
  {
    "name": "User1",
    "dp": "assets/images/user1.jpeg",
    "time": "10 min ago",
    "img": "assets/images/post1.jpeg",
    "isLiked": false,
    "likeCount": 0,
    "shareCount": 0
  },
  {
    "name": "User2",
    "dp": "assets/images/user2.jpeg",
    "time": "20 min ago",
    "img": "assets/images/post2.jpeg",
    "isLiked": false,
    "likeCount": 0,
    "shareCount": 0
  },
  {
    "name": "User3",
    "dp": "assets/images/user3.jpeg",
    "time": "30 min ago",
    "img": "assets/images/post3.jpeg",
    "isLiked": false,
    "likeCount": 0,
    "shareCount": 0
  },
  {
    "name": "User4",
    "dp": "assets/images/user4.jpeg",
    "time": "40 min ago",
    "img": "assets/images/post4.jpeg",
    "isLiked": false,
    "likeCount": 0,
    "shareCount": 0
  },
];

List friends = [
  {
    "name": "User1",
    "dp": "assets/images/user1.jpeg",
    "status": "Anything could be here",
    "isAccept": true,
  },
  {
    "name": "User2",
    "dp": "assets/images/user2.jpeg",
    "status": "Anything could be here",
    "isAccept": true,
  },
  {
    "name": "User3",
    "dp": "assets/images/user3.jpeg",
    "status": "Anything could be here",
    "isAccept": true,
  },
  {
    "name": "User4",
    "dp": "assets/images/user4.jpeg",
    "status": "Anything could be here",
    "isAccept": true,
  },
];

List chats = [
  {
    "name": "User1",
    "dp": "assets/images/user1.jpeg",
    "msg": "Hey, how are you doing?",
    "counter": 5,
    "time": "10 min ago",
    "isOnline": true,
  },
  {
    "name": "User2",
    "dp": "assets/images/user2.jpeg",
    "msg": "Are you available tomorrow?",
    "counter": 10,
    "time": "20 min ago",
    "isOnline": true,
  },
  {
    "name": "User3",
    "dp": "assets/images/user3.jpeg",
    "msg": "It's late. Go to bed!",
    "counter": 15,
    "time": "30 min ago",
    "isOnline": true,
  },
  {
    "name": "User4",
    "dp": "assets/images/user4.jpeg",
    "msg": "This cracked me up 😂😂",
    "counter": 20,
    "time": "40 min ago",
    "isOnline": true,
  },
];

List groups = [
  {
    "name": "Group 1",
    "dp": "assets/images/group1.jpeg",
    "msg": "Hey, how are you doing?",
    "counter": 5,
    "time": "10 min ago",
    "isOnline": true,
  },
  {
    "name": "Group 2",
    "dp": "assets/images/group2.jpeg",
    "msg": "Are you available tomorrow?",
    "counter": 10,
    "time": "20 min ago",
    "isOnline": true,
  },
  {
    "name": "Group 3",
    "dp": "assets/images/group3.jpeg",
    "msg": "It's late. Go to bed!",
    "counter": 15,
    "time": "30 min ago",
    "isOnline": true,
  },
  {
    "name": "Group 4",
    "dp": "assets/images/group4.jpeg",
    "msg": "This cracked me up 😂😂",
    "counter": 20,
    "time": "40 min ago",
    "isOnline": true,
  },
];

List types = ["text", "image"];
List conversation = [
  {
    "username": "Group 1",
    "time": "10 min ago",
    "type": "text",
    "replyText": "Hey, how are you doing?",
    "isMe": true,
    "isGroup": false,
    "isReply": true,
  },
  {
    "username": "Group 2",
    "time": "20 min ago",
    "type": "image",
    "replyText": "Are you available tomorrow?",
    "isMe": false,
    "isGroup": false,
    "isReply": true,
  },
  {
    "username": "Group 3",
    "time": "30 min ago",
    "type": "text",
    "replyText": "It's late. Go to bed!",
    "isMe": true,
    "isGroup": false,
    "isReply": true,
  },
  {
    "username": "Group 4",
    "time": "40 min ago",
    "type": "image",
    "replyText": "This cracked me up 😂😂",
    "isMe": false,
    "isGroup": false,
    "isReply": true,
  },
];
