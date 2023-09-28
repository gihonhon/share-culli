import 'package:flutter/material.dart';
import 'food_data.dart';
import 'search_result.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = ''; // State variable to store the search query

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Culinary Share'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search Recipes',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Trigger navigation to search results screen here
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SearchResultScreen(
                          searchResults: foodRecipes
                              .where((recipe) => recipe['name']
                                  .toLowerCase()
                                  .contains(searchQuery.toLowerCase()))
                              .toList(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: foodRecipes.length,
              itemBuilder: (context, index) {
                final recipe = foodRecipes[index];
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
          ),
        ],
      ),
    );
  }
}

class FoodRecipeCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double rating;
  final String creator;
  final String timeCreated;
  final List<String> steps;
  final String aboutFood;
  final List<String> ingredients;

  FoodRecipeCard({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.creator,
    required this.timeCreated,
    required this.steps,
    required this.aboutFood,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the RecipeDetailScreen when the card is tapped
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(
              name: name,
              imageUrl: imageUrl,
              rating: rating,
              creator: creator,
              timeCreated: timeCreated,
              steps: steps,
              aboutFood: aboutFood,
              ingredients: ingredients,
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Created by: $creator',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '$timeCreated',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
