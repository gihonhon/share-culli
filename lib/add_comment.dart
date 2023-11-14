import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'recipe_detail_screen.dart';

class AddCommentScreen extends StatefulWidget {
  final String recipeId;

  AddCommentScreen(this.recipeId);

  @override
  _AddCommentScreenState createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  Map<String, dynamic>? userData;
  double rating = 0.0;
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch and display user data from storage
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

  Future<void> submitRating() async {
    final url =
        'https://fine-pink-badger-yoke.cyclic.app/ratings/${widget.recipeId}';
    final userId = userData!['id']; // Replace with the actual user ID

    final Map<String, dynamic> ratingData = {
      'userID': userId,
      'recipeID': widget.recipeId,
      'rating': rating,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json', // Set the content type to JSON
      },
      body: jsonEncode(ratingData), // Encode the data as JSON
    );

    if (response.statusCode == 201) {
      // Rating submitted successfully
      print('Rating submitted successfully');
    } else {
      // Handle the error, e.g., show an error message to the user
      print('Error submitting rating: ${response.statusCode}');
      // Handle specific error codes if needed
    }
  }

  Future<void> submitComment() async {
    final url = 'https://fine-pink-badger-yoke.cyclic.app/comments';
    final userId = userData!['id']; // Replace with the actual user ID
    final comment = commentController.text;

    final Map<String, dynamic> commentData = {
      'userID': userId,
      'recipeID': widget.recipeId,
      'comment_content': comment,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json', // Set the content type to JSON
      },
      body: jsonEncode(commentData), // Encode the data as JSON
    );

    if (response.statusCode == 201) {
      // Comment submitted successfully
      print('Comment submitted successfully');

      // Clear the comment input field
      commentController.clear();

      // Show a snackbar indicating success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Comment submitted successfully'),
        ),
      );
    } else {
      // Handle the error, e.g., show an error message to the user
      print('Error submitting comment: ${response.statusCode}');
      // Handle specific error codes if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Rating:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RatingBar.builder(
              initialRating: rating,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 40,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (newRating) {
                setState(() {
                  rating = newRating;
                });
              },
            ),
            Text(
              'Comment:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write your comment here...',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await submitRating(); // Submit rating
                await submitComment(); // Submit comment

                // Show a snackbar indicating success
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Comment submitted successfully'),
                  ),
                );
              },
              child: Text('Submit Comment'),
            ),
          ],
        ),
      ),
    );
  }
}
