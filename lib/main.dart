import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:petpulse/provider/walk_provider.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/firebase_options.dart';
import 'provider/app_state.dart';
import 'provider/auth_provider.dart';
import 'package:petpulse/views/screens/splash_screen.dart';
import 'package:petpulse/views/screens/welcome_screen.dart';
import 'package:petpulse/views/widgets/navbar.dart';
import 'config/loading_config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'provider/notification_provider.dart';
import 'provider/activity_provider.dart';
import 'provider/userimg_provider.dart';
import 'provider/health_provider.dart';
import 'provider/Picture_Provider.dart';
import 'provider/navigation_provider.dart';
import 'provider/community_provider.dart';
import 'provider/listechat_provider.dart';
import 'provider/chat_provider.dart';
import 'provider/followers_provider.dart';
import 'provider/googleauth.dart';
import 'provider/accountmanage_provider.dart';
import 'provider/settingnotif_provider.dart';
import 'package:petpulse/provider/pet_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  configLoading();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => AuthModel()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
        ChangeNotifierProvider(create: (_) => WalkState()),
        ChangeNotifierProvider(create: (_) => ImageProviderModel()),
        ChangeNotifierProvider(create: (_) => HealthScreenProvider()),
        ChangeNotifierProvider(create: (_) => PetGalleryProvider()),
        ChangeNotifierProvider(create: (_) => PostsProvider()),
        ChangeNotifierProvider(create: (_) => ConversationProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => FriendsProvider()),
        ChangeNotifierProvider(create: (_) => AccountManagementProvider()),
        ChangeNotifierProvider(create: (_) => Notificationsettting()),
        ChangeNotifierProvider(create: (_) => PetProfileProvider()),
      ],
      child: MaterialApp(
        builder: EasyLoading.init(),
        home: Builder(
          builder: (context) => FutureBuilder<void>(
            future: Future.wait<void>([
              Provider.of<AppState>(context, listen: false)
                  .initialLoadComplete!,
              Provider.of<AuthModel>(context, listen: false).checkLoginStatus(),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return const InitialScreenSelector();
              } else {
                return const SplashScreen();
              }
            },
          ),
        ),
      ),
    );
  }
}

class InitialScreenSelector extends StatelessWidget {
  const InitialScreenSelector({super.key});

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
    AuthModel auth = Provider.of<AuthModel>(context);
    if (auth.isLoggedIn) {
      return const HomeScreen();
    }
    if (appState.isFirstTime && !auth.isLoggedIn) {
      return const SplashScreen();
    }
    return const WelcomeScreen();
  }
}
