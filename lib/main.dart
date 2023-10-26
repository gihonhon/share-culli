import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  final String? authToken = prefs.getString('authToken');

  if (authToken != null) {
    // Check the validity of the token, e.g., by sending it to the server for verification.
    // If the token is still valid, return true; otherwise, return false.
    return true; // For this example, we assume the user is logged in if a token exists.
  }

  return false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://zkwmswfnbrfbsyqivmbk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inprd21zd2ZuYnJmYnN5cWl2bWJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTc2NTgxMjAsImV4cCI6MjAxMzIzNDEyMH0.2pievg17X5WH3q4jpItgmwkR1Le9njEayoxHojWSL-Y',
  );
  final bool isLoggedIn = await checkLoginStatus();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: isLoggedIn ? const MainScreen() : const LoginPage(),
    );
  }
}

final supabase = Supabase.instance.client;
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _obscurePassword = true;

//   void _togglePasswordVisibility() {
//     setState(() {
//       _obscurePassword = !_obscurePassword;
//     });
//   }

//   Future<void> storeTokenAndUserData(
//       String token, Map<String, dynamic> userData) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString('authToken', token);
//     prefs.setString('userData', json.encode(userData));
//   }

//   Future<Map<String, dynamic>?> getStoredUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? userDataString = prefs.getString('userData');
//     if (userDataString != null) {
//       return json.decode(userDataString);
//     }
//     return null;
//   }

//   void _login() async {
//     // login logic
//     String email = _emailController.text;
//     String password = _passwordController.text;
//     // _passwordController.text = username;
//     // print('Username: $username, Password: $password');
//     // bool loginSuccessful = true; // authentication logic
//     // if (loginSuccessful) {

//     // }

//     Map<String, String> loginData = {'email': email, 'password': password};

//     String requestBody = json.encode(loginData);

//     Map<String, String> headers = {
//       'Content-Type': 'application/json',
//     };

//     try {
//       final response = await http.post(
//           Uri.parse('https://fine-pink-badger-yoke.cyclic.app/auth/login'),
//           headers: headers,
//           body: requestBody);
//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         String token = responseData['token'];
//         Map<String, dynamic> userData = responseData['user'];
//         await storeTokenAndUserData(token, userData);

//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const MainScreen()),
//         );
//       } else {
//         print('Login failed: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Image.asset(
//                 'assets/icon_app.png',
//                 height: 100,
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Username',
//                   prefixIcon: Icon(Icons.person),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   prefixIcon: const Icon(Icons.lock),
//                   suffixIcon: IconButton(
//                     icon: Icon(_obscurePassword
//                         ? Icons.visibility
//                         : Icons.visibility_off),
//                     onPressed: _togglePasswordVisibility,
//                   ),
//                 ),
//                 obscureText: _obscurePassword,
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _login,
//                   child: const Text('Login'),
//                 ),
//               ),
//               Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     const Text('Does not have account?'),
//                     TextButton(
//                       child: const Text('Register now'),
//                       onPressed: () {
//                         // Register screen
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const RegisterPage()));
//                       },
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
