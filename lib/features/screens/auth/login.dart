import 'package:bank/features/screens/auth/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/firebase_services/firestore_service.dart';
import '../../data/model/user_model.dart';
import '../../utils/generated/extensions.dart';
import '../../widgets/default_auth_text_field.dart';
import '../../widgets/password_text_field.dart';
import '../bottom_bar/bottom_nav.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final firebaseService = FirebaseService();
  String? emailError;
  String? passwordError;
  bool _isLoading = false;


  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> handleGoogleSignIn() async {
    try {
      setState(() => _isLoading = true);
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Google sign-in bekor qilindi')));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await _handleSuccessfulLogin(userCredential.user!);
      }
    } catch (e) {
      print("Google Sign-In error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google bilan kirishda xatolik')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSuccessfulLogin(User user) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('login', true);

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

  Future<void> _signInWithEmailPassword() async {
    setState(() {
      emailError = null;
      passwordError = null;
      _isLoading = true;
    });


    if (_emailController.text.isEmpty) {
      setState(() => emailError = "Email maydoni bo'sh");
      return;
    } else if (!isValidEmail(_emailController.text)) {
      setState(() => emailError = "Noto'g'ri formatdagi email");
      return;
    }

    if (_passwordController.text.isEmpty) {
      setState(() => passwordError = "Parol maydoni bo'sh");
      return;
    }

    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        await _handleSuccessfulLogin(userCredential.user!);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() => emailError = "Bunday email mavjud emas");
      } else if (e.code == 'wrong-password') {
        setState(() => passwordError = "Noto'g'ri parol");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Kirishda xatolik: ${e.message}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xatolik yuz berdi: $e')));
    } finally {
      setState(() => _isLoading = false);
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
            mainAxisAlignment: MainAxisAlignment.center,
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
              loginButtonAndOrDrop(_isLoading,_signInWithEmailPassword),
              signGoogleAndTextNav(_isLoading,handleGoogleSignIn,context)
            ],
          ),
        ),
      ),
    );
  }
}

loginButtonAndOrDrop(_isLoading, _signInWithEmailPassword){
  return Column(
    children: [
      SizedBox(height: 16),
      ElevatedButton(
        onPressed: _isLoading ? null : _signInWithEmailPassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          minimumSize: Size(double.infinity, 54),
        ),
        child: _isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
          "Login",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
    ],
  );
}
signGoogleAndTextNav(_isLoading, handleGoogleSignIn,context){
  return Column(
    children: [
      InkWell(
        onTap: _isLoading ? null : handleGoogleSignIn,
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
                  "Sign In with Google",
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
        children: [
          Text(
            "Don't have an account?",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: AppColor().grey,
            ),
          ),
          SizedBox(width: 12),
          InkWell(
            onTap: _isLoading
                ? null
                : () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignUp()),
            ),
            child: Text(
              "Sign Up",
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
  );
}
