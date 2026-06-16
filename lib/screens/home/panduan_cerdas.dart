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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final plantProvider = Provider.of<PlantProvider>(context, listen: false);
      plantProvider.init();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index == _currentNavIndex) {
      _scrollToTop();
      return;
    }

    setState(() {
      _currentNavIndex = index;
    });

    switch (index) {
      case 0:
        _scrollToTop();
        break;
      case 1:
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        ).then((_) {
          setState(() {
            _currentNavIndex = 0;
          });
        });
        break;
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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
    // Get screen size untuk responsive
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Tentukan ukuran card berdasarkan lebar layar
    final cardHeight = screenWidth < 360 ? 110 : 140;
    final cardAspectRatio = screenWidth < 360 ? 0.85 : 0.9;

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan gradient - DIPERBAIKI
            Container(
              width: double.infinity,
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
              child: Padding(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.04,
                  bottom: screenHeight * 0.02,
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                ),
                child: Row(
                  children: [
                    // Logo kecil
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child:
                          Icon(Icons.eco, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Doctor Plant',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    // Tombol profil
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Plant Selector - DIPERBAIKI
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03,
                vertical: screenHeight * 0.01,
              ),
              child: Consumer<PlantProvider>(
                builder: (context, plantProvider, child) {
                  return PlantSelector(
                    selectedPlant: plantProvider.selectedPlant,
                    onPlantSelected: _onPlantSelected,
                    isRequired: false,
                  );
                },
              ),
            ),

            const SizedBox(height: 4),

            // Expanded untuk sisa ruang
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                ),
                child: Consumer<PlantProvider>(
                  builder: (context, plantProvider, child) {
                    final isPlantSelected =
                        plantProvider.selectedPlant.isNotEmpty;
                    final plantName = plantProvider.currentPlantInfo['name'];
                    final plantIcon = plantProvider.currentPlantInfo['icon'];
                    final plantColor = plantProvider.currentPlantInfo['color'];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status tanaman aktif - DIPERBAIKI
                        if (isPlantSelected)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  plantIcon,
                                  size: 18,
                                  color: plantColor,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Tanaman Aktif: $plantName',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Menu grid - DIPERBAIKI
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: screenWidth < 380 ? 2 : 2,
                          childAspectRatio: cardAspectRatio,
                          crossAxisSpacing: screenWidth * 0.04,
                          mainAxisSpacing: screenWidth * 0.04,
                          children: [
                            MenuCard(
                              title: 'Cara Menanam',
                              subtitle: 'Panduan menanam $plantName',
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
                              subtitle: 'Tips merawat $plantName',
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

                        const SizedBox(height: 16),

                        // Banner Scan Penyakit - DIPERBAIKI
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
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 24),
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.03,
                              ),
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
                                    width: 70,
                                    height: 70,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 35,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Scan Penyakit Tanaman',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Deteksi penyakit $plantName',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 24),
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.03,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 35,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Scan Penyakit Tanaman',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Pilih tanaman terlebih dahulu',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Extra bottom space
                        SizedBox(height: screenHeight * 0.02),
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
