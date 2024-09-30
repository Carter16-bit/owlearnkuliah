// Splash action dimana user bakal kelempar kalo datanya udah kesimpen👌
import 'package:flutter/material.dart';
import 'package:owlearn/UIs/homepage/mainpage.dart';
import 'package:owlearn/UIs/login/loginpage.dart';
import 'package:owlearn/handlers/authenticator/firebaseauthhandler.dart';

class SplashHandler extends StatefulWidget {
  @override
  _SplashHandlerState createState() => _SplashHandlerState();
}

class _SplashHandlerState extends State<SplashHandler> {
  final FirebaseAuthHandler _authHandler = FirebaseAuthHandler();

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    bool isLoggedIn = await _authHandler.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TextFormLogin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // gak terlalu guna juga sih wkwkwkw, tapi klo kuota abis bisa jadi sadar diri :)
      ),
    );
  }
}
