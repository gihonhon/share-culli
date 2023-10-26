import 'dart:ffi';

import 'package:flutter/material.dart';
import 'getFoodList.dart'; // Import your ApiService class
import 'search_result.dart';
import 'recipe_detail_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GetFoodList getFoodList =
      GetFoodList('https://fine-pink-badger-yoke.cyclic.app/recipes');
  String searchQuery = ''; // store the search query

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Culinary Share'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
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
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    try {
                      // Fetch data from the API based on the search query
                      List<
                          Map<String, dynamic>> searchResults = await GetFoodList(
                              'https://fine-pink-badger-yoke.cyclic.app/search/recipes/$searchQuery')
                          .fetchData();

                      // Navigate to search results screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SearchResultScreen(
                            searchResults: searchResults,
                          ),
                        ),
                      );
                    } catch (e) {
                      // Handle errors, e.g., show an error message
                      print('Error fetching data: $e');
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getFoodList.fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Map<String, dynamic>> foodRecipes =
                      snapshot.data as List<Map<String, dynamic>>;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: foodRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = foodRecipes[index];
                      return FoodRecipeCard(
                        name: recipe['recipe_name'] ?? '',
                        imageUrl: recipe['picture'] ?? '',
                        rating: recipe['average_ratings'] ?? 0.0,
                        creator: recipe['user']['username'] ?? '',
                        timeCreated: DateTime.parse(recipe['createdAt'] ?? ''),
                        steps: recipe['instruction'] ?? [],
                        aboutFood: recipe['desc'] ?? '',
                        ingredients: recipe['ingredients'] ?? [],
                      );
                    },
                  );
                }
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
  final DateTime timeCreated;
  final List<dynamic> steps; // Change to List<dynamic>
  final String aboutFood;
  final List<dynamic> ingredients; // Change to List<dynamic>

  const FoodRecipeCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.creator,
    required this.timeCreated,
    required this.steps,
    required this.aboutFood,
    required this.ingredients,
  }) : super(key: key);

  String formattedDate() {
    final dateFormat = DateFormat('dd MMMM y');
    return dateFormat.format(timeCreated);
  }

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
              rating: rating.toString(),
              creator: creator,
              timeCreated: timeCreated,
              steps: steps.map((step) => step.toString()).toList(),
              aboutFood: aboutFood,
              ingredients: ingredients
                  .map((ingredient) => ingredient.toString())
                  .toList(),
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'By: $creator on ${formattedDate()}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
