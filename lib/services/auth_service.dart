// lib/services/auth_service.dart
import '../data/database/database_helper.dart';
import '../data/models/user_model.dart';
import 'storage_service.dart';

class AuthService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final StorageService _storage = StorageService();

  Future<bool> register(
      String username, String password, String fullName) async {
    final existingUser = await _dbHelper.getUserByUsername(username);
    if (existingUser != null) return false;

    final user = UserModel(
      username: username,
      password: password,
      fullName: fullName,
      createdAt: DateTime.now(),
    );

    final id = await _dbHelper.insertUser(user);
    return id > 0;
  }

  Future<bool> login(String username, String password) async {
    final user = await _dbHelper.login(username, password);

    if (user != null && user.id != null) {
      await _storage.saveUserSession(
        userId: user.id!,
        username: user.username,
        fullName: user.fullName,
      );
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _storage.clearUserSession();
  }

  bool get isLoggedIn => _storage.isLoggedIn;

  int? get currentUserId => _storage.userId;
  String? get currentUsername => _storage.username;
  String? get currentFullName => _storage.fullName;

  // Plant selection
  String get selectedPlant => _storage.selectedPlant;
  Future<void> setSelectedPlant(String plant) async =>
      await _storage.setSelectedPlant(plant);
}
