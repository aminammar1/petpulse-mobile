import 'package:flutter/material.dart';
import 'package:petpulse/provider/community_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:petpulse/views/screens/communityscreen/profile_community.dart';
import 'dart:math';

class PostItem extends StatelessWidget {
  final String dp;
  final String name;
  final DateTime time;
  final String img;
  final int index;

  const PostItem({
    super.key,
    required this.dp,
    required this.name,
    required this.time,
    required this.img,
    required this.index,
  });

  void _shareContent(BuildContext context) {
    final postsProvider = Provider.of<PostsProvider>(context, listen: false);
    String content = 'Check out this post from $name on PetPulse!';
    postsProvider.incrementShare(index);
    Share.share(content, subject: 'PetPulse Post Shared!');
  }

  @override
  Widget build(BuildContext context) {
    final postsProvider = Provider.of<PostsProvider>(context);
    Map post = postsProvider.posts[index];
    ImageProvider<Object> imageProvider;
    ImageProvider<Object> dpProvider;
    String formattedTime = _formatTimeAgo(time);
    if (img.startsWith('/data') || img.startsWith('/storage')) {
      imageProvider = FileImage(File(img));
    } else {
      imageProvider = AssetImage(img);
    }
    if (dp.startsWith('/data') || dp.startsWith('/storage')) {
      dpProvider = FileImage(File(dp));
    } else {
      dpProvider = AssetImage(dp);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: dpProvider,
              ),
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                formattedTime,
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 11,
                ),
              ),
            ),
            Image(
              image: imageProvider,
              height: 170,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(post["isLiked"]
                        ? Icons.thumb_up
                        : Icons.thumb_up_alt_outlined),
                    color: post["isLiked"] ? Colors.lightGreen : null,
                    onPressed: () {
                      postsProvider.toggleLike(index);
                    },
                  ),
                  Text('${post["likeCount"]}'),
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () {
                      _shareContent(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      postsProvider.removePost(index);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Profile(
              dp: post['dp'],
              name: post['name'],
              images: List<String>.from(postsProvider.posts
                  .where((p) => p['name'] == post['name'])
                  .map((p) => p['img'])
                  .toList()),
              postsCount: postsProvider.posts
                  .where((p) => p['name'] == post['name'])
                  .length,
              initialFriendsCount: post['friendsCount'],
              groupsCount: Random().nextInt(10000),
            ),
          ));
        },
      ),
    );
  }

  String _formatTimeAgo(DateTime postTime) {
    final now = DateTime.now();
    final difference = now.difference(postTime);

    if (difference.inDays > 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} min ago';
    } else {
      return 'Just now';
    }
  }
}
