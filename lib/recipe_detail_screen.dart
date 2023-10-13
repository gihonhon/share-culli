import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String name;
  final String imageUrl;
  final double rating;
  final String creator;
  final String timeCreated;
  final List<String> steps;
  final String aboutFood;
  final List<String> ingredients;

  RecipeDetailScreen({
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
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.bookmark_add),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Recipe Save to your Bookmark')));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.add_comment,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: DefaultTabController(
        length: 4, // Number of tabs
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 20.0,
                bottom: 12.0,
              ),
              child: Text(
                'About the Food',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.aboutFood,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
            ),
            // Create Tab Bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: TabBar(
                tabs: [
                  Tab(
                      icon: Icon(
                    Icons.article_outlined,
                  )),
                  Tab(
                    icon: Icon(
                      Icons.kitchen_outlined,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.view_list_outlined,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.speaker_notes_outlined,
                    ),
                  ),
                ],
                labelColor: Colors.black,
              ),
            ),

            // Create Tab Bar View
            Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14.0, vertical: 16.0),
                    child: Text(
                      widget.aboutFood,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  // Ingredients Tab
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: ListView(
                      children: widget.ingredients
                          .map((ingredient) => ListTile(
                                title: Text("- $ingredient"),
                              ))
                          .toList(),
                    ),
                  ),
                  // Steps Tab
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: ListView(
                      children: widget.steps
                          .asMap()
                          .map((index, step) => MapEntry(
                                index,
                                ListTile(
                                  title: Text('Step ${index + 1}: $step'),
                                ),
                              ))
                          .values
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: ListView(
                      children: const [
                        ListTile(
                          leading: CircleAvatar(child: Text('A')),
                          title: Text('Headline'),
                          subtitle: Text('Supporting text'),
                        ),
                        Divider(height: 0),
                        ListTile(
                          leading: CircleAvatar(child: Text('B')),
                          title: Text('Headline'),
                          subtitle: Text(
                              'Longer supporting text to demonstrate how the text wraps and how the leading and trailing widgets are centered vertically with the text.'),
                        ),
                        Divider(height: 0),
                        ListTile(
                          leading: CircleAvatar(child: Text('C')),
                          title: Text('Headline'),
                          subtitle: Text(
                              "Longer supporting text to demonstrate how the text wraps and how setting 'ListTile.isThreeLine = true' aligns leading and trailing widgets to the top vertically with the text."),
                          isThreeLine: true,
                        ),
                        Divider(height: 0),
                      ],
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
