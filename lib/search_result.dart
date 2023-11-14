import 'package:flutter/material.dart';
import 'home_screen.dart';

class SearchResultScreen extends StatelessWidget {
  final List<Map<String, dynamic>> searchResults;

  const SearchResultScreen({super.key, required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final recipe = searchResults[index];
          return FoodRecipeCard(
            id: recipe['id'],
            name: recipe['recipe_name'] ??
                '', // Use 'recipe_name' instead of 'name'
            imageUrl:
                recipe['picture'] ?? '', // Use 'picture' instead of 'imageUrl'
            rating: recipe['average_ratings'] ?? 0.0,
            creator: recipe['user']['username'] ?? '',
            timeCreated: DateTime.parse(recipe['createdAt'] ?? ''),
            steps: recipe['instruction'] ?? [],
            aboutFood:
                recipe['desc'] ?? '', // Use 'desc' instead of 'about_food'
            ingredients: recipe['ingredients'] ?? [],
          );
        },
      ),
    );
  }
}
