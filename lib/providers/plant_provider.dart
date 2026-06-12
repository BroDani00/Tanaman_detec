// lib/providers/plant_provider.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../data/database/database_helper.dart';
import '../data/models/plant_model.dart';
import '../data/models/scan_history_model.dart';

class PlantProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  String _selectedPlant = 'cabai';
  List<PlantModel> _userPlants = [];
  List<ScanHistoryModel> _scanHistory = [];
  bool _isLoading = false;

  String get selectedPlant => _selectedPlant;
  List<PlantModel> get userPlants => _userPlants;
  List<ScanHistoryModel> get scanHistory => _scanHistory;
  bool get isLoading => _isLoading;

  // Plant display info
  Map<String, dynamic> get currentPlantInfo {
    switch (_selectedPlant) {
      case 'cabai':
        return {
          'name': 'Cabai',
          'icon': Icons.local_fire_department,
          'color': Colors.red,
          'imageAsset': 'assets/images/cabai.jpg',
        };
      case 'jagung':
        return {
          'name': 'Jagung',
          'icon': Icons.grass,
          'color': Colors.amber,
          'imageAsset': 'assets/images/jagung.jpg',
        };
      case 'padi':
        return {
          'name': 'Padi',
          'icon': Icons.eco,
          'color': Colors.green,
          'imageAsset': 'assets/images/padi.jpg',
        };
      default:
        return {
          'name': 'Cabai',
          'icon': Icons.local_fire_department,
          'color': Colors.red,
          'imageAsset': 'assets/images/cabai.jpg',
        };
    }
  }

  // Initialize - load selected plant from storage
  Future<void> init() async {
    _selectedPlant = _authService.selectedPlant;
    await loadUserPlants();
    await loadScanHistory();
    notifyListeners();
  }

  // Change selected plant
  Future<void> setSelectedPlant(String plant) async {
    if (_selectedPlant == plant) return;

    _selectedPlant = plant;
    await _authService.setSelectedPlant(plant);
    notifyListeners();
  }

  // Load user's plants from database
  Future<void> loadUserPlants() async {
    final userId = _authService.currentUserId;
    if (userId != null) {
      _userPlants = await _dbHelper.getPlantsByUserId(userId);
      notifyListeners();
    }
  }

  // Load scan history from database
  Future<void> loadScanHistory() async {
    final userId = _authService.currentUserId;
    if (userId != null) {
      _scanHistory = await _dbHelper.getScanHistoryByUserId(userId);
      notifyListeners();
    }
  }

  // Add new plant
  Future<void> addPlant(PlantModel plant) async {
    _setLoading(true);
    await _dbHelper.insertPlant(plant);
    await loadUserPlants();
    _setLoading(false);
  }

  // Save scan result
  Future<void> saveScanResult(ScanHistoryModel scan) async {
    await _dbHelper.insertScanHistory(scan);
    await loadScanHistory();
  }

  // Delete scan history
  Future<void> deleteScanHistory(int id) async {
    await _dbHelper.deleteScanHistory(id);
    await loadScanHistory();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Get content based on selected plant
  String getPlantSpecificContent(String contentType) {
    final plant = _selectedPlant;

    final Map<String, Map<String, String>> contents = {
      'cabai': {
        'cara_menanam': '''Cara Menanam Cabai yang Baik:
1. Persiapan Bibit: Pilih bibit cabai unggul. Rendam dalam air hangat selama 30 menit.
2. Semai Bibit: Semai di tray semai selama 2-3 minggu.
3. Persiapan Lahan: Gemburkan tanah, campur dengan pupuk kompos.
4. Pindah Tanam: Tanam bibit saat berumur 3-4 minggu dengan jarak 50x50 cm.
5. Penyiraman: Lakukan 2 kali sehari (pagi dan sore).
6. Pemupukan: Beri pupuk NPK setiap 2 minggu sekali.
7. Perawatan: Pasang ajir (tali rambatan) saat tanaman mulai tinggi.
8. Pengendalian Hama: Semprot pestisida alami jika diperlukan.''',
        'perawatan': '''Perawatan Tanaman Cabai:
• Siram secara teratur, jangan sampai terlalu basah
• Beri pupuk NPK (16-16-16) setiap 2 minggu
• Pangkas daun bagian bawah yang sudah tua
• Pasang mulsa plastik untuk mengontrol gulma
• Waspada hama ulat dan kutu daun
• Bersihkan gulma di sekitar tanaman
• Lakukan pengajiran agar tanaman tidak rebah
• Cabut tanaman yang terserang penyakit parah''',
        'cara_panen': '''Cara Panen Cabai:
• Cabai siap panen pada umur 75-90 hari setelah tanam
• Panen di pagi hari (pukul 07.00-09.00)
• Ciri cabai siap panen: warna merah merata, tekstur keras
• Gunakan gunting atau pisau tajam untuk memotong tangkai
• Jangan menarik buah langsung agar tidak merusak tanaman
• Panen setiap 5-7 hari sekali
• Hasil panen bisa mencapai 5-10 kg per pohon per musim''',
        'kalkulator_dosis':
            'Dosis pupuk cabai per m²: Urea 15g, SP-36 10g, KCl 10g',
      },
      'jagung': {
        'cara_menanam': '''Cara Menanam Jagung:
1. Persiapan Lahan: Bajak tanah sedalam 20-30 cm, buat bedengan.
2. Pemilihan Bibit: Pilih bibit jagung unggul (BISI, P21, Pertiwi).
3. Penanaman: Buat lubang sedalam 3-5 cm, jarak tanam 75x20 cm.
4. Masukkan 1-2 benih per lubang, tutup dengan tanah tipis.
5. Penyiraman: Lakukan segera setelah tanam, lalu sesuaikan dengan musim.
6. Pemupukan Dasar: Urea dan NPK saat tanam.
7. Penyulaman: Tanam ulang benih yang tidak tumbuh (7-14 hari).''',
        'perawatan': '''Perawatan Tanaman Jagung:
• Penyiangan: Bersihkan gulma pada umur 15 dan 30 hari
• Pembumbunan: Naikkan tanah di sekitar pangkal batang
• Pemupukan susulan: Urea saat umur 21 dan 42 hari
• Pengairan: Jangan sampai kekeringan saat pembentukan tongkol
• Waspada hama: Ulat grayak dan penggerek batang
• Waktu panen yang tepat meningkatkan kualitas biji''',
        'cara_panen': '''Cara Panen Jagung:
• Jagung siap panen pada umur 90-100 hari
• Ciri matang: rambut jagung berwarna coklat kering
• Kelobot (kulit) sudah mengering dan berwarna putih kecoklatan
• Panen dengan memutar tongkol lalu menariknya
• Panen di pagi hari untuk kadar air optimal
• Jangan panen saat hujan untuk menghindari jamur
• Hasil panen bisa mencapai 5-10 ton per hektar''',
        'kalkulator_dosis':
            'Dosis pupuk jagung per m²: Urea 20g, SP-36 15g, KCl 15g',
      },
      'padi': {
        'cara_menanam': '''Cara Menanam Padi:
1. Persemaian: Rendam benih 24 jam, semai selama 21-25 hari.
2. Pengolahan Tanah: Bajak dan garu hingga lumpur halus.
3. Penanaman: Tanam bibit umur 21 hari, jarak 25x25 cm.
4. Masukkan 2-3 bibit per lubang dengan kedalaman 1-2 cm.
5. Pengairan: Atur ketinggian air 1-5 cm secara berkala.
6. Pemupukan: Beri pupuk sesuai fase pertumbuhan.
7. Penyiangan: Cabut gulma manual atau herbisida.''',
        'perawatan': '''Perawatan Tanaman Padi:
• Atur pengairan sistem naik-turun
• Pemupukan: Urea pada umur 7, 21, 42, dan 60 HST
• SP-36 dan KCl diberikan pada umur 14 HST
• Waspada hama: wereng, penggerek batang, tikus
• Waspada penyakit: blas, hawar daun, tungro
• Lakukan penyemprotan pestisida jika diperlukan
• Jaga kebersihan saluran air dari gulma''',
        'cara_panen': '''Cara Panen Padi:
• Padi siap panen pada umur 105-120 hari
• Ciri matang: 90-95% gabah menguning
• Kadar air gabah sekitar 20-25%
• Panen dilakukan dengan sabit atau combine harvester
• Jangan panen terlalu muda (banyak hampa)
• Jangan terlalu tua (gabah mudah rontok)
• Hasil panen bisa mencapai 6-10 ton per hektar''',
        'kalkulator_dosis':
            'Dosis pupuk padi per m²: Urea 12g, SP-36 8g, KCl 8g',
      },
    };

    return contents[plant]?[contentType] ?? 'Informasi tidak tersedia';
  }
}
