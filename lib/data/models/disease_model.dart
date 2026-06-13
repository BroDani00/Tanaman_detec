/// Model class untuk menyimpan data penyakit dari JSON
class DiseaseModel {
  final String label;
  final String tanaman;
  final String penyakit;
  final String status;
  final String deskripsi;
  final List<String> gejala;
  final List<String> penyebab;
  final List<String> penanganan;
  final List<String> pencegahan;

  DiseaseModel({
    required this.label,
    required this.tanaman,
    required this.penyakit,
    required this.status,
    required this.deskripsi,
    required this.gejala,
    required this.penyebab,
    required this.penanganan,
    required this.pencegahan,
  });

  /// Factory method untuk membuat object dari JSON
  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      label: json['label'] ?? '',
      tanaman: json['tanaman'] ?? '',
      penyakit: json['penyakit'] ?? '',
      status: json['status'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      gejala: List<String>.from(json['gejala'] ?? []),
      penyebab: List<String>.from(json['penyebab'] ?? []),
      penanganan: List<String>.from(json['penanganan'] ?? []),
      pencegahan: List<String>.from(json['pencegahan'] ?? []),
    );
  }

  /// Method untuk mengkonversi object ke JSON
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'tanaman': tanaman,
      'penyakit': penyakit,
      'status': status,
      'deskripsi': deskripsi,
      'gejala': gejala,
      'penyebab': penyebab,
      'penanganan': penanganan,
      'pencegahan': pencegahan,
    };
  }
}
