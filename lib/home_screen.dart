import 'package:flutter/material.dart';
import 'getFoodList.dart'; // Import your ApiService class
import 'search_result.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GetFoodList getFoodList =
      GetFoodList('https://639b216231877e43d6835f40.mockapi.io/linkedin/food');
  String searchQuery = ''; // store the search query

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
                  onPressed: () async {
                    try {
                      // Fetch data from the API based on the search query
                      List<Map<String, dynamic>> searchResults =
                          await getFoodList.fetchData();
                      searchResults = searchResults
                          .where((recipe) => recipe['name']
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()))
                          .toList();

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
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Map<String, dynamic>> foodRecipes =
                      snapshot.data as List<Map<String, dynamic>>;

                  return ListView.builder(
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
                        steps: recipe['steps'] ?? [],
                        aboutFood: recipe['about_food'] ?? '',
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
  final String timeCreated;
  final List<dynamic> steps; // Change to List<dynamic>
  final String aboutFood;
  final List<dynamic> ingredients; // Change to List<dynamic>

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
              steps: steps
                  .map((step) => step.toString())
                  .toList(), // Convert to List<String>
              aboutFood: aboutFood,
              ingredients: ingredients
                  .map((ingredient) => ingredient.toString())
                  .toList(), // Convert to List<String>
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10.0),
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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                    'By: $creator on $timeCreated',
                    style: TextStyle(
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
