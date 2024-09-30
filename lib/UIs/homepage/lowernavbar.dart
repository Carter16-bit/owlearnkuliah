import 'package:flutter/material.dart';

class LowerNavigasi extends StatefulWidget {
  final ValueChanged<int> onTabChanged;
  final int selectedIndex;

  LowerNavigasi({required this.onTabChanged, required this.selectedIndex});

  @override
  _LowerNavigasiState createState() => _LowerNavigasiState();
}

class _LowerNavigasiState extends State<LowerNavigasi> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 10.0,
      currentIndex: widget.selectedIndex,
      onTap: widget.onTabChanged,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Menu Utama',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Pencarian',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.smart_toy),
          label: 'Testing AI',
        ),
      ],
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
    );
  }
}
