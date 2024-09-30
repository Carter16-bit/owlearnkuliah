import 'package:flutter/material.dart';
import 'package:owlearn/UIs/gemini/chatpage.dart';
import 'package:owlearn/UIs/homepage/homepage.dart';
import 'package:owlearn/UIs/homepage/lowernavbar.dart';
import 'package:owlearn/UIs/profilepage/profilepage.dart';
import 'package:owlearn/UIs/searchpage/searchpage.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MenuRumah(),
    SearchPage(),
    ProfilePage(),
    const ChatPage(),
  ];

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Menampilkan halaman yang dipilih
      bottomNavigationBar: LowerNavigasi(
        onTabChanged: _onTabChanged,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
