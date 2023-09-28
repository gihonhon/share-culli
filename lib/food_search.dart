import 'package:flutter/material.dart';

class FoodSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Recipes'),
      ),
      body: Column(
        children: [
          // Search input field and button
          // You can customize this part to fit your search functionality
          // Example: TextFields, Search Button, Filters, etc.

          // Recommended food recipe list
          Expanded(
            child: ListView.builder(
              itemCount: recommendedRecipes.length,
              itemBuilder: (context, index) {
                final recipe = recommendedRecipes[index];
                return ListTile(
                  title: Text(recipe.title),
                  subtitle: Text(recipe.description),
                  // Add onTap functionality to navigate to recipe details
                  onTap: () {
                    // Navigate to the recipe details page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailsPage(recipe: recipe),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Define a class for the recommended food recipes
class Recipe {
  final String title;
  final String description;

  Recipe({required this.title, required this.description});
}

// Sample data for recommended recipes (replace with your data)
List<Recipe> recommendedRecipes = [
  Recipe(
    title: 'Spaghetti Carbonara',
    description: 'Creamy pasta with pancetta and eggs.',
  ),
  Recipe(
    title: 'Chicken Stir-Fry',
    description: 'Quick and easy chicken stir-fry with vegetables.',
  ),
  // Add more recipe data as needed
];

class RecipeDetailsPage extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailsPage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(recipe.description),
            // Add more details about the recipe as needed
          ],
        ),
      ),
    );
  }
}
