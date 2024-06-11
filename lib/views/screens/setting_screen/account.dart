import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/provider/accountmanage_provider.dart';
import 'package:petpulse/provider/userimg_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountManagement extends StatelessWidget {
  const AccountManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AccountManagementProvider>(
      create: (_) => AccountManagementProvider()..fetchUserInfo(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account Management'),
        ),
        body: Consumer2<AccountManagementProvider, ImageProviderModel>(
          builder: (context, provider, imageProvider, _) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        imageProvider.pickImage(ImageSource.gallery);
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: imageProvider.image != null
                            ? FileImage(imageProvider.image!)
                            : const AssetImage('assets/avatar.jpg')
                                as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: provider.firstNameController,
                      decoration:
                          const InputDecoration(labelText: 'First Name'),
                      onChanged: (value) => provider.setFirstName(value),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: provider.lastNameController,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      onChanged: (value) => provider.setLastName(value),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: provider.emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      onChanged: (value) => provider.setEmail(value),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: provider.passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            provider.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: provider.togglePasswordVisibility,
                        ),
                      ),
                      obscureText: !provider.isPasswordVisible,
                      onChanged: (value) => provider.setPassword(value),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        bool? confirmed = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Update'),
                            content: const Text(
                                'Are you sure you want to update your profile?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Yes'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String? userId = prefs.getString('userId');
                          if (userId != null) {       
                            await provider.updateUserInfo(userId, context);
                          }
                        }
                      },
                      child: const Text(
                        'Update Profile',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        bool? confirmed = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: const Text(
                                'Are you sure you want to delete your account?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Yes'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String? userId = prefs.getString('userId');
                          if (userId != null) {
                            await provider.deleteUser(userId, context);
                          }
                        }
                        
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text(
                        'Delete Profile',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
