import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

import '../../widgets/loading_indicators.dart';
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: PageLoader(
          loadingText: 'Memuat syarat...',
          child: Column(
          children: [
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
                          'Syarat & Ketentuan',
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
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Intro(
                      text:
                          'Selamat datang di XAlarm. Dengan menggunakan aplikasi ini, kamu menyetujui ketentuan berikut. Mohon baca dengan teliti.',
                    ),
                    _Section(
                      title: '1. Penerimaan Ketentuan',
                      body:
                          'Dengan mendownload, menginstall, atau menggunakan XAlarm, kamu menyetujui terikat oleh Syarat & Ketentuan ini. Jika kamu tidak setuju, silakan tidak menggunakan aplikasi.',
                    ),
                    _Section(
                      title: '2. Penggunaan yang Dibolehkan',
                      body:
                          'XAlarm boleh digunakan untuk:\n\n• Mengatur alarm pribadi\n• Melacak pola tidur kamu sendiri\n• Menggunakan fitur pomodoro & timer untuk produktivitas\n• Membagikan statistik pribadi (jika fitur tersedia)\n\nKamu BERTANGGUNG JAWAB sepenuhnya atas alarm yang kamu atur. Jangan menggunakan XAlarm sebagai pengganti alarm darurat (medis, keamanan, dll).',
                    ),
                    _Section(
                      title: '3. Penggunaan yang Dilarang',
                      body:
                          'Dilarang:\n\n• Reverse-engineering atau modifikasi aplikasi\n• Menggunakan untuk tujuan ilegal\n• Mengakses akun pengguna lain tanpa izin\n• Mengeksploitasi bug untuk merugikan pengguna lain\n• Membypass sistem anti-cheat untuk tujuan curang\n\nPelanggaran dapat berakibat penonaktifan akun permanen.',
                    ),
                    _Section(
                      title: '4. Tanggung Jawab Pengguna',
                      body:
                          'Kamu bertanggung jawab atas:\n\n• Keamanan password akun kamu (jika ada)\n• Akurasi waktu alarm yang kamu atur\n• Mengizinkan notifikasi & background activity untuk alarm berfungsi\n• Backup data pribadi kamu\n• Mengatur volume perangkat agar alarm terdengar\n\nXAlarm TIDAK bertanggung jawab atas keterlambatan atau ketidakberbunyiannya alarm akibat: izin sistem dicabut, mode pesawat, perangkat mati, baterai habis, force-stop oleh sistem, atau bug OS.',
                    ),
                    _Section(
                      title: '5. Properti Intelektual',
                      body:
                          'Semua konten dalam XAlarm (logo, desain, kode, suara) adalah milik XAlarm atau lisensor-nya, dilindungi hak cipta. Kamu diberi lisensi non-eksklusif dan tidak dapat dialihkan untuk menggunakan aplikasi sesuai Syarat ini.',
                    ),
                    _Section(
                      title: '6. Batasan Tanggung Jawab',
                      body:
                          'XAlarm disediakan "AS IS" tanpa garansi apapun. Kami tidak bertanggung jawab atas:\n\n• Kerugian akibat alarm tidak berbunyi\n• Konsekuensi terlambat ke pekerjaan/sekolah/janji\n• Kehilangan data karena bug atau gangguan\n• Damage tidak langsung atau konsekuensial\n\nTanggung jawab maksimum kami terbatas pada jumlah yang kamu bayarkan ke XAlarm (Rp 0 untuk versi gratis).',
                    ),
                    _Section(
                      title: '7. Perubahan Layanan',
                      body:
                          'Kami berhak menambah, mengubah, atau menghentikan fitur kapan saja. Untuk perubahan signifikan, kami akan memberitahu via update aplikasi atau notifikasi.',
                    ),
                    _Section(
                      title: '8. Penghentian',
                      body:
                          'Kamu bisa berhenti menggunakan XAlarm kapan saja dengan menghapus aplikasi dan akun. Kami juga berhak menonaktifkan akun yang melanggar Syarat ini.',
                    ),
                    _Section(
                      title: '9. Hukum yang Berlaku',
                      body:
                          'Syarat ini diatur oleh hukum Republik Indonesia. Sengketa akan diselesaikan melalui mediasi terlebih dahulu, kemudian arbitrase di Jakarta jika diperlukan.',
                    ),
                    _Section(
                      title: '10. Kontak',
                      body:
                          '📧 legal@xalarm.app\n🌐 xalarm.app/terms\n📍 PT XAlarm Indonesia',
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
        color: AppColors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.orange.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.gavel_rounded, color: AppColors.orange, size: 18),
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
          Icon(Icons.check_circle_outline,
              color: AppColors.green, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Dengan melanjutkan menggunakan XAlarm, kamu menyetujui syarat & ketentuan ini.',
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
