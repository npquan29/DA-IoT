import 'package:application_1/pages/login_page.dart';
import 'package:application_1/utils/api_service.dart';
import 'package:flutter/material.dart';
import 'package:application_1/utils/theme.dart';
import 'package:toastification/toastification.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _usernameKey = GlobalKey<FormFieldState>();
  final _fullNameKey = GlobalKey<FormFieldState>();
  final _phoneKey = GlobalKey<FormFieldState>();
  final _ageKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final response = await ApiService.register({
      'username': _usernameController.text,
      'fullName': _fullNameController.text,
      'phone': _phoneController.text,
      'age': int.parse(_ageController.text),
      'password': _passwordController.text,
    });

    if (response["success"]) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
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
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const LoginScreen(),
    //   ),
    // );
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
          ),
        ),
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
                        'Sign up',
                        textAlign: TextAlign.center,
                        style: PrimaryFont.bold(28)
                            .copyWith(color: kColorBluePrimary),
                      ),
                      const SizedBox(height: 32),
                      _buildTextField(
                        fieldKey: _usernameKey,
                        controller: _usernameController,
                        label: 'Username',
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        fieldKey: _fullNameKey,
                        controller: _fullNameController,
                        label: 'Fullname',
                        icon: Icons.badge,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        fieldKey: _phoneKey,
                        controller: _phoneController,
                        label: 'Phone',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        fieldKey: _ageKey,
                        controller: _ageController,
                        label: 'Age',
                        icon: Icons.cake,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        fieldKey: _passwordKey,
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock,
                        obscureText: true,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: kColorBluePrimary,
                        ),
                        child: Text(
                          'Sign up',
                          style: PrimaryFont.medium(18)
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: PrimaryFont.regular(16)
                                .copyWith(color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign in',
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

  Widget _buildTextField({
    required GlobalKey<FormFieldState> fieldKey,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      key: fieldKey,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
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
