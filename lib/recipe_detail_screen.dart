import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'add_comment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Comment {
  final String id;
  final String userID;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userID,
    required this.content,
    required this.createdAt,
  });
}

class RecipeDetailScreen extends StatefulWidget {
  final String id;
  final String name;
  final String imageUrl;
  final String rating;
  final String creator;
  final DateTime timeCreated;
  final List<String> steps;
  final String aboutFood;
  final List<String> ingredients;

  RecipeDetailScreen({
    required this.id,
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
  Map<String, dynamic>? userData;
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    _fetchComments();
    fetchAndDisplayUserData();
  }

  Future<void> fetchAndDisplayUserData() async {
    userData = await getStoredUserData();
    setState(() {});
  }

  Future<Map<String, dynamic>?> getStoredUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      return json.decode(userDataString);
    }
    return null;
  }

  String formattedDate() {
    final dateFormat = DateFormat('dd MMMM y');
    return dateFormat.format(widget.timeCreated);
  }

  String commentFormattedDate(DateTime createdAt) {
    final dateFormat = DateFormat('dd MMMM y');
    return dateFormat.format(createdAt);
  }

  Future<void> _fetchComments() async {
    final response = await http.get(
      Uri.parse(
          'https://fine-pink-badger-yoke.cyclic.app/comments/${widget.id}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final fetchedComments = jsonList.map((json) {
        return Comment(
          id: json['id'],
          userID: json['userID'],
          content: json['comment_content'],
          createdAt: DateTime.parse(json['createdAt']),
        );
      }).toList();

      setState(() {
        comments = fetchedComments;
      });
    }
  }

  Future<void> _refreshData() async {
    await _fetchComments();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Data refreshed!'),
    ));
  }

  void navigateToAddCommentScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddCommentScreen(widget.id),
      ),
    );
  }

  Future<void> addBookmark() async {
    // Define the URL for adding a bookmark
    final url = 'https://fine-pink-badger-yoke.cyclic.app/bookmarks';
    final userId = userData!['id'];

    final Map<String, dynamic> bookmarkData = {
      'userID': userId,
      'recipeID': widget.id,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bookmarkData),
    );

    if (response.statusCode == 201) {
      // Bookmark added successfully
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Recipe added to your bookmarks!'),
      ));
    }
    if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Recipe already in your bookmarks!'),
      ));
    } else {
      // Handle any error cases here
      print('Failed to add bookmark: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.bookmark_add),
            tooltip: 'Show Snackbar',
            onPressed: () {
              addBookmark();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_comment),
            onPressed: () {
              navigateToAddCommentScreen(context);
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 20.0,
                    bottom: 12.0,
                  ),
                  child: Text(widget.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 20.0,
                    bottom: 12.0,
                  ),
                  child: Text(widget.rating,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'by ${widget.creator} on ${formattedDate()}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.normal),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.article_outlined)),
                  Tab(icon: Icon(Icons.kitchen_outlined)),
                  Tab(icon: Icon(Icons.view_list_outlined)),
                  Tab(icon: Icon(Icons.speaker_notes_outlined)),
                ],
                labelColor: Colors.black,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: TabBarView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 16.0,
                      ),
                      child: Text(
                        widget.aboutFood,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: ListView(
                        children: widget.steps
                            .asMap()
                            .map(
                              (index, step) => MapEntry(
                                index,
                                ListTile(
                                  title: Text('Step ${index + 1}: $step'),
                                ),
                              ),
                            )
                            .values
                            .toList(),
                      ),
                    ),
                    ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        Comment comment = comments[index];
                        return ListTile(
                          title: Text(comment.content),
                          subtitle: Text(
                              'Posted on ${commentFormattedDate(comment.createdAt)}'),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
