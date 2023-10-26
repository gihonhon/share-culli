import 'package:flutter/material.dart';

class FoodSearchPage extends StatelessWidget {
  const FoodSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Recipes'),
      ),
      body: Column(
        children: [
          // Search input field and button
          // Recommended food recipe list
          Expanded(
            child: ListView.builder(
              itemCount: recommendedRecipes.length,
              itemBuilder: (context, index) {
                final recipe = recommendedRecipes[index];
                return ListTile(
                  title: Text(recipe.title),
                  subtitle: Text(recipe.description),
                  // function to navigate to recipe details
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

// class for the recommended food recipes
class Recipe {
  final String title;
  final String description;

  Recipe({required this.title, required this.description});
}

// Sample data for recommended recipes
List<Recipe> recommendedRecipes = [
  Recipe(
    title: 'Spaghetti Carbonara',
    description: 'Creamy pasta with pancetta and eggs.',
  ),
  Recipe(
    title: 'Chicken Stir-Fry',
    description: 'Quick and easy chicken stir-fry with vegetables.',
  ),
];

class RecipeDetailsPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailsPage({super.key, required this.recipe});

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
            const Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(recipe.description),
          ],
        ),
      ),
    );
  }
}
