import 'package:flutter/material.dart';
import 'home_screen.dart';

class SearchResultScreen extends StatelessWidget {
  final List<Map<String, dynamic>> searchResults;

  SearchResultScreen({required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final recipe = searchResults[index];
          return FoodRecipeCard(
            name: recipe['name'] ?? '',
            imageUrl: recipe['imageUrl'] ?? '',
            rating: recipe['rating'] ?? '',
            creator: recipe['creator'] ?? '',
            timeCreated: recipe['timeCreated'] ?? '',
            steps: recipe['steps'] ?? '',
            aboutFood: recipe['about_food'] ?? '',
            ingredients: recipe['ingredients'] ?? '',
          );
        },
      ),
    );
  }
}
