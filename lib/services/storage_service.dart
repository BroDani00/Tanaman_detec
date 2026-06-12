// lib/services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyUserId = 'current_user_id';
  static const String _keyUsername = 'current_username';
  static const String _keyFullName = 'current_full_name';
  static const String _keySelectedPlant = 'selected_plant';

  late SharedPreferences _prefs;
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // User session
  Future<void> saveUserSession(
      {required int userId,
      required String username,
      required String fullName}) async {
    await _prefs.setInt(_keyUserId, userId);
    await _prefs.setString(_keyUsername, username);
    await _prefs.setString(_keyFullName, fullName);
  }

  int? get userId => _prefs.getInt(_keyUserId);
  String? get username => _prefs.getString(_keyUsername);
  String? get fullName => _prefs.getString(_keyFullName);

  Future<void> clearUserSession() async {
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUsername);
    await _prefs.remove(_keyFullName);
  }

  bool get isLoggedIn => _prefs.containsKey(_keyUserId);

  // Selected plant (cabai, jagung, padi)
  String get selectedPlant => _prefs.getString(_keySelectedPlant) ?? 'cabai';

  Future<void> setSelectedPlant(String plant) async {
    await _prefs.setString(_keySelectedPlant, plant);
  }

  // Clear all
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
