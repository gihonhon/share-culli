import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'bookmark_screen.dart';
import 'create_recipe_screen.dart';
import 'user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  Map<String, dynamic>? userData;
  late ScreensList _screens;

  @override
  void initState() {
    super.initState();
    // Fetch and display user data from storage
    fetchAndDisplayUserData();
    _screens = ScreensList(userData: userData);
  }

  Future<void> fetchAndDisplayUserData() async {
    userData = await getStoredUserData();
    setState(() {});
  }

  Future<Map<String, dynamic>?> getStoredUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      return json.decode(userDataString);
    }
    return null;
  }

  // screens for each tab
  // final List<Widget> _screens = [
  //   // Home Tab
  //   const HomeScreen(),
  //   // Bookmarks Tab
  //   BookmarkScreen(userID: userData!.['id'],),
  //   // Create Recipe Tab
  //   const CreateRecipeScreen(),
  //   // Profile Tab
  //   const UserProfileScreen(),
  // ];

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
        body: _screens.getScreen(_currentIndex), // Display the selected screen
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

class ScreensList {
  final Map<String, dynamic>? userData;

  ScreensList({required this.userData});

  List<Widget> getScreens() {
    return [
      const HomeScreen(),
      BookmarkScreen(userID: userData?['id'] ?? ''),
      const CreateRecipeScreen(),
      const UserProfileScreen(),
    ];
  }

  Widget getScreen(int index) {
    return getScreens()[index];
  }
}
