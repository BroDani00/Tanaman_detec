import 'package:flutter/material.dart';
import 'panduan_cerdas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tanaman Detect',
      debugShowCheckedModeBanner: false, // Menghilangkan tulisan DEBUG
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PanduanCerdas(), // Langsung ke halaman utama
    );
  }
}
