import 'package:da_song/account.dart';
import 'package:da_song/home.dart';
import 'package:da_song/search_track.dart';
import 'package:flutter/material.dart';
import 'package:da_song/services/auth.dart';
import 'package:da_song/screens/login_page/login_page.dart';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBar createState() => _BottomNavBar();
}
class _BottomNavBar extends State<BottomNavBar> {
  final AuthService _auth = AuthService();

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
    final List<Widget> tabs = [
    HomePost(),
    searchTrack(),
    Account(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: tabs.elementAt(_selectedIndex),
     
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              label: 'Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      );
  }
}
