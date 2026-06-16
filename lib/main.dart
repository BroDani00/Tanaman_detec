// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/themes/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'providers/auth_provider.dart';
import 'providers/plant_provider.dart';
import 'services/storage_service.dart';
import 'splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/scan/scan_camera_screen.dart';
import 'screens/scan/scan_result_screen.dart';
import 'screens/profile/riwayat_scan_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/menu/cara_menanam_screen.dart';
import 'screens/menu/perawatan_screen.dart';
import 'screens/menu/cara_panen_screen.dart';
import 'screens/menu/kalkulator_pupuk_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service
  final storage = StorageService();
  await storage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PlantProvider()),
      ],
      child: MaterialApp(
        title: 'Doctor Plant - Tanaman Detect',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (context) => const SplashScreen(),
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.register: (context) => const RegisterScreen(),
          AppRoutes.home: (context) => const PanduanCerdas(),
          AppRoutes.scanCamera: (context) => const ScanCameraScreen(),
          AppRoutes.scanResult: (context) => const ScanResultScreen(
                imagePath: '',
                diagnosisResult: '',
                confidence: 0,
                recommendation: '',
                plantType: '',
              ),
          AppRoutes.riwayatScan: (context) => const RiwayatScanScreen(),
          AppRoutes.profile: (context) => const ProfileScreen(),
          AppRoutes.caraMenanam: (context) => const CaraMenanamScreen(),
          AppRoutes.perawatan: (context) => const PerawatanScreen(),
          AppRoutes.caraPanen: (context) => const CaraPanenScreen(),
          AppRoutes.kalkulatorPupuk: (context) => const KalkulatorPupukScreen(),
        },
      ),
    );
  }
}
