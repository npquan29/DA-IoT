import 'dart:convert';
import 'package:application_1/pages/login_page.dart';
import 'package:application_1/utils/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:application_1/utils/theme.dart';
import 'package:toastification/toastification.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  final _fullNameKey = GlobalKey<FormFieldState>();
  final _phoneKey = GlobalKey<FormFieldState>();
  final _ageKey = GlobalKey<FormFieldState>();

  late int userId; // Thêm biến lưu trữ id người dùng

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Hàm lấy dữ liệu người dùng từ SharedPreferences
  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userDataString = prefs.getString('userData');

    if (userDataString != null) {
      final Map<String, dynamic> userData = jsonDecode(userDataString);
      setState(() {
        userId = userData['id']; // Lưu id người dùng
        _fullNameController.text = userData['fullName'];
        _phoneController.text = userData['phone'];
        _ageController.text = userData['age'].toString();
      });
    }
  }

  // Hàm cập nhật thông tin người dùng
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedData = {
      'fullName': _fullNameController.text,
      'phone': _phoneController.text,
      'age': int.tryParse(_ageController.text) ?? 0,
    };

    final response = await ApiService.updateUserProfile(
      userId: userId,
      updatedData: updatedData,
    );

    if (response['success']) {
      // Cập nhật lại SharedPreferences với thông tin mới
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userData', jsonEncode(response['user']));

      toastification.show(
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        description: Text(response["message"], style: PrimaryFont.bold(18)),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 3),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: lowModeShadow,
        showProgressBar: false,
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

  // Hàm logout
  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Xóa toàn bộ dữ liệu trong SharedPreferences

    // Quay lại màn hình login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: PrimaryFont.bold(22)),
        backgroundColor: kColorBluePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  fieldKey: _fullNameKey,
                  controller: _fullNameController,
                  label: 'Full Name',
                  icon: Icons.person,
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
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _updateProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: kColorBluePrimary,
                  ),
                  child: Text(
                    'Save',
                    style: PrimaryFont.medium(18).copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    'Logout',
                    style: PrimaryFont.medium(18).copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget ô input
  Widget _buildTextField({
    required GlobalKey<FormFieldState> fieldKey,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      key: fieldKey,
      controller: controller,
      keyboardType: keyboardType,
      onChanged: (value) {
        fieldKey.currentState?.validate(); // Chỉ validate ô này
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: kColorBluePrimary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kColorBluePrimary, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label can\'t be blank';
        }
        return null;
      },
    );
  }
}
