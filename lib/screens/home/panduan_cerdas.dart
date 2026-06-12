// lib/screens/home/panduan_cerdas.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/plant_provider.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/plant_selector.dart';
import '../../widgets/menu_card.dart';
import '../menu/cara_menanam_screen.dart';
import '../menu/perawatan_screen.dart';
import '../menu/cara_panen_screen.dart';
import '../menu/kalkulator_pupuk_screen.dart';
import '../scan/scan_camera_screen.dart';
import '../profile/riwayat_scan_screen.dart';
import '../profile/profile_screen.dart';

class PanduanCerdas extends StatefulWidget {
  const PanduanCerdas({super.key});

  @override
  State<PanduanCerdas> createState() => _PanduanCerdasState();
}

class _PanduanCerdasState extends State<PanduanCerdas> {
  int _currentNavIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Load plant provider data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final plantProvider = Provider.of<PlantProvider>(context, listen: false);
      plantProvider.init();
    });
  }

  void _onNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    switch (index) {
      case 1:
        // Riwayat Scan
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RiwayatScanScreen()),
        ).then((_) {
          setState(() {
            _currentNavIndex = 0;
          });
        });
        break;
      case 2:
        // Profil
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        ).then((_) {
          setState(() {
            _currentNavIndex = 0;
          });
        });
        break;
      default:
        // Beranda - scroll to top
        _scrollToTop();
        break;
    }
  }

  void _scrollToTop() {
    // Implement scroll to top jika perlu
  }

  Future<void> _onPlantSelected(String plant) async {
    final plantProvider = Provider.of<PlantProvider>(context, listen: false);
    await plantProvider.setSelectedPlant(plant);
  }

  void _showWarningDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Perhatian'),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header dengan gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Padding(
                padding:
                    EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Logo kecil
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.eco, color: AppColors.primary),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Doctor Plant',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Plant Selector will be added here with Consumer
                  ],
                ),
              ),
            ),

            // Plant Selector (dipisah untuk menghindari error)
            Consumer<PlantProvider>(
              builder: (context, plantProvider, child) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: PlantSelector(
                    selectedPlant: plantProvider.selectedPlant,
                    onPlantSelected: _onPlantSelected,
                    isRequired: false,
                  ),
                );
              },
            ),

            const SizedBox(height: 8),

            // Menu Grid
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Consumer<PlantProvider>(
                  builder: (context, plantProvider, child) {
                    final isPlantSelected =
                        plantProvider.selectedPlant.isNotEmpty;

                    return Column(
                      children: [
                        // Status tanaman aktif
                        if (isPlantSelected)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  plantProvider.currentPlantInfo['icon'],
                                  size: 18,
                                  color:
                                      plantProvider.currentPlantInfo['color'],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Tanaman Aktif: ${plantProvider.currentPlantInfo['name']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Menu grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 1.1,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: [
                            MenuCard(
                              title: 'Cara Menanam',
                              subtitle:
                                  'Panduan menanam ${plantProvider.currentPlantInfo['name']}',
                              icon: Icons.grass,
                              color: AppColors.primary,
                              isDisabled: !isPlantSelected,
                              onTap: () {
                                if (!isPlantSelected) {
                                  _showWarningDialog(
                                      'Silakan pilih tanaman terlebih dahulu');
                                  return;
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CaraMenanamScreen(),
                                  ),
                                );
                              },
                            ),
                            MenuCard(
                              title: 'Perawatan',
                              subtitle:
                                  'Tips merawat ${plantProvider.currentPlantInfo['name']}',
                              icon: Icons.water_drop,
                              color: Colors.blue,
                              isDisabled: !isPlantSelected,
                              onTap: () {
                                if (!isPlantSelected) {
                                  _showWarningDialog(
                                      'Silakan pilih tanaman terlebih dahulu');
                                  return;
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PerawatanScreen(),
                                  ),
                                );
                              },
                            ),
                            MenuCard(
                              title: 'Cara Panen',
                              subtitle: 'Waktu dan teknik panen yang tepat',
                              icon: Icons.agriculture,
                              color: Colors.orange,
                              isDisabled: !isPlantSelected,
                              onTap: () {
                                if (!isPlantSelected) {
                                  _showWarningDialog(
                                      'Silakan pilih tanaman terlebih dahulu');
                                  return;
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CaraPanenScreen(),
                                  ),
                                );
                              },
                            ),
                            MenuCard(
                              title: 'Kalkulator Pupuk',
                              subtitle: 'Hitung kebutuhan pupuk',
                              icon: Icons.calculate,
                              color: Colors.purple,
                              isDisabled: !isPlantSelected,
                              onTap: () {
                                if (!isPlantSelected) {
                                  _showWarningDialog(
                                      'Silakan pilih tanaman terlebih dahulu');
                                  return;
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const KalkulatorPupukScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Banner Scan Penyakit
                        if (isPlantSelected)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ScanCameraScreen(),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 24),
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.accent,
                                    AppColors.accentLight,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.accent.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 40,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Scan Penyakit Tanaman',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Deteksi penyakit ${plantProvider.currentPlantInfo['name']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Scan Penyakit Tanaman',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Pilih tanaman terlebih dahulu',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
