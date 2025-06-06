import 'dart:developer';
import 'package:bank/features/data/model/user_model.dart';
import 'package:bank/features/screens/auth/login.dart';
import 'package:bank/features/screens/bottom_bar/bottom_nav.dart';
import 'package:bank/features/widgets/password_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/firebase_services/firestore_service.dart';
import '../../utils/generated/extensions.dart';
import '../../widgets/default_auth_text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final firebaseService = FirebaseService();

  String? emailError;
  String? passwordError;

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Google sign-in bekor qilindi')));
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        final sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setBool('login', true);

        final userModel = UserModel(
          uid: user.uid,
          userName: user.displayName ?? "No Name",
          email: user.email ?? "",
          balance: 0,
          createdAt: DateTime.now()
        );

        await firebaseService.saveUser(userModel);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNav()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Google bilan kirishda xatolik')));
    }
  }

  Future<User?> _signUpWithEmailPassword() async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
      return userCredential.user;
    } catch (e) {
      log("Sign up error: $e");
      return null;
    }
  }

  void _validateAndSubmit() async {
    setState(() {
      emailError = null;
      passwordError = null;
    });

    if (_emailController.text.isEmpty) {
      setState(() => emailError = "Maydon bo'sh");
      return;
    } else if (!isValidEmail(_emailController.text)) {
      setState(() => emailError = "Noto'g'ri formatdagi email");
      return;
    }

    if (_passwordController.text.length < 8) {
      setState(() => passwordError = "Kamida 8 ta belgi");
      return;
    }

    final sharedPreferences = await SharedPreferences.getInstance();
    User? user = await _signUpWithEmailPassword();
    if (user != null) {
      sharedPreferences.setBool('login', true);
      final userModel = UserModel(
        uid: user.uid,
        userName: "userName",
        email: user.email.toString(),
        balance: 0,
        createdAt: DateTime.now()
      );
      await firebaseService.saveUser(userModel);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign up error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().white,
      body: Padding(
        padding: const EdgeInsets.all(33.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Image.asset(
                'assets/icons/app_logo.png',
                width: 170,
                height: 170,
              ),
              SizedBox(height: 50),
              DefaultAuthTextField(
                controller: _emailController,
                errorText: emailError,
              ),
              const SizedBox(height: 16),
              PasswordTextField(
                controller: _passwordController,
                errorText: passwordError,
              ),
              const SizedBox(height: 26),
              ElevatedButton(
                onPressed: _validateAndSubmit,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Container(
                  alignment: Alignment(0, 0),
                  width: double.maxFinite,
                  height: 54,
                  decoration: BoxDecoration(),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    flex: 15,
                    child: Container(height: 1.3, color: AppColor().grey),
                  ),
                  SizedBox(width: 12),
                  Flexible(
                    flex: 5,
                    child: Text(
                      "Or",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor().grey,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Flexible(
                    flex: 15,
                    child: Container(height: 1.3, color: AppColor().grey),
                  ),
                ],
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  await handleGoogleSignIn();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor().grey, width: 0.3),
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/google.png',
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(width: 18),
                        Text(
                          "Sign Up with Google",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor().grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Do you have an account?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: AppColor().grey,
                    ),
                  ),
                  SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
