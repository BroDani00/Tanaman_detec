import 'package:flutter/services.dart';
import 'dart:convert';
import '../data/models/disease_model.dart';
import '../core/constants/app_constans.dart';

/// Service untuk membaca dan mencari data penyakit dari JSON
class DiseaseService {
  List<DiseaseModel>? _diseases;
  bool _isLoaded = false;

  /// Mendapatkan status apakah data sudah dimuat
  bool get isLoaded => _isLoaded;

  /// Memuat data penyakit dari file JSON
  Future<void> loadDiseaseData() async {
    try {
      final jsonString =
          await rootBundle.loadString(AppConstants.diseaseDataPath);
      final List<dynamic> jsonList = json.decode(jsonString);

      _diseases = jsonList.map((json) => DiseaseModel.fromJson(json)).toList();
      _isLoaded = true;

      print(
          '✅ Data penyakit berhasil dimuat. ${_diseases?.length} penyakit tersedia');
    } catch (e) {
      print('❌ Gagal memuat data penyakit: $e');
      _isLoaded = false;
      rethrow;
    }
  }

  /// Mencari data penyakit berdasarkan label prediksi
  /// Mengembalikan DiseaseModel jika ditemukan, null jika tidak
  DiseaseModel? getDiseaseByLabel(String label) {
    if (!_isLoaded) {
      print('⚠️ Data penyakit belum dimuat');
      return null;
    }

    try {
      // Mencari data dengan label yang cocok
      final disease = _diseases?.firstWhere(
        (disease) => disease.label.toLowerCase() == label.toLowerCase(),
        orElse: () => _getDefaultDisease(),
      );

      return disease;
    } catch (e) {
      print('❌ Error mencari data penyakit: $e');
      return _getDefaultDisease();
    }
  }

  /// Mendapatkan data default jika label tidak ditemukan
  DiseaseModel _getDefaultDisease() {
    return DiseaseModel(
      label: 'unknown',
      tanaman: 'Tidak diketahui',
      penyakit: 'Tidak teridentifikasi',
      status: 'Unknown',
      deskripsi:
          'Maaf, informasi untuk penyakit ini belum tersedia dalam database.',
      gejala: ['Informasi tidak tersedia'],
      penyebab: ['Informasi tidak tersedia'],
      penanganan: ['Konsultasikan dengan penyuluh pertanian setempat'],
      pencegahan: ['Informasi tidak tersedia'],
    );
  }

  /// Mendapatkan semua data penyakit (untuk keperluan debugging)
  List<DiseaseModel> getAllDiseases() {
    return _diseases ?? [];
  }
}
