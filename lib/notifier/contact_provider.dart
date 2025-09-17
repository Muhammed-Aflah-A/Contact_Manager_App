import 'package:contact_app/db/contact_db.dart';
import 'package:contact_app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;
  ThemeProvider() {
    loadTheme();
  }
  bool get isDark => _isDark;
  void toggleTheme() async {
    _isDark = !_isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDark", _isDark);
    notifyListeners();
  }

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool("isDark") ?? false;
    notifyListeners();
  }
}

class FormProvider with ChangeNotifier {
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final gmailController = TextEditingController();
  String? name;
  String? gmail;
  String? number;
  final numberFocus = FocusNode();
  final gmailFocus = FocusNode();
}

class SqlContactProvider with ChangeNotifier {
  final dbHelper = DataBaseHelper();
  SqlContactProvider() {
    fetchProfile();
  }
  List<User> _profiles = [];
  User? _selectedContact;
  List<User> get profile => _profiles;

  Future<void> addProfile(User user) async {
    await dbHelper.insertUser(user);
    fetchProfile();
  }

  Future<void> deleteProfile(int id) async {
    await dbHelper.deleteUser(id);
    fetchProfile();
  }

  Future<void> updateProfile(User user) async {
    await dbHelper.updateUser(user);
    fetchProfile();
    _selectedContact = user;
    notifyListeners();
  }

  Future<void> fetchProfile() async {
    _profiles = await dbHelper.getUser();
    notifyListeners();
  }

  User get selectedContact => _selectedContact!;
  void setSelectedContact(User user) {
    _selectedContact = user;
    notifyListeners();
  }
}
