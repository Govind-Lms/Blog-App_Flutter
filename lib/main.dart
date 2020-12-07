import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth_screens/screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Blog-App",
      theme: ThemeData(primaryColor: Colors.redAccent),
      routes: <String, WidgetBuilder>{
        'splashscreen': (BuildContext context) =>  SplashScreen(),
        'login': (BuildContext context) =>  Login(),
        'register':(BuildContext context) => Register(),
        'forgotpassword': (BuildContext context) => ForgotPassword(),
        'home': (BuildContext context) => Home(),
      },
      initialRoute: 'splashscreen',
    );
  }
}