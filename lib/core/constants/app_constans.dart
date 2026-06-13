/// File konstanta untuk menyimpan nilai-nilai tetap yang digunakan di seluruh aplikasi
class AppConstants {
  // Ukuran input model (sesuaikan dengan model Anda)
  static const int modelInputSize = 224;

  // Path asset
  static const String modelPath = 'assets/models/plant_model.tflite';
  static const String labelsPath = 'assets/models/plant_label.txt';
  static const String diseaseDataPath = 'assets/data/disease_data.json';
  static const String placeholderImage = 'assets/images/placeholder.png';

  // Pesan error
  static const String errorLoadModel = 'Gagal memuat model AI';
  static const String errorLoadLabels = 'Gagal memuat label penyakit';
  static const String errorLoadDiseaseData = 'Gagal memuat data penyakit';
  static const String errorPredict = 'Gagal melakukan prediksi';
  static const String errorNoImage = 'Gambar tidak valid';
}
