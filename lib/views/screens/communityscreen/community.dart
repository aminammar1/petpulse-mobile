import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/util/post_item.dart';
import 'package:petpulse/provider/community_provider.dart';
import 'package:petpulse/provider/navigation_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'chat/liste_chat.dart';

class Community extends StatelessWidget {
  const Community({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<PostsProvider>(context).posts;
    final postprovider = Provider.of<PostsProvider>(context, listen: false);
    final callcontext = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            var navigationProvider =
                Provider.of<NavigationProvider>(context, listen: false);
            if (navigationProvider.currentIndex != 0) {
              navigationProvider.currentIndex = 0;
              navigationProvider.pageController.jumpToPage(0);
            } else {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            }
          },
        ),
        title: const Text("PetPulse Community "),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.filter_list,
            ),
            onPressed: () {
              postprovider.sortPostsByTime();
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          Map post = posts[index];
          return PostItem(
            img: post['img'],
            name: post['name'],
            dp: post['dp'],
            time: post['time'],
            index: index,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final picker = ImagePicker();
          final pickedFile =
              await picker.pickImage(source: ImageSource.gallery);

          if (pickedFile != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String userName = prefs.getString('firstName') ?? 'Anonymous';
            String userimage = prefs.getString('profile_image') ?? '';
            postprovider.addPostFromImage(pickedFile.path, userName, userimage);
          } else {
            callcontext.showSnackBar(
              const SnackBar(
                content: Text('No image selected'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
