import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatMessage {
  final String message;
  final String username;
  final String userImage;
  final bool isMe;
  final bool isOnline;
  final String imageUrl;
  final DateTime timestamp;

  ChatMessage({
    required this.message,
    required this.username,
    required this.userImage,
    required this.isMe,
    required this.isOnline,
    this.imageUrl = '',
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'],
      username: json['username'],
      userImage: json['userImage'],
      isMe: json['isMe'],
      isOnline: json['isOnline'],
      imageUrl: json['imageUrl'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'username': username,
      'userImage': userImage,
      'isMe': isMe,
      'isOnline': isOnline,
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class ChatProvider extends ChangeNotifier {
  final Map<String, List<ChatMessage>> _userMessages = {};
  late socket_io.Socket _socket;
  bool _isSocketInitialized = false;

  void initializeSocket(String username) {
    if (_isSocketInitialized) {
      _socket.emit('leaveRoom', username); // Leave the current room
    } else {
      _socket = socket_io.io('http://172.16.12.36:3000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      _socket.on('connect', (_) {
        debugPrint('Connected to socket server');
      });
      _socket.on('receiveMessage', (data) {
        final msg = ChatMessage.fromJson(data);
        addMessage(msg, notify: true);
      });
      _socket.on('disconnect', (_) {
        debugPrint('Disconnected from socket server');
      });
      _socket.connect();
      _isSocketInitialized = true;
    }
    _socket.emit('joinRoom', username); // Join the new room
  }

  void disconnectSocket(String username) {
    if (_isSocketInitialized) {
      _socket.emit('leaveRoom', username);
    }
  }

  Future<void> fetchMessages(String username) async {
    final response = await http.get(
        Uri.parse('http://172.16.12.36:3000/api/messages?username=$username'));
    if (response.statusCode == 200) {
      List<dynamic> messagesJson = json.decode(response.body);
      _userMessages[username] =
          messagesJson.map((json) => ChatMessage.fromJson(json)).toList();
      notifyListeners();
    }
  }

  List<ChatMessage> getMessagesForUser(String username) {
    return _userMessages[username] ?? [];
  }

  void addMessage(ChatMessage message, {bool notify = false}) {
    if (!_userMessages.containsKey(message.username)) {
      _userMessages[message.username] = [];
    }
    _userMessages[message.username]!.insert(0, message);
    if (notify) {
      notifyListeners();
    }
  }

  void sendMessage(ChatMessage message) {
    _socket.emit('sendMessage', message.toJson());
  }

  void addImageMessage(
      String username, String imagePath, String userImage, bool isMe) {
    final message = ChatMessage(
      message: imagePath,
      username: username,
      userImage: userImage,
      isMe: isMe,
      isOnline: true,
      imageUrl: imagePath,
      timestamp: DateTime.now(),
    );
    sendMessage(message);
  }
}
