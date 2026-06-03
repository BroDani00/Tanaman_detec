import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PanduanCerdas extends StatelessWidget {
  const PanduanCerdas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false, // Menghilangkan padding atas untuk full screen
        child: Column(
          children: [
            // Area konten scrollable dengan background hijau & border radius
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: const Color(0xFF92BBBF),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(),
                      _buildSearchBar(),
                      _buildPlantIcons(),
                      _buildIndicator(),
                      _buildOptionCardsRow1(context),
                      _buildOptionCardsRow2(context),
                      _buildScanBanner(context),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom navigation FIXED di paling bawah
            _buildBottomNav(context),
          ],
        ),
      ),
    );
  }

  // ======================  Helper gambar network dengan placeholder  ======================
  Widget _networkImage(String url, {double? width, double? height}) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: Icon(Icons.image_not_supported, size: (width ?? 40) * 0.6),
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: Center(
            child: SizedBox(
              width: (width ?? 40) * 0.5,
              height: (height ?? 40) * 0.5,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
    );
  }

  // ======================  Header ======================
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 40,
        left: 17,
        right: 17,
      ), // top:20 (dari 62)
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              _networkImage(
                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/tq3bKFNRWd/lxqrsyrg_expires_30_days.png",
                width: 54,
                height: 57,
              ),
              const Positioned(
                bottom: 2,
                left: 46,
                child: Text(
                  "Doctor Plant",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          _networkImage(
            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/tq3bKFNRWd/o186nut0_expires_30_days.png",
            width: 25,
            height: 25,
          ),
          const SizedBox(width: 10),
          _networkImage(
            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/tq3bKFNRWd/uk0vrgbp_expires_30_days.png",
            width: 30,
            height: 30,
          ),
        ],
      ),
    );
  }

  // ======================  Search bar ======================
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.only(top: 27, bottom: 33, left: 20, right: 20),
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Cari",
            style: TextStyle(color: Color(0xFF92BBBF), fontSize: 18),
          ),
          Text(
            "Pilih tanaman mu",
            style: TextStyle(color: Color(0xFF92BBBF), fontSize: 18),
          ),
          Icon(Icons.search, color: Color(0xFF92BBBF), size: 20),
        ],
      ),
    );
  }

  // ======================  Ikon tanaman (lingkaran + asset) ======================
  Widget _buildPlantIcons() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCircularAsset('assets/images/cabai.jpg'),
            const SizedBox(width: 24),
            _buildCircularAsset('assets/images/jagung.jpg'),
            const SizedBox(width: 24),
            _buildCircularAsset('assets/images/padi.jpg'),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularAsset(String path) {
    return ClipOval(
      child: Image.asset(
        path,
        width: 71,
        height: 71,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: 71,
          height: 71,
          color: Colors.grey[300],
          child: const Icon(Icons.image_not_supported),
        ),
      ),
    );
  }

  // ======================  Indikator dot  ======================
  Widget _buildIndicator() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: _networkImage(
          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/tq3bKFNRWd/uidbafu1_expires_30_days.png",
          width: 31,
          height: 11,
        ),
      ),
    );
  }

  // ======================  Card baris 1 ======================
  Widget _buildOptionCardsRow1(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _optionCard(
              iconUrl:
                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/tq3bKFNRWd/ehqqekg3_expires_30_days.png",
              dotUrl:
                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/tq3bKFNRWd/w1ll6m7j_expires_30_days.png",
              label: "Cara Menanam",
              onTap: () => _navigateTo(context, const CaraMenanamPage()),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _optionCard(
              iconUrl:
                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/tq3bKFNRWd/hqracb1w_expires_30_days.png",
              dotUrl:
                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/tq3bKFNRWd/6grh3380_expires_30_days.png",
              label: "Perawatan",
              onTap: () => _navigateTo(context, const PerawatanPage()),
            ),
          ),
        ],
      ),
    );
  }

  // ======================  Card baris 2 ======================
  Widget _buildOptionCardsRow2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: _optionCard(
              iconUrl:
                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/tq3bKFNRWd/x7fb88l2_expires_30_days.png",
              dotUrl:
                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/tq3bKFNRWd/hryptfsp_expires_30_days.png",
              label: "Cara Panen",
              onTap: () => _navigateTo(context, const CaraPanenPage()),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _optionCard(
              iconUrl:
                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/tq3bKFNRWd/0fk4c2xg_expires_30_days.png",
              dotUrl:
                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/tq3bKFNRWd/2vzffliz_expires_30_days.png",
              label: "Kalkulator Pupuk",
              onTap: () => _navigateTo(context, const KalkulatorPupukPage()),
            ),
          ),
        ],
      ),
    );
  }

  // Widget card reusable
  Widget _optionCard({
    required String iconUrl,
    required String dotUrl,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _networkImage(iconUrl, width: 36, height: 36),
                _networkImage(dotUrl, width: 16, height: 16),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  // ======================  Banner Scan Penyakit ======================
  Widget _buildScanBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => _scanDisease(context),
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          color: const Color(0x40015F64),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              width: 500,
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 40,
                color: Color(0xFF015F64),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Scan Penyakit Tanaman",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================  Bottom Navigation (fixed)  ======================
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
        left: 30,
        right: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavIcon(
            context,
            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/tq3bKFNRWd/gx65e0xn_expires_30_days.png",
            32,
          ),
          _buildNavIcon(
            context,
            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/tq3bKFNRWd/9h2kk7td_expires_30_days.png",
            27,
          ),
          _buildNavIcon(
            context,
            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/tq3bKFNRWd/g6hv3oqs_expires_30_days.png",
            29,
          ),
          _buildNavIcon(
            context,
            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/tq3bKFNRWd/au2bd3lo_expires_30_days.png",
            32,
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(BuildContext context, String url, double size) {
    return GestureDetector(
      onTap: () {
        if (url.contains("gx65e0xn")) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Beranda")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Fitur lainnya segera hadir")),
          );
        }
      },
      child: _networkImage(url, width: size, height: size),
    );
  }

  // ======================  Navigasi  ======================
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  // ======================  Scan dengan kamera ======================
  Future<void> _scanDisease(BuildContext context) async {
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (!context.mounted) return;
      if (image != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScanResultPage(imagePath: image.path),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Kamera Tidak Dapat Diakses"),
          content: const Text(
            "Pastikan Anda sudah memberikan izin kamera.\nCoba buka pengaturan dan aktifkan izin kamera untuk aplikasi ini.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }
}

// ======================  HALAMAN CARA MENANAM ======================
class CaraMenanamPage extends StatelessWidget {
  const CaraMenanamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cara Menanam"),
        backgroundColor: const Color(0xFF92BBBF),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Langkah-langkah menanam tanaman yang baik:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("1. Siapkan bibit unggul"),
            Text("2. Siapkan media tanam (tanah, pupuk)"),
            Text("3. Tanam bibit dengan kedalaman yang tepat"),
            Text("4. Siram secara teratur"),
            Text("5. Beri pupuk sesuai jadwal"),
            Text("6. Lindungi dari hama"),
            SizedBox(height: 20),
            Text(
              "Catatan: Setiap tanaman memiliki kebutuhan berbeda.",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================  HALAMAN PERAWATAN ======================
class PerawatanPage extends StatelessWidget {
  const PerawatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perawatan Tanaman"),
        backgroundColor: const Color(0xFF92BBBF),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tips Perawatan Tanaman:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("• Penyiraman yang cukup (jangan terlalu basah)"),
            Text("• Pemupukan rutin setiap 2 minggu"),
            Text("• Pangkas daun kering"),
            Text("• Pastikan sinar matahari cukup"),
            Text("• Ganti pot jika sudah sempit"),
          ],
        ),
      ),
    );
  }
}

