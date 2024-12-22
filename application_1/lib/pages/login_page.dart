// import 'package:application_1/pages/home_page.dart';
import 'package:application_1/pages/main_screen.dart';
import 'package:application_1/pages/register_page.dart';
import 'package:application_1/utils/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:application_1/utils/theme.dart';
import 'package:toastification/toastification.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormFieldState> _usernameFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordFieldKey =
      GlobalKey<FormFieldState>();

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final response = await ApiService.login({
      'username': _usernameController.text,
      'password': _passwordController.text
    });

    if (response["success"]) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userData', jsonEncode(response['user']));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      toastification.show(
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        description: Text(response["message"], style: PrimaryFont.bold(18)),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 3),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: lowModeShadow,
        showProgressBar: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            kColorBluePrimary,
            kColorBlueSecondary,
          ],
        )),
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Sign in',
                        textAlign: TextAlign.center,
                        style: PrimaryFont.bold(28)
                            .copyWith(color: kColorBluePrimary),
                      ),
                      const SizedBox(height: 32),
                      _buildTextField(
                        controller: _usernameController,
                        label: 'Username',
                        icon: Icons.person,
                        fieldKey: _usernameFieldKey,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock,
                        obscureText: true,
                        fieldKey: _passwordFieldKey,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: kColorBluePrimary,
                        ),
                        child: Text(
                          'Sign in',
                          style: PrimaryFont.medium(18)
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: PrimaryFont.regular(16)
                                .copyWith(color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: PrimaryFont.bold(16)
                                  .copyWith(color: kColorBluePrimary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      required IconData icon,
      bool obscureText = false,
      required GlobalKey<FormFieldState> fieldKey}) {
    return TextFormField(
      key: fieldKey,
      controller: controller,
      obscureText: obscureText,
      onChanged: (value) {
        fieldKey.currentState?.validate(); // Chỉ validate ô này
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label can't be blank";
        }
        return null;
      },
      decoration: InputDecoration(
        label: RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
            children: const [
              TextSpan(
                text: ' *',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        prefixIcon: Icon(icon, color: kColorBluePrimary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kColorBluePrimary, width: 2),
        ),
      ),
    );
  }
}
