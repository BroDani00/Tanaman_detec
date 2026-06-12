// lib/screens/profile/riwayat_scan_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/repositories/scan_repository.dart';
import '../../data/models/scan_history_model.dart';
import '../../widgets/scan_history_card.dart';
import '../../widgets/loading_dialog.dart';

class RiwayatScanScreen extends StatefulWidget {
  const RiwayatScanScreen({super.key});

  @override
  State<RiwayatScanScreen> createState() => _RiwayatScanScreenState();
}

class _RiwayatScanScreenState extends State<RiwayatScanScreen> {
  final ScanRepository _scanRepository = ScanRepository();
  List<ScanHistoryModel> _scanHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScanHistory();
  }

  Future<void> _loadScanHistory() async {
    setState(() => _isLoading = true);
    _scanHistory = await _scanRepository.getUserScanHistory();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteScanHistory(int id, int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Riwayat'),
        content:
            const Text('Apakah Anda yakin ingin menghapus riwayat scan ini?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      LoadingDialog.show(context, message: 'Menghapus...');
      await _scanRepository.deleteScanHistory(id);
      await _loadScanHistory();
      if (mounted) LoadingDialog.hide(context);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Riwayat berhasil dihapus'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  void _showDetailDialog(ScanHistoryModel scan) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.info, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Detail Scan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(scan.imagePath),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 50),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Jenis Tanaman', scan.plantType.toUpperCase()),
              _buildDetailRow('Hasil Diagnosis', scan.diagnosisResult),
              _buildDetailRow('Keyakinan', scan.confidencePercent),
              _buildDetailRow('Tanggal Scan', scan.formattedDate),
              if (scan.notes != null && scan.notes!.isNotEmpty)
                _buildDetailRow('Catatan', scan.notes!),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: AppColors.grey),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Scan'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadScanHistory,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _scanHistory.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada riwayat scan',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Lakukan scan tanaman untuk melihat riwayat',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _scanHistory.length,
                  itemBuilder: (context, index) {
                    final scan = _scanHistory[index];
                    return ScanHistoryCard(
                      scan: scan,
                      onTap: () => _showDetailDialog(scan),
                      onDelete: () => _deleteScanHistory(scan.id!, index),
                    );
                  },
                ),
    );
  }
}
