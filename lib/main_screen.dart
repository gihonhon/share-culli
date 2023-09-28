import 'package:flutter/material.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Index for the selected tab

  // Define the screens for each tab
  final List<Widget> _screens = [
    // Home Tab
    HomeScreen(),
    // Bookmarks Tab
    Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
      ),
      body: Container()
    ),
    // Create Recipe Tab
    Scaffold(
      appBar: AppBar(
        title: Text('Create Recipe'),
      ),
      body: Container()
    ),
    // Profile Tab
    Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container()
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.redAccent,
        elevation: 0,
        selectedFontSize: 20,
        selectedIconTheme: IconThemeData(size: 40),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected tab
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Create Recipe',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
