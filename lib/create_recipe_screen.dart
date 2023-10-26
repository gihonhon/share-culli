import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateRecipeScreen extends StatelessWidget {
  const CreateRecipeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Recipe'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: CreateRecipeForm(),
      ),
    );
  }
}

class CreateRecipeForm extends StatefulWidget {
  const CreateRecipeForm({Key? key}) : super(key: key);

  @override
  _CreateRecipeFormState createState() => _CreateRecipeFormState();
}

class _CreateRecipeFormState extends State<CreateRecipeForm> {
  Map<String, dynamic>? userData;

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

  final TextEditingController nameController = TextEditingController();
  File? selectedImageFile; // Variable to store the selected image file
  final TextEditingController aboutFoodController = TextEditingController();
  final List<TextEditingController> stepsControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> ingredientsControllers = [
    TextEditingController()
  ];

  List<Map<String, String>> categories = [
    {
      "id": "clnxi17v30000zalwyu5uugig",
      "strCategory": "Beef",
    },
    {
      "id": "clnxi1x7o0001zalwc43xaw34",
      "strCategory": "Chicken",
    },
    {
      "id": "clnxi26ez0002zalwt5vxi291",
      "strCategory": "Dessert",
    },
    {
      "id": "clnxi2brm0003zalwaf0ytdt2",
      "strCategory": "Lamb",
    },
    {
      "id": "clnxi2hqv0004zalwxuri1bh9",
      "strCategory": "Miscellaneous",
    },
    {
      "id": "clnxi2mpl0005zalwsuk7iuht",
      "strCategory": "Pasta",
    },
    {
      "id": "clnxi2qh10006zalwinoyhdtx",
      "strCategory": "Pork",
    },
    {
      "id": "clnxi2uox0007zalwj38clpw3",
      "strCategory": "Seafood",
    },
    {
      "id": "clnxi2yty0008zalwym1sc4ia",
      "strCategory": "Side",
    },
    {
      "id": "clnxi33yt0009zalwcbh6k1t1",
      "strCategory": "Starter",
    },
    {
      "id": "clnxi38fa000azalw0h8ps3xs",
      "strCategory": "Vegan",
    },
    {
      "id": "clnxi3d2v000bzalwo9bc12sy",
      "strCategory": "Vegetarian",
    },
    {
      "id": "clnxi3kbv000czalwwjassnki",
      "strCategory": "Breakfast",
    },
    {
      "id": "clnxi3sjx000dzalwhvvpi1kx",
      "strCategory": "Goat",
    }
  ];

  String? selectedCategory;

  // String selectedCategory = ;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(nameController, 'Recipe Name'),
            const SizedBox(height: 16.0),
            _buildImagePicker(), // Added image picker
            const SizedBox(height: 16.0),
            _buildTextField(aboutFoodController, 'About Food', maxLines: 3),
            const SizedBox(height: 16.0),
            _buildDynamicTextFields(stepsControllers, 'Steps'),
            const SizedBox(height: 16.0),
            _buildDynamicTextFields(ingredientsControllers, 'Ingredients'),
            const SizedBox(height: 16.0),
            _buildCategoryDropdown(), // Add category dropdown
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                try {
                  saveRecipe();
                  print('Save Recipe Button Pressed');
                } catch (e) {
                  print('Error saving recipe: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Save Recipe',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Category',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8.0),
        DropdownButton<String>(
          value: selectedCategory,
          onChanged: (String? newValue) {
            setState(() {
              selectedCategory = newValue;
            });
          },
          items: categories.map((category) {
            return DropdownMenuItem<String>(
              value: category['id'],
              child: Text(category['strCategory']!),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      maxLines: maxLines,
    );
  }

  Future<void> _uploadImageToSupabase(File imageFile) async {
    // Replace 'yourBucketName' with your actual Supabase storage bucket name.
    final supabase = Supabase.instance.client;
    final filename = imageFile.path.split('/').last;

    try {
      await supabase.storage.from('images').upload(filename, imageFile,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false));
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final selectedImageFile = File(pickedFile.path);
      setState(() {
        this.selectedImageFile = selectedImageFile;
      });
      await _uploadImageToSupabase(selectedImageFile);
    }
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Image',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8.0),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: selectedImageFile != null
                      ? Text(
                          selectedImageFile!.path.split('/').last,
                          overflow: TextOverflow.ellipsis,
                        )
                      : const Text('No file selected'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Pick Image'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicTextFields(
      List<TextEditingController> controllers, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8.0),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controllers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTextField(controllers[index], '', maxLines: 1),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        controllers.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.add_circle, color: Colors.green),
          onPressed: () {
            setState(() {
              controllers.add(TextEditingController());
            });
          },
        ),
      ],
    );
  }

  void saveRecipe() async {
    // Handle the selected image file (e.g., upload to a server or save locally)
    final filename = selectedImageFile?.path.split('/').last;
    Map<String, dynamic> recipeData = {
      "userID": userData!['id'],
      "recipe_name": nameController.text,
      "desc": aboutFoodController.text,
      "instruction":
          stepsControllers.map((controller) => controller.text).toList(),
      "ingredients":
          ingredientsControllers.map((controller) => controller.text).toList(),
      "picture": selectedImageFile != null
          ? 'https://zkwmswfnbrfbsyqivmbk.supabase.co/storage/v1/object/public/images/$filename'
          : null,
      "categoryID": selectedCategory,
    };

    String jsonData = jsonEncode(recipeData);

    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    try {
      final response = await http.post(
        Uri.parse('https://fine-pink-badger-yoke.cyclic.app/recipes'),
        headers: headers,
        body: jsonData,
      );

      if (response.statusCode == 200) {
        print('Recipe created successfully!');
        showDialog(
          context: context, // Use the stored context here
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Recipe created successfully!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('Error creating recipe. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending POST request: $e');
    }

    // Clear form fields
    nameController.clear();
    selectedImageFile = null;
    aboutFoodController.clear();
    for (var controller in stepsControllers) {
      controller.clear();
    }
    for (var controller in ingredientsControllers) {
      controller.clear();
    }

    // Success popup
  }
}