// ======================  HALAMAN CARA PANEN ======================
class CaraPanenPage extends StatelessWidget {
  const CaraPanenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cara Panen"),
        backgroundColor: const Color(0xFF92BBBF),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Panduan Panen:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("1. Panen saat tanaman memasuki usia matang"),
            Text("2. Gunakan alat yang tajam dan bersih"),
            Text("3. Panen di pagi hari untuk kesegaran maksimal"),
            Text("4. Jangan merusak bagian tanaman lain"),
            Text("5. Segera simpan di tempat yang sesuai"),
          ],
        ),
      ),
    );
  }
}

// ======================  HALAMAN KALKULATOR PUPUK ======================
class KalkulatorPupukPage extends StatefulWidget {
  const KalkulatorPupukPage({super.key});

  @override
  State<KalkulatorPupukPage> createState() => _KalkulatorPupukPageState();
}

class _KalkulatorPupukPageState extends State<KalkulatorPupukPage> {
  final TextEditingController _luasController = TextEditingController();
  final TextEditingController _dosisController = TextEditingController();
  String _hasil = "";

  void _hitung() {
    double luas = double.tryParse(_luasController.text) ?? 0;
    double dosis = double.tryParse(_dosisController.text) ?? 0;
    if (luas <= 0 || dosis <= 0) {
      setState(() {
        _hasil = "Masukkan angka yang valid!";
      });
      return;
    }
    double kebutuhan = luas * dosis;
    setState(() {
      _hasil = "Kebutuhan pupuk: ${kebutuhan.toStringAsFixed(2)} kg";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kalkulator Pupuk"),
        backgroundColor: const Color(0xFF92BBBF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Hitung kebutuhan pupuk berdasarkan luas lahan",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _luasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Luas lahan (m²)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _dosisController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Dosis pupuk per m² (kg)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _hitung,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF92BBBF),
              ),
              child: const Text(
                "Hitung",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _hasil,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================  HALAMAN HASIL SCAN ======================
class ScanResultPage extends StatelessWidget {
  final String imagePath;
  const ScanResultPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Scan"),
        backgroundColor: const Color(0xFF92BBBF),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(File(imagePath), height: 300),
            const SizedBox(height: 20),
            const Text(
              "Analisis penyakit sedang diproses...",
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              "(Fitur deteksi penyakit akan datang)",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Kembali"),
            ),
          ],
        ),
      ),
    );
  }
}
