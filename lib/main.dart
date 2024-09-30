import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:owlearn/handlers/login/splashhandler.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Gemini.init(apiKey: 'AIzaSyDu9TAuqCWtybEnpcmNYNC1gY73r_dXePE');
  runApp(OwLearn());
}

class OwLearn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OwLearn',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(elevation: 5.0),
        useMaterial3: false
      ),
      home: SplashHandler(),
    );
  }
}