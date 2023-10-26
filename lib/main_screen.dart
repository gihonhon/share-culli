import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'bookmark_screen.dart';
import 'create_recipe_screen.dart';
import 'user_profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // screens for each tab
  final List<Widget> _screens = [
    // Home Tab
    const HomeScreen(),
    // Bookmarks Tab
    const BookmarkScreen(),
    // Create Recipe Tab
    const CreateRecipeScreen(),
    // Profile Tab
    const UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex == 0) {
          SystemNavigator.pop();
        } else {
          setState(() {
            _currentIndex = 0;
          });
        }
        return false;
      },
      child: Scaffold(
        body: _screens[_currentIndex], // Display the selected screen
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.redAccent,
          elevation: 0,
          selectedFontSize: 20,
          selectedIconTheme: const IconThemeData(size: 40),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
