import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recycle/seller_home.dart';
import 'package:recycle/services/auth_service.dart';
import 'package:recycle/services/screens/login_screen.dart';
import 'package:recycle/services/screens/register_screen.dart';
import 'buyer_home.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReCycle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: Root(), // Root now lives under MaterialApp
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/seller_home': (_) => const SellerHome(),
        '/buyer_home': (_) => const BuyerHome(),
      },
    );
  }
}

class Root extends StatelessWidget {
  Root({super.key});
  final AuthService _auth = AuthService(); // make AuthService const if possible

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final user = snapshot.data;
        if (user == null) return const LoginScreen();

        // fetch role then show appropriate screen (show loading while fetching)
        return FutureBuilder<String?>(
          future: _auth.getUserRole(user.uid),
          builder: (context, roleSnap) {
            if (roleSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            final role = roleSnap.data;
            if (role == 'seller') return const SellerHome();
            return const BuyerHome();
          },
        );
      },
    );
  }
}
