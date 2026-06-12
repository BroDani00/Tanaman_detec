// lib/utils/validators.dart

class Validators {
  // Validasi untuk nama (tidak boleh kosong, minimal 3 karakter)
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }
    if (value.trim().length > 50) {
      return 'Nama maksimal 50 karakter';
    }
    return null;
  }

  // Validasi untuk username (tidak boleh kosong, minimal 3 karakter, hanya huruf/angka/underscore)
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username tidak boleh kosong';
    }
    if (value.trim().length < 3) {
      return 'Username minimal 3 karakter';
    }
    if (value.trim().length > 30) {
      return 'Username maksimal 30 karakter';
    }
    final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value.trim())) {
      return 'Username hanya boleh huruf, angka, dan underscore';
    }
    return null;
  }

  // Validasi untuk password (minimal 6 karakter, ada huruf dan angka)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    if (value.length > 50) {
      return 'Password maksimal 50 karakter';
    }

    // Cek apakah password mengandung setidaknya satu huruf dan satu angka
    final bool hasLetter = value.contains(RegExp(r'[a-zA-Z]'));
    final bool hasNumber = value.contains(RegExp(r'[0-9]'));

    if (!hasLetter || !hasNumber) {
      return 'Password harus mengandung huruf dan angka';
    }
    return null;
  }

  // Validasi untuk konfirmasi password (harus sama dengan password)
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != password) {
      return 'Password tidak cocok';
    }
    return null;
  }

  // Validasi untuk email (format email yang valid)
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Masukkan email yang valid';
    }
    return null;
  }

  // Validasi untuk nomor telepon (minimal 10 digit, maksimal 13 digit)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    final RegExp phoneRegex = RegExp(r'^[0-9]{10,13}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Nomor telepon harus 10-13 digit angka';
    }
    return null;
  }

  // Validasi untuk angka (harus berupa angka positif)
  static String? validateNumber(String? value, {bool allowZero = true}) {
    if (value == null || value.isEmpty) {
      return 'Tidak boleh kosong';
    }
    final int? number = int.tryParse(value);
    if (number == null) {
      return 'Harus berupa angka';
    }
    if (!allowZero && number <= 0) {
      return 'Angka harus lebih dari 0';
    }
    if (allowZero && number < 0) {
      return 'Angka tidak boleh negatif';
    }
    return null;
  }

  // Validasi untuk luas lahan (hektar, bisa desimal)
  static String? validateLandArea(String? value) {
    if (value == null || value.isEmpty) {
      return 'Luas lahan tidak boleh kosong';
    }
    final double? area = double.tryParse(value);
    if (area == null) {
      return 'Harus berupa angka';
    }
    if (area <= 0) {
      return 'Luas lahan harus lebih dari 0';
    }
    if (area > 1000) {
      return 'Luas lahan maksimal 1000 hektar';
    }
    return null;
  }

  // Validasi untuk tidak boleh kosong
  static String? validateRequired(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  // Validasi untuk panjang karakter
  static String? validateLength(String? value, int minLength, int maxLength,
      {String fieldName = 'Field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    if (value.trim().length < minLength) {
      return '$fieldName minimal $minLength karakter';
    }
    if (value.trim().length > maxLength) {
      return '$fieldName maksimal $maxLength karakter';
    }
    return null;
  }

  // Validasi untuk memilih dari dropdown
  static String? validateDropdown<T>(T? value, {String fieldName = 'Pilihan'}) {
    if (value == null) {
      return '$fieldName harus dipilih';
    }
    return null;
  }
}
