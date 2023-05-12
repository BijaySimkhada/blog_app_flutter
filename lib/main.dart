import 'package:blog_application/modules/add_blog/screens/add_blog.dart';
import 'package:blog_application/modules/auth/screens/login_screen.dart';
import 'package:blog_application/modules/auth/screens/register_screen.dart';
import 'package:blog_application/modules/landing/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance;

    return MaterialApp(
      title: 'Flutter Demo for Blog Application',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return const MainScreen();
          }
          return const LoginScreen();
        },
      ),
      routes: {
        '/main_screen': (context) => const MainScreen(),
        '/add_blog':(context) => const AddBLogScreen(),
        '/register':(context) => const RegisterScreen(),
      },
    );
  }
}
