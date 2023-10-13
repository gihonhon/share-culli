import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'food_data.dart';

class CreateRecipeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CreateRecipeForm(),
      ),
    );
  }
}

class CreateRecipeForm extends StatefulWidget {
  @override
  _CreateRecipeFormState createState() => _CreateRecipeFormState();
}

class _CreateRecipeFormState extends State<CreateRecipeForm> {
  final TextEditingController nameController = TextEditingController();
  File? selectedImageFile; // New variable to store the selected image file
  final TextEditingController aboutFoodController = TextEditingController();
  final List<TextEditingController> stepsControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> ingredientsControllers = [
    TextEditingController()
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(nameController, 'Recipe Name'),
            SizedBox(height: 16.0),
            _buildImagePicker(),
            SizedBox(height: 16.0),
            _buildTextField(aboutFoodController, 'About Food', maxLines: 3),
            SizedBox(height: 16.0),
            _buildDynamicTextFields(stepsControllers, 'Steps'),
            SizedBox(height: 16.0),
            _buildDynamicTextFields(ingredientsControllers, 'Ingredients'),
            SizedBox(height: 16.0),
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
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
              child: Text(
                'Save Recipe',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      maxLines: maxLines,
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Image',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8.0),
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
                      : Text('No file selected'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    if (result != null) {
                      PlatformFile file = result.files.first;

                      print(file.name);
                      print(file.bytes);
                      print(file.size);
                      print(file.extension);
                      print(file.path);
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: Text('Pick Image'),
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
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8.0),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
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
                    icon: Icon(Icons.remove_circle, color: Colors.red),
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
          icon: Icon(Icons.add_circle, color: Colors.green),
          onPressed: () {
            setState(() {
              controllers.add(TextEditingController());
            });
          },
        ),
      ],
    );
  }

  void saveRecipe() {
    // Handle the selected image file (e.g., upload to a server or save locally)
    if (selectedImageFile != null) {
      // Handle the file as needed
      // Example: Upload the image file to a server
      // uploadImage(selectedImageFile);
    }

    // Clear form fields
    nameController.clear();
    selectedImageFile = null;
    aboutFoodController.clear();
    stepsControllers.forEach((controller) => controller.clear());
    ingredientsControllers.forEach((controller) => controller.clear());

    // Success popup
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Recipe created successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
