// lib/screens/menu/kalkulator_pupuk_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/plant_provider.dart';

class KalkulatorPupukScreen extends StatefulWidget {
  const KalkulatorPupukScreen({super.key});

  @override
  State<KalkulatorPupukScreen> createState() => _KalkulatorPupukScreenState();
}

class _KalkulatorPupukScreenState extends State<KalkulatorPupukScreen> {
  final TextEditingController _luasController = TextEditingController();
  String _hasil = '';
  String _selectedPupuk = 'Urea';

  final Map<String, Map<String, double>> _dosisPerTanaman = {
    'cabai': {'Urea': 15, 'SP-36': 10, 'KCl': 10},
    'jagung': {'Urea': 20, 'SP-36': 15, 'KCl': 15},
    'padi': {'Urea': 12, 'SP-36': 8, 'KCl': 8},
    'tomat': {'Urea': 18, 'SP-36': 12, 'KCl': 12},
     // Default jika tanaman tidak dikenali
  };

  void _hitung() {
    final plantProvider = Provider.of<PlantProvider>(context, listen: false);
    final plantType = plantProvider.selectedPlant;
    final dosisMap = _dosisPerTanaman[plantType] ?? _dosisPerTanaman['cabai']!;
    final dosis = dosisMap[_selectedPupuk] ?? 0;

    double luas = double.tryParse(_luasController.text) ?? 0;

    if (luas <= 0) {
      setState(() {
        _hasil = 'Masukkan luas lahan yang valid!';
      });
      return;
    }

    double kebutuhan = luas * (dosis / 1000); // Konversi gram ke kg
    setState(() {
      _hasil =
          'Kebutuhan $_selectedPupuk: ${kebutuhan.toStringAsFixed(2)} kg untuk ${luas.toStringAsFixed(0)} m²';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Pupuk'),
        backgroundColor: AppColors.primary,
      ),
      body: Consumer<PlantProvider>(
        builder: (context, plantProvider, child) {
          final plantName = plantProvider.currentPlantInfo['name'];
          final plantType = plantProvider.selectedPlant;
          final dosisMap =
              _dosisPerTanaman[plantType] ?? _dosisPerTanaman['cabai']!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info tanaman aktif
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: plantProvider.currentPlantInfo['color']
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        plantProvider.currentPlantInfo['icon'],
                        size: 40,
                        color: plantProvider.currentPlantInfo['color'],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kalkulator Pupuk $plantName',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Hitung kebutuhan pupuk berdasarkan luas lahan',
                              style: TextStyle(color: AppColors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Dosis rekomendasi
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dosis Rekomendasi per m²:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildDosisCard(
                              'Urea', '${dosisMap['Urea']?.toInt()} gr'),
                          _buildDosisCard(
                              'SP-36', '${dosisMap['SP-36']?.toInt()} gr'),
                          _buildDosisCard(
                              'KCl', '${dosisMap['KCl']?.toInt()} gr'),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Pilih jenis pupuk
                const Text(
                  'Pilih Jenis Pupuk:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Urea', label: Text('Urea')),
                    ButtonSegment(value: 'SP-36', label: Text('SP-36')),
                    ButtonSegment(value: 'KCl', label: Text('KCl')),
                  ],
                  selected: {_selectedPupuk},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _selectedPupuk = newSelection.first;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // Input luas lahan
                TextField(
                  controller: _luasController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Luas Lahan (m²)',
                    hintText: 'Contoh: 100',
                    prefixIcon: Icon(Icons.crop_square),
                  ),
                ),

                const SizedBox(height: 24),

                // Tombol hitung
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _hitung,
                    child: const Text('Hitung Kebutuhan'),
                  ),
                ),

                const SizedBox(height: 24),

                // Hasil
                if (_hasil.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.green.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.calculate,
                            size: 40, color: Colors.green),
                        const SizedBox(height: 8),
                        Text(
                          _hasil,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDosisCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: AppColors.primary)),
        ],
      ),
    );
  }
}
