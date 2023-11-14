import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'recipe_detail_screen.dart';

class BookmarkScreen extends StatefulWidget {
  final String userID;

  BookmarkScreen({required this.userID});

  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<Map<String, dynamic>> bookmarkedRecipes = [];

  @override
  void initState() {
    super.initState();
    _fetchBookmarkedRecipes();
  }

  Future<void> _fetchBookmarkedRecipes() async {
    final response = await http.get(
      Uri.parse(
          'https://fine-pink-badger-yoke.cyclic.app/bookmarks/${widget.userID}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<Map<String, dynamic>> recipes = [];

      for (var data in jsonData) {
        final recipe = data['recipe'];
        recipes.add({
          'id': recipe['id'],
          'name': recipe['recipe_name'],
          'imageUrl': recipe['picture'],
          'rating': recipe['average_ratings'],
          'creator': recipe['userID'],
          'timeCreated': recipe['createdAt'],
          'steps': List<String>.from(recipe['instruction']),
          'about_food': recipe['desc'],
          'ingredients': List<String>.from(recipe['ingredients']),
        });
      }

      setState(() {
        bookmarkedRecipes = recipes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarked Recipes'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.only(top: 16.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: bookmarkedRecipes.length,
          itemBuilder: (context, index) {
            final recipe = bookmarkedRecipes[index];
            return InkWell(
              onTap: () {
                // Navigate to the detail screen or perform other actions
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(
                      id: recipe['id'],
                      name: recipe['recipe_name'] ?? '',
                      imageUrl: recipe['picture'] ?? '',
                      rating: ((recipe['average_ratings'] ?? 0.0).toDouble())
                          .toString(),
                      creator: recipe['user']['username'] ?? '',
                      timeCreated: DateTime.parse(recipe['createdAt'] ?? ''),
                      steps: List<String>.from(recipe['instruction']),
                      aboutFood: recipe['desc'],
                      ingredients: List<String>.from(recipe['ingredients']),
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      recipe['imageUrl'],
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    recipe['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
