import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

import '../../widgets/loading_indicators.dart';
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: PageLoader(
          loadingText: 'Memuat kebijakan...',
          child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 16),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kebijakan Privasi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Berlaku per 1 Juni 2026',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Intro(
                      text:
                          'XAlarm menghargai privasi kamu. Dokumen ini menjelaskan data apa yang kami kumpulkan, bagaimana data tersebut digunakan, dan hak kamu sebagai pengguna.',
                    ),
                    _Section(
                      title: '1. Data yang Kami Kumpulkan',
                      body:
                          'XAlarm hanya menyimpan data minimum yang dibutuhkan untuk menjalankan fitur alarm:\n\n• Pengaturan alarm (waktu, label, hari ulang)\n• Statistik personal (jumlah alarm berhasil, snooze, streak)\n• Preferensi aplikasi (suara, tema, bahasa)\n• Data profil opsional (nama, email)\n\nSemua data ini disimpan secara LOKAL di perangkat kamu. Kami tidak mengirim data ke server kecuali kamu mengaktifkan fitur sync cloud (jika tersedia).',
                    ),
                    _Section(
                      title: '2. Izin Sistem yang Diminta',
                      body:
                          '• Notifikasi — untuk membunyikan alarm\n• Background Activity — agar alarm tetap berjalan saat aplikasi ditutup\n• Vibrate — untuk getaran alarm\n• Camera (opsional) — untuk QR Scan challenge\n• Sistem suara — untuk mendeteksi mute (Anti-Cheat)\n\nKamu bisa mencabut izin kapan saja lewat pengaturan sistem. Namun mencabut izin tertentu akan menonaktifkan fitur terkait.',
                    ),
                    _Section(
                      title: '3. Cara Data Kami Gunakan',
                      body:
                          'Data yang dikumpulkan dipakai untuk:\n\n• Menjalankan fungsi alarm sesuai pengaturan kamu\n• Menampilkan statistik & analitik personal\n• Memberikan rekomendasi (jika fitur tersedia)\n• Sinkronisasi antar perangkat (jika sync diaktifkan)\n\nKami TIDAK menjual data kamu. Kami TIDAK menggunakan data untuk iklan personal. Kami TIDAK membagikan data ke pihak ketiga tanpa persetujuan eksplisit kamu.',
                    ),
                    _Section(
                      title: '4. Hak Kamu',
                      body:
                          '• Akses — kamu bisa melihat semua data kamu kapan saja di tab Profile\n• Ekspor — kamu bisa mengekspor data ke file JSON\n• Hapus — kamu bisa menghapus akun & semua data dari Settings > Hapus Akun\n• Koreksi — kamu bisa mengedit data profil dari Edit Profile\n\nProses penghapusan data dilakukan secara permanen dan tidak bisa dipulihkan.',
                    ),
                    _Section(
                      title: '5. Keamanan',
                      body:
                          'Data sensitif (password, jika ada) dienkripsi sebelum disimpan. Untuk sync cloud, kami menggunakan koneksi terenkripsi (TLS 1.3) dan otentikasi token. Walaupun kami berusaha maksimum, tidak ada sistem yang 100% aman — jangan simpan informasi sangat sensitif di label alarm.',
                    ),
                    _Section(
                      title: '6. Anak di Bawah Umur',
                      body:
                          'XAlarm tidak ditujukan untuk pengguna di bawah 13 tahun. Kami tidak secara sengaja mengumpulkan data dari anak-anak di bawah usia tersebut. Jika kamu adalah orang tua dan menemukan anakmu menggunakan aplikasi ini, hubungi kami untuk menghapus data terkait.',
                    ),
                    _Section(
                      title: '7. Perubahan Kebijakan',
                      body:
                          'Kebijakan ini dapat berubah seiring perkembangan aplikasi. Perubahan signifikan akan diberitahukan via notifikasi dalam aplikasi minimum 14 hari sebelum berlaku.',
                    ),
                    _Section(
                      title: '8. Kontak',
                      body:
                          'Untuk pertanyaan tentang privasi:\n\n📧 privacy@xalarm.app\n🌐 xalarm.app/privacy\n📍 PT XAlarm Indonesia\n\nKami berkomitmen menanggapi pertanyaan privasi dalam 7 hari kerja.',
                    ),
                    SizedBox(height: 20),
                    _Footer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  final String text;
  const _Intro({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined,
              color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;
  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified_outlined, color: AppColors.green, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Dengan menggunakan XAlarm, kamu setuju dengan kebijakan privasi ini.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
