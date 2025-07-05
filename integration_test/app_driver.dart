import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:geoportal_mobile/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Geoportal App Automation Test', () {
    // Fungsi reusable untuk mencari dan memilih item dari hasil pencarian
    Future<void> selectItemFromSearch(
        WidgetTester tester, String keyword, String expectedItemText) async {
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, keyword);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final listView = find.byType(ListView);
      final suggestionItem =
          find.descendant(of: listView, matching: find.text(expectedItemText));

      if (suggestionItem.evaluate().isNotEmpty) {
        await tester.tap(suggestionItem.first);
        await tester.pumpAndSettle();
      } else {
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();
      }

      bool bottomSheetFound = false;
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find
            .byKey(const Key('bottomSheetDetailData'))
            .evaluate()
            .isNotEmpty) {
          bottomSheetFound = true;
          break;
        }
      }

      expect(bottomSheetFound, isTrue,
          reason:
              '❌ Bottom sheet detail tidak muncul setelah memilih item "$expectedItemText"');
    }

    testWidgets('Test Tambah, Edit, dan Hapus: Koordinat, Foto, dan Data Umum',
        (WidgetTester tester) async {
      try {
        app.main();
        await tester.pumpAndSettle();
        debugPrint('✅ Aplikasi dimulai');

        // Menunggu Splash Screen selesai
        int splashAttempts = 0;
        while (splashAttempts < 10) {
          await tester.pump(const Duration(seconds: 1));
          debugPrint(
              'Menunggu splash screen... percobaan ke-${splashAttempts + 1}');
          if (find.text('Selamat Datang di Geoportal!').evaluate().isNotEmpty) {
            break;
          }
          splashAttempts++;
        }

        // Halaman onboarding
        expect(find.text('Selamat Datang di Geoportal!'), findsOneWidget);
        debugPrint('✅ Masuk ke Halaman Onboarding');

        // Navigasi halaman onboarding
        final nextButton = find.text('Selanjutnya');
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        debugPrint('✅ Swipe onboarding selesai');

        // Lanjut ke halaman login
        final startButton = find.text('Mulai Sekarang');
        await tester.tap(startButton);
        await tester.pumpAndSettle();
        debugPrint('✅ Navigasi ke halaman Login');

        // Form login
        expect(find.text('Masuk'), findsWidgets);
        final roleDropdown = find.byKey(const Key('roleDropdown'));
        final emailField = find.byKey(const Key('emailField'));
        final passwordField = find.byKey(const Key('passwordField'));
        final loginButton = find.widgetWithText(ElevatedButton, 'Masuk');

        // Pilih peran
        await tester.tap(roleDropdown);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Admin').last);
        await tester.pumpAndSettle();

        // Input data login
        await tester.enterText(emailField, 'fadli@gmail.com');
        await tester.enterText(passwordField, 'fadli12');
        await tester.pump();
        debugPrint('✅ Form login terisi');

        // Tutup keyboard dengan cara manual
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pump(const Duration(seconds: 2));
        debugPrint('✅ Keyboard berhasil ditutup');

        // Tap tombol login
        await tester.tap(loginButton);
        debugPrint('✅ Tombol login ditekan');

        // Delay eksplisit untuk beri waktu transisi animasi/login
        await tester.pump(const Duration(seconds: 2));
        debugPrint('Proses login sedang berlangsung...');

        // Retry menunggu navigasi ke home
        bool foundHome = false;
        int waitCount = 0;
        while (!foundHome && waitCount < 15) {
          await tester.pump(const Duration(seconds: 1));
          foundHome = find.text('Hi Fadli!').evaluate().isNotEmpty;
          debugPrint(
              'Menunggu halaman beranda... percobaan ke-${waitCount + 1}');
          waitCount++;
        }

        // Verifikasi sukses login
        expect(find.text('Hi Fadli!'), findsOneWidget);
        debugPrint('✅ Berhasil sampai di halaman Beranda');

        // Biarkan halaman beranda tampil selama beberapa detik
        await tester.pump(const Duration(seconds: 5));
        debugPrint('Menampilkan halaman beranda');

        // Navigasi ke menu Peta
        final petaNavIcon = find.byKey(const Key('navPeta'));
        expect(petaNavIcon, findsOneWidget);
        await tester.tap(petaNavIcon);
        await tester.pumpAndSettle();

        final petaBatamText = find.textContaining('Peta Batam');

        // Scroll otomatis agar peta terlihat
        await tester.ensureVisible(petaBatamText);
        await tester.pumpAndSettle();

        // Mmeastikan widget ditemukan
        expect(petaBatamText, findsOneWidget);
        debugPrint('✅ Item Peta Batam ditemukan');

        final viewButton = find.widgetWithText(TextButton, 'View');
        await tester.tap(viewButton);
        await tester.pumpAndSettle();
        debugPrint('✅ Tombol View ditekan, masuk ke detail peta');

        await tester.pump(const Duration(seconds: 5));
        debugPrint('Menunggu 5 detik agar map selesai di-render...');

        await tester.tapAt(const Offset(400, 300));
        await tester.pumpAndSettle();
        debugPrint('✅ Map ditap');

        // Tap tombol Tambah Data
        await tester.pump(const Duration(seconds: 3));
        final tambahDataButton = find.text('Tambah Data');
        expect(tambahDataButton, findsOneWidget);
        await tester.tap(tambahDataButton);
        await tester.pumpAndSettle();

        debugPrint('✅ Navigasi ke halaman Tambah Data');

        // Input data di form tambah data
        await tester.enterText(
            find.widgetWithText(TextFormField, 'Contoh: Kelurahan Duriangkang'),
            'Kelurahan Duriangkang');
        await tester.pump(const Duration(seconds: 2));

        // Tutup keyboard
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        await tester.enterText(
            find.widgetWithText(TextFormField, 'Contoh: Kecamatan Sei Beduk'),
            'Kecamatan Sei Beduk');
        await tester.pump(const Duration(seconds: 2));

        // Tutup keyboard
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Jenis Kawasan'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Kawasan Pengembang').last);
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 2));

        await tester.enterText(
            find.widgetWithText(
                TextFormField, 'Contoh: Perumahan Mutiara Hijau '),
            'Perumahan GMP');
        await tester.pump(const Duration(seconds: 2));

        // Tutup keyboard
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        await tester.enterText(
            find.widgetWithText(TextFormField, 'Contoh: Blok C2 No 15'),
            'Blok F No 99');
        await tester.pump(const Duration(seconds: 2));

        // Tutup keyboard
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        await tester.enterText(
            find.widgetWithText(TextFormField, 'Contoh: 003'), '005');
        await tester.pump(const Duration(seconds: 2));

        // Tutup keyboard
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        await tester.enterText(
            find.widgetWithText(TextFormField, 'Contoh: 006'), '008');
        await tester.pump(const Duration(seconds: 2));

        // Tutup keyboard
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        await tester.enterText(
            find.widgetWithText(
                TextFormField, 'Contoh: 0.00079236174892200004'),
            '0.00079236174892200004');
        await tester.pump(const Duration(seconds: 2));

        // Tutup keyboard
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        await tester.enterText(
            find.widgetWithText(TextFormField, 'Contoh: 1.14035827148e-08'),
            '1.24565827148e-08');
        await tester.pump(const Duration(seconds: 2));

        // Tutup keyboard
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        // Tambahkan foto dummy saat testing
        final mockImageButton = find.byKey(const Key('btnMockFoto'));

        if (mockImageButton.evaluate().isNotEmpty) {
          await tester.tap(mockImageButton);
          await tester.pumpAndSettle();
          debugPrint('✅ Berhasil menambahkan gambar mock');
        } else {
          debugPrint(
              'Tombol mock foto tidak ditemukan - mungkin bukan dalam TEST_MODE !!');
        }

        // Scroll agar field koordinat terlihat dan tap untuk buka map
        final koordinatFinder = find.byKey(const Key('fieldKoordinat'));
        expect(koordinatFinder, findsOneWidget,
            reason: '❌ fieldKoordinat tidak ditemukan');
        await tester.ensureVisible(koordinatFinder);
        await tester.pump(const Duration(milliseconds: 500));
        await tester.tap(koordinatFinder);
        await tester.pumpAndSettle();

        // Tap di map untuk pilih titik koordinat (contoh posisi offset)
        await tester.tapAt(const Offset(200, 300));
        await tester.pumpAndSettle();

        // Tunggu hingga tombol konfirmasi koordinat muncul
        final konfirmasiBtn = find.byKey(const Key('btnKonfirmasiKoordinat'));
        bool konfirmasiBtnFound = false;
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 300));
          if (konfirmasiBtn.evaluate().isNotEmpty) {
            konfirmasiBtnFound = true;
            break;
          }
        }
        expect(konfirmasiBtnFound, isTrue,
            reason:
                '❌ Tombol konfirmasi koordinat tidak muncul setelah memilih titik');

        await tester.tap(konfirmasiBtn);
        await tester.pumpAndSettle();

        // Ambil nilai koordinat dari field dan pastikan tidak kosong
        final koordinatText =
            (tester.widget(koordinatFinder) as TextFormField).controller?.text;
        expect(koordinatText != null && koordinatText.isNotEmpty, true);

        debugPrint('✅ Form berhasil diisi');

        final simpanButton = find.widgetWithText(ElevatedButton, 'Simpan');
        await tester.tap(simpanButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
        debugPrint('✅ Tombol simpan ditekan');

        await tester.pump(const Duration(seconds: 4));

        debugPrint(
            '🎉 Test Berhasil: Tambah data - Koordinat, Foto, dan Data Umum (1/1)');

        // Pengujian Edit Data - Koordinat, Foto, dan Data Umum
        final searchField = find.byType(TextField);
        expect(searchField, findsOneWidget);
        await tester.enterText(searchField, 'Perumahan GMP');
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final listView = find.byType(ListView);
        final suggestionItem =
            find.descendant(of: listView, matching: find.text('Perumahan GMP'));
        if (suggestionItem.evaluate().isNotEmpty) {
          await tester.tap(suggestionItem.first);
          await tester.pumpAndSettle();
        } else {
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();
        }

        bool bottomSheetFound = false;
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 500));
          if (find
              .byKey(const Key('bottomSheetDetailData'))
              .evaluate()
              .isNotEmpty) {
            bottomSheetFound = true;
            break;
          }
        }
        expect(bottomSheetFound, isTrue);

        // Tunggu 3 detik agar bottom sheet terlihat
        debugPrint('✅ Bottom sheet detail data muncul');
        await tester.pump(const Duration(seconds: 3));
        final editButton = find.byKey(const Key('btnUbahData'));
        await tester.ensureVisible(editButton);
        await tester.pump();
        await tester.tap(editButton);
        await tester.pumpAndSettle();

        final namaLokasiField = find.byKey(const Key('fieldNamaLokasi'));
        await tester.ensureVisible(namaLokasiField);
        expect(namaLokasiField, findsOneWidget);

        // Hapus dulu isi form
        await tester.enterText(namaLokasiField, '');
        await tester.pumpAndSettle();

        // Masukkan teks baru
        await tester.enterText(namaLokasiField, 'Perumahan Perumnas');
        await tester.pump(const Duration(seconds: 1));

        // Tutup keyboard
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        final rtField = find.byKey(const Key('fieldRT'));
        expect(rtField, findsOneWidget);

        // Hapus dulu isi form
        await tester.enterText(rtField, '');
        await tester.pumpAndSettle();

        // Masukkan teks baru
        await tester.enterText(rtField, '002');
        await tester.pump(const Duration(seconds: 1));

        // Tutup keyboard
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        final rwField = find.byKey(const Key('fieldRW'));
        expect(rwField, findsOneWidget);

        // Hapus dulu isi form
        await tester.enterText(rwField, '');
        await tester.pumpAndSettle();

        // Masukkan teks baru
        await tester.enterText(rwField, '009');
        await tester.pump(const Duration(seconds: 1));

        // Tutup keyboard
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        // Hapus semua foto mock yang lama
        while (find.byIcon(Icons.close).evaluate().isNotEmpty) {
          final hapusFoto = find.byIcon(Icons.close).first;
          await tester.tap(hapusFoto);
          await tester.pumpAndSettle();
        }

        // Scroll ke bawah agar tombol foto terlihat
        await tester.drag(
            find.byType(SingleChildScrollView), const Offset(0, -300));
        await tester.pumpAndSettle();

        // Tambah foto mock baru saat ubah data
        final ubahFotoBtn = find.byKey(const Key('btnMockUbahFoto'));
        if (ubahFotoBtn.evaluate().isNotEmpty) {
          await tester.tap(ubahFotoBtn);
          await tester.pumpAndSettle();
        }

        // Scroll ke bawah agar field koordinat terlihat
        await tester.drag(
            find.byType(SingleChildScrollView), const Offset(0, -300));
        await tester.pumpAndSettle();

        // Sekarang pastikan field koordinat dan tap
        final ubahkoordinatFinder = find.byKey(const Key('btnUbahKoordinat'));
        expect(ubahkoordinatFinder, findsOneWidget,
            reason: '❌ fieldKoordinat tidak ditemukan');

        await tester.ensureVisible(ubahkoordinatFinder);
        await tester.tap(ubahkoordinatFinder);
        await tester.pumpAndSettle();

        await tester.tapAt(const Offset(250, 320));
        await tester.pumpAndSettle();

        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 300));
          if (konfirmasiBtn.evaluate().isNotEmpty) break;
        }
        await tester.tap(konfirmasiBtn);
        await tester.pumpAndSettle();

        final simpanUbahBtn = find.byKey(const Key('btnSimpanUbahData'));
        expect(simpanUbahBtn, findsOneWidget);

        await tester.tap(simpanUbahBtn);
        await tester.pumpAndSettle();
        debugPrint('✅ Tombol simpan ubah data ditekan');

        final closeBottomSheet = find.byKey(const Key('closeBottomSheet'));
        await tester.tap(closeBottomSheet);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('bottomSheetDetailData')), findsNothing);
        debugPrint(
            '🎉 Test Berhasil: Ubah data - Koordinat, Foto, dan Data Umum (2/2)');

        // Pengujian Hapus Data - Koordinat, Foto, dan Data Umum
        await selectItemFromSearch(
            tester, 'Perumahan Perumnas', 'Perumahan Perumnas');

        // Tunggu 3 detik agar bottom sheet terlihat
        await tester.pump(const Duration(seconds: 3));

        // Scroll untuk menampilkan tombol hapus jika diperlukan
        await tester.drag(
            find.byType(SingleChildScrollView), const Offset(0, -300));
        await tester.pumpAndSettle();

        // Cari tombol hapus
        final hapusBtn = find.byKey(const Key('btnHapusData'));
        expect(hapusBtn, findsOneWidget);
        await tester.ensureVisible(hapusBtn);
        await tester.tap(hapusBtn);
        await tester.pumpAndSettle();

        // Tunggu dialog muncul
        final konfirmasiHapusBtn = find.byKey(const Key('btnKonfirmasiHapus'));
        expect(konfirmasiHapusBtn, findsOneWidget,
            reason: '❌ Tombol konfirmasi hapus tidak ditemukan');

        // Tekan tombol konfirmasi
        await tester.pump(const Duration(seconds: 2));
        await tester.tap(konfirmasiHapusBtn);
        await tester.pump(const Duration(seconds: 2));

        // Tekan tombol silang jika masih ada bottom sheet
        final closeBottomSheetBtn = find.byKey(const Key('closeBottomSheet'));
        if (closeBottomSheetBtn.evaluate().isNotEmpty) {
          await tester.tap(closeBottomSheetBtn);
          await tester.pumpAndSettle();
        }

        // Pastikan dialog tertutup
        expect(find.byKey(const Key('btnKonfirmasiHapus')), findsNothing);

        // Verifikasi bottom sheet tertutup
        expect(find.byKey(const Key('bottomSheetDetailData')), findsNothing);
        debugPrint('🎉 Test Berhasil: Hapus data - Koordinat, Foto, dan Data Umum (3/3)');

        expect(bottomSheetFound, isTrue);
      } catch (e, stackTrace) {
        debugPrint('❌ TEST GAGAL: $e');
        debugPrint('STACK TRACE:\n$stackTrace');
        rethrow;
      }
    });
  });
}
