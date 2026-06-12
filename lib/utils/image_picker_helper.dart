// lib/utils/constants.dart
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF92BBBF); // Warna utama dari panduan_cerdas
  static const primaryDark = Color(0xFF6A9FA3); // Versi lebih gelap
  static const white = Colors.white;
  static const black = Color(0xFF212121);
  static const grey = Color(0xFF757575);
  static const error = Color(0xFFD32F2F);
  static const success = Color(0xFF388E3C);
}

class AppTexts {
  static const appName = 'Tanaman Detect';
  static const doctorPlant = 'Doctor Plant';
  static const loginTitle = 'Selamat Datang';
  static const loginSubtitle = 'Masuk untuk melanjutkan';
  static const registerTitle = 'Buat Akun Baru';
  static const hintUsername = 'Username';
  static const hintPassword = 'Password';
  static const hintFullName = 'Nama Lengkap';
  static const loginButton = 'Masuk';
  static const registerButton = 'Daftar';
  static const noAccount = 'Belum punya akun? ';
  static const haveAccount = 'Sudah punya akun? ';
  static const registerNow = 'Daftar Sekarang';
  static const loginNow = 'Masuk';
}

class AppDatabase {
  static const databaseName = 'tanaman_detect.db';
  static const databaseVersion = 1;

  // Tabel users
  static const tableUsers = 'users';
  static const columnId = 'id';
  static const columnUsername = 'username';
  static const columnPassword = 'password';
  static const columnFullName = 'full_name';
  static const columnCreatedAt = 'created_at';

  // Tabel plants
  static const tablePlants = 'plants';
  static const columnUserId = 'user_id';
  static const columnPlantType = 'plant_type'; // padi, cabai, jagung
  static const columnPlantName = 'plant_name';
  static const columnPlantingDate = 'planting_date';
  static const columnNotes = 'notes';

  // Tabel scan_history
  static const tableScanHistory = 'scan_history';
  static const columnImagePath = 'image_path';
  static const columnDiagnosisResult = 'diagnosis_result';
  static const columnConfidence = 'confidence';
  static const columnScanDate = 'scan_date';
}
