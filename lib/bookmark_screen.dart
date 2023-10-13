import 'package:flutter/material.dart';

class BookmarkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked Recipes'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: bookmarkedRecipes.length,
        itemBuilder: (context, index) {
          final recipe = bookmarkedRecipes[index];
          return InkWell(
            onTap: () {
              // Navigate to the detail screen or perform other actions
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Image.network(
                      recipe['imageUrl'],
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      recipe['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Assuming you have a list of bookmarked recipes
final List<Map<String, dynamic>> bookmarkedRecipes = [
    {
    'name': 'Spaghetti Carbonara',
    'imageUrl': 'https://www.culinaryhill.com/wp-content/uploads/2021/12/Spaghetti-Carbonara-Culinary-Hill-1200x800-1.jpg',
    'rating': 4.5, 
    'creator': 'John Doe', 
    'timeCreated': 'September 30, 2023', 
    'steps': [
      'Cook spaghetti according to package instructions.',
      'In a separate bowl, whisk together eggs, grated Parmesan cheese, and black pepper.',
      'Heat olive oil in a pan and add diced pancetta. Cook until crispy.',
      'Combine cooked spaghetti and pancetta, then stir in the egg and cheese mixture.',
      'Serve hot, garnished with additional Parmesan cheese and chopped parsley.'
    ],
    'about_food':
        'Spaghetti Carbonara is a classic Italian pasta dish made with eggs, cheese, pancetta, and black pepper. It is known for its creamy texture and rich flavor.',
    'ingredients': [
      '8 ounces spaghetti',
      '2 large eggs',
      '1 cup grated Parmesan cheese',
      '1/2 teaspoon black pepper',
      '2 tablespoons olive oil',
      '4 ounces diced pancetta',
      'Chopped parsley for garnish',
    ],
  },
  {
    'name': 'Chicken Alfredo',
    'imageUrl': 'https://www.budgetbytes.com/wp-content/uploads/2022/07/Chicken-Alfredo-bowl.jpg',
    'rating': 4.2, 
    'creator': 'Jane Smith', 
    'timeCreated': 'October 5, 2023', 
        'steps': [
      'Cook spaghetti according to package instructions.',
      'In a separate bowl, whisk together eggs, grated Parmesan cheese, and black pepper.',
      'Heat olive oil in a pan and add diced pancetta. Cook until crispy.',
      'Combine cooked spaghetti and pancetta, then stir in the egg and cheese mixture.',
      'Serve hot, garnished with additional Parmesan cheese and chopped parsley.'
    ],
    'about_food':
        'Spaghetti Carbonara is a classic Italian pasta dish made with eggs, cheese, pancetta, and black pepper. It is known for its creamy texture and rich flavor.',
    'ingredients': [
      '8 ounces spaghetti',
      '2 large eggs',
      '1 cup grated Parmesan cheese',
      '1/2 teaspoon black pepper',
      '2 tablespoons olive oil',
      '4 ounces diced pancetta',
      'Chopped parsley for garnish',
    ],
  },
    {
    'name': 'Vegetable Stir-Fry',
    'imageUrl': 'https://www.budgetbytes.com/wp-content/uploads/2022/03/Easy-Vegetable-Stir-Fry-close.jpg',
    'rating': 4.8,
    'creator': 'Alice Johnson',
    'timeCreated': 'August 25, 2023',
        'steps': [
      'Cook spaghetti according to package instructions.',
      'In a separate bowl, whisk together eggs, grated Parmesan cheese, and black pepper.',
      'Heat olive oil in a pan and add diced pancetta. Cook until crispy.',
      'Combine cooked spaghetti and pancetta, then stir in the egg and cheese mixture.',
      'Serve hot, garnished with additional Parmesan cheese and chopped parsley.'
    ],
    'about_food':
        'Spaghetti Carbonara is a classic Italian pasta dish made with eggs, cheese, pancetta, and black pepper. It is known for its creamy texture and rich flavor.',
    'ingredients': [
      '8 ounces spaghetti',
      '2 large eggs',
      '1 cup grated Parmesan cheese',
      '1/2 teaspoon black pepper',
      '2 tablespoons olive oil',
      '4 ounces diced pancetta',
      'Chopped parsley for garnish',
    ],
  },
  {
    'name': 'Chocolate Cake',
    'imageUrl': 'https://food-images.files.bbci.co.uk/food/recipes/easy_chocolate_cake_31070_16x9.jpg',
    'rating': 4.9,
    'creator': 'David Wilson',
    'timeCreated': 'July 12, 2023',
        'steps': [
      'Cook spaghetti according to package instructions.',
      'In a separate bowl, whisk together eggs, grated Parmesan cheese, and black pepper.',
      'Heat olive oil in a pan and add diced pancetta. Cook until crispy.',
      'Combine cooked spaghetti and pancetta, then stir in the egg and cheese mixture.',
      'Serve hot, garnished with additional Parmesan cheese and chopped parsley.'
    ],
    'about_food':
        'Spaghetti Carbonara is a classic Italian pasta dish made with eggs, cheese, pancetta, and black pepper. It is known for its creamy texture and rich flavor.',
    'ingredients': [
      '8 ounces spaghetti',
      '2 large eggs',
      '1 cup grated Parmesan cheese',
      '1/2 teaspoon black pepper',
      '2 tablespoons olive oil',
      '4 ounces diced pancetta',
      'Chopped parsley for garnish',
    ],
  },
  {
    'name': 'Grilled Salmon',
    'imageUrl': 'https://lh6.googleusercontent.com/-ggVe_2BPDEE/Tm1BAc3nbkI/AAAAAAAAEEQ/1Xpp-ofNFsA/s800/Teriyaki%252520Salmon%252520sauce.jpg',
    'rating': 4.7,
    'creator': 'Emily Brown',
    'timeCreated': 'September 10, 2023',
        'steps': [
      'Cook spaghetti according to package instructions.',
      'In a separate bowl, whisk together eggs, grated Parmesan cheese, and black pepper.',
      'Heat olive oil in a pan and add diced pancetta. Cook until crispy.',
      'Combine cooked spaghetti and pancetta, then stir in the egg and cheese mixture.',
      'Serve hot, garnished with additional Parmesan cheese and chopped parsley.'
    ],
    'about_food':
        'Spaghetti Carbonara is a classic Italian pasta dish made with eggs, cheese, pancetta, and black pepper. It is known for its creamy texture and rich flavor.',
    'ingredients': [
      '8 ounces spaghetti',
      '2 large eggs',
      '1 cup grated Parmesan cheese',
      '1/2 teaspoon black pepper',
      '2 tablespoons olive oil',
      '4 ounces diced pancetta',
      'Chopped parsley for garnish',
    ],
  },
  {
    'name': 'Caesar Salad',
    'imageUrl': 'https://assets.bonappetit.com/photos/624215f8a76f02a99b29518f/1:1/w_2800,h_2800,c_limit/0328-ceasar-salad-lede.jpg',
    'rating': 4.4,
    'creator': 'Michael Lee',
    'timeCreated': 'June 5, 2023',
        'steps': [
      'Cook spaghetti according to package instructions.',
      'In a separate bowl, whisk together eggs, grated Parmesan cheese, and black pepper.',
      'Heat olive oil in a pan and add diced pancetta. Cook until crispy.',
      'Combine cooked spaghetti and pancetta, then stir in the egg and cheese mixture.',
      'Serve hot, garnished with additional Parmesan cheese and chopped parsley.'
    ],
    'about_food':
        'Spaghetti Carbonara is a classic Italian pasta dish made with eggs, cheese, pancetta, and black pepper. It is known for its creamy texture and rich flavor.',
    'ingredients': [
      '8 ounces spaghetti',
      '2 large eggs',
      '1 cup grated Parmesan cheese',
      '1/2 teaspoon black pepper',
      '2 tablespoons olive oil',
      '4 ounces diced pancetta',
      'Chopped parsley for garnish',
    ],
  },
];
