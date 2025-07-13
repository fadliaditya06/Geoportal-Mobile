import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geoportal_mobile/controllers/ubah_data_controller.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geoportal_mobile/widgets/custom_snackbar.dart';
import 'package:geoportal_mobile/services/performance_tracer.dart';
import 'ubah_data_controller_test.mocks.dart';

@GenerateMocks([
  firebase_auth.FirebaseAuth,
  firebase_auth.User,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  SupabaseClient,
  SupabaseStorageClient,
  StorageFileApi,
  PerformanceTracer,
])
void main() {
  isTestMode = true;
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UbahDataController Test', () {
    late UbahDataController controller;
    late MockFirebaseAuth mockAuth;
    late MockUser mockUser;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> userCollection;
    late MockDocumentReference<Map<String, dynamic>> userRef;
    late MockCollectionReference<Map<String, dynamic>> spasialCollection;
    late MockCollectionReference<Map<String, dynamic>> umumCollection;
    late MockDocumentReference<Map<String, dynamic>> umumRef;
    late MockDocumentReference<Map<String, dynamic>> spasialRef;
    late MockDocumentSnapshot<Map<String, dynamic>> mockSnapshot;
    late MockSupabaseClient mockSupabase;
    late MockPerformanceTracer mockTracer;
    late MockSupabaseStorageClient mockStorageClient;
    late MockStorageFileApi mockFileApi;
    late GlobalKey<FormState> formKey;

    const idUmum = 'umum123';
    const idSpasial = 'spasial123';

    setUp(() {
      // Arrange - Setup form key dan inisialisasi mock dependencies
      formKey = GlobalKey<FormState>();

      mockAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockFirestore = MockFirebaseFirestore();
      userCollection = MockCollectionReference<Map<String, dynamic>>();
      userRef = MockDocumentReference<Map<String, dynamic>>();
      umumRef = MockDocumentReference<Map<String, dynamic>>();
      spasialCollection = MockCollectionReference<Map<String, dynamic>>();
      umumCollection = MockCollectionReference<Map<String, dynamic>>();
      spasialRef = MockDocumentReference<Map<String, dynamic>>();
      mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
      mockSupabase = MockSupabaseClient();
      mockStorageClient = MockSupabaseStorageClient();
      mockFileApi = MockStorageFileApi();
      mockTracer = MockPerformanceTracer();

      // Arrange - Inisialisasi controller dengan mock dependencies
      controller = UbahDataController(
        formKey: formKey,
        auth: mockAuth,
        firestore: mockFirestore,
        supabase: mockSupabase,
        storage: mockFileApi,
        tracer: mockTracer,
      );

      // Arrange - Isi data form
      controller.lokasiController.text = 'Lokasi Z';
      controller.kelurahanController.text = 'Kelurahan Z';
      controller.kecamatanController.text = 'Kecamatan Z';
      controller.kawasanController.text = 'Kawasan Z';
      controller.alamatController.text = 'Alamat Z';
      controller.rtController.text = '007';
      controller.rwController.text = '009';
      controller.panjangBentukController.text = '3.4675678019';
      controller.luasBentukController.text = '2.42786235e-80';
      controller.titikKoordinatController.text =
          '-1.0675789123654, 108.43215678943218';

      // Arrange - Tambahkan mock file foto
      final dummyFile =
          File(path.join(Directory.systemTemp.path, 'rumah-baru.jpg'));
      dummyFile.writeAsBytesSync(Uint8List.fromList([1, 2, 3, 4]));
      controller.fotoFiles.add(dummyFile);

      // Setup Firebase Auth
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('user123');

      // Setup Firestore user
      when(mockFirestore.collection('user')).thenReturn(userCollection);
      when(userCollection.doc('user123')).thenReturn(userRef);
      when(userRef.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.data())
          .thenReturn({'peran': 'admin', 'nama': 'Admin F'});

      // Setup Firestore umum & spasial
      when(mockFirestore.collection('data_spasial'))
          .thenReturn(spasialCollection);
      when(mockFirestore.collection('data_umum')).thenReturn(umumCollection);
      when(spasialCollection.doc(idSpasial)).thenReturn(spasialRef);
      when(umumCollection.doc(idUmum)).thenReturn(umumRef);
      when(spasialRef.update(any)).thenAnswer((_) async {});
      when(umumRef.update(any)).thenAnswer((_) async {});

      // Setup Supabase storage
      when(mockSupabase.storage).thenReturn(mockStorageClient);
      when(mockStorageClient.from('images')).thenReturn(mockFileApi);
      when(mockFileApi.uploadBinary(any, any,
              fileOptions: anyNamed('fileOptions')))
          .thenAnswer((_) async => 'uploaded_path');
      when(mockFileApi.getPublicUrl(any))
          .thenReturn('https://example.com/rumah-baru.jpg');
    });

    test('Ubah Data - Koordinat, Foto, Data Umum', () async {
      // Act - Membuat dummy BuildContext untuk kebutuhan pemanggilan fungsi
      final dummyContext = FakeBuildContext();

      // Act - Jalankan simpanPerubahan
      await controller.simpanPerubahan(idUmum, idSpasial, dummyContext);

      // Assert- Verifikasi file upload dan update
      verify(mockFileApi.uploadBinary(any, any,
              fileOptions: anyNamed('fileOptions')))
          .called(1);
      verify(mockFileApi.getPublicUrl(any)).called(1);

      verify(spasialRef.update(argThat(containsPair(
              'titik_koordinat', '-1.0675789123654, 108.43215678943218'))))
          .called(1);

      // Assert - Verifikasi update data umum dengan field yang sesuai
      verify(umumRef.update(argThat(allOf([
        containsPair('nama_lokasi', 'Lokasi Z'),
        containsPair('kelurahan', 'Kelurahan Z'),
        containsPair('kecamatan', 'Kecamatan Z'),
        containsPair('kawasan', 'Kawasan Z'),
        containsPair('alamat', 'Alamat Z'),
        containsPair('rt', '007'),
        containsPair('rw', '009'),
        containsPair('panjang_bentuk', '3.4675678019'),
        containsPair('luas_bentuk', '2.42786235e-80'),
        contains('foto_lokasi'),
      ])))).called(1);

      // Tidak ada log konfirmasi jika admin
      verifyNever(mockFirestore.collection('log_konfirmasi'));
    });
  });
}

// Dummy BuildContext
class FakeBuildContext implements BuildContext {
  @override
  bool get mounted => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
