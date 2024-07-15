import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:voting_app/feature/candidateapply.dart';
import 'package:voting_app/feature/dashboard.dart';
import 'package:voting_app/feature/language.dart';
import 'package:voting_app/feature/login.dart';
import 'package:voting_app/feature/profileview.dart';
import 'package:voting_app/feature/votenow.dart';
import 'package:voting_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
      routes: {
        '/vote': (context) => const VoteNow(),
        '/candidate': (context) => const CandidateApply(),
        '/profile': (context) => const ProfileView(),
        '/language': (context) => const LanguageView(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return const Dashboard();
        }
        return const LoginView();
      },
    );
  }
}
