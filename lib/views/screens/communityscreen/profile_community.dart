import 'package:flutter/material.dart';
import 'package:petpulse/provider/community_provider.dart';
import 'package:provider/provider.dart';
import 'chat/real_timechat.dart';
import 'followerslist.dart';

class Profile extends StatelessWidget {
  final String dp;
  final String name;
  final List<String> images;
  final int postsCount;
  final int initialFriendsCount;
  final int groupsCount;

  const Profile({
    super.key,
    required this.dp,
    required this.name,
    required this.images,
    this.postsCount = 0,
    required this.initialFriendsCount,
    this.groupsCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 60),
              CircleAvatar(
                backgroundImage: AssetImage(dp),
                radius: 50,
              ),
              const SizedBox(height: 10),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                "🐶🐱",
                style: TextStyle(),
              ),
              const SizedBox(height: 20),
              _actionButtons(context),
              const SizedBox(height: 40),
              _buildCategoryRow(context),
              const SizedBox(height: 20),
              _buildImageGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButtons(BuildContext context) {
    final postsProvider = Provider.of<PostsProvider>(context);
    final isFollowing = postsProvider.isFollowing(name);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            int userIndex =
                postsProvider.posts.indexWhere((post) => post['name'] == name);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatInterface(userIndex: userIndex),
            ));
          },
          child: const Icon(Icons.message, color: Colors.white),
        ),
        const SizedBox(width: 10),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: isFollowing ? Colors.grey : Colors.green,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            postsProvider.toggleFollow(name);
          },
          child: Text(
            isFollowing ? 'Unfollow' : 'Follow',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryRow(BuildContext context) {
    final postsProvider = Provider.of<PostsProvider>(context);
    final friendsCount = postsProvider.getFriendsCount(name);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildCategory(context, "Posts", postsCount),
          _buildCategory(context, "Friends", friendsCount, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Friends()),
            );
          }),
          _buildCategory(context, "Groups", groupsCount),
        ],
      ),
    );
  }

  Widget _buildCategory(BuildContext context, String title, int count,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Text(
            count.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      primary: false,
      padding: const EdgeInsets.all(5),
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 200 / 200,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.asset(
            images[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
