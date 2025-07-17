import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geoportal_mobile/controllers/tambah_data_controller.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geoportal_mobile/services/performance_tracer.dart';
import 'package:geoportal_mobile/widgets/custom_snackbar.dart';
import 'tambah_data_controller_test.mocks.dart';

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
  group('TambahDataController Test', () {
    late TambahDataController controller;
    late MockFirebaseAuth mockAuth;
    late MockUser mockUser;
    late MockFirebaseFirestore mockFirestore;
    late MockSupabaseClient mockSupabase;
    late MockStorageFileApi mockStorage;
    late MockSupabaseStorageClient mockSupabaseStorage;
    late MockPerformanceTracer mockTracer;

    late MockCollectionReference<Map<String, dynamic>> userCollection;
    late MockCollectionReference<Map<String, dynamic>> spasialCollection;
    late MockCollectionReference<Map<String, dynamic>> umumCollection;

    late MockDocumentReference<Map<String, dynamic>> mockDocument;
    late MockDocumentSnapshot<Map<String, dynamic>> mockSnapshot;

    final testFormKey = GlobalKey<FormState>();
    late BuildContext fakeContext;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockFirestore = MockFirebaseFirestore();
      mockSupabase = MockSupabaseClient();
      mockSupabaseStorage = MockSupabaseStorageClient();
      mockStorage = MockStorageFileApi();
      mockTracer = MockPerformanceTracer();

      userCollection = MockCollectionReference<Map<String, dynamic>>();
      spasialCollection = MockCollectionReference<Map<String, dynamic>>();
      umumCollection = MockCollectionReference<Map<String, dynamic>>();

      mockDocument = MockDocumentReference<Map<String, dynamic>>();
      mockSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
      controller = TambahDataController(
        lokasiController: TextEditingController(text: 'Lokasi F'),
        kelurahanController: TextEditingController(text: 'Kelurahan F'),
        kecamatanController: TextEditingController(text: 'Kecamatan A'),
        kawasanController: TextEditingController(text: 'Kawasan F'),
        alamatController: TextEditingController(text: 'Alamat A'),
        rtController: TextEditingController(text: '001'),
        rwController: TextEditingController(text: '002'),
        panjangBentukController: TextEditingController(text: '0.1005678910'),
        luasBentukController: TextEditingController(text: '1.52786353e-08'),
        titikKoordinatController: TextEditingController(
          text: '1.0276789123456, 104.12345678901234',
        ),
        formKey: testFormKey,
        firestore: mockFirestore,
        auth: mockAuth,
        supabase: mockSupabase,
        storage: mockStorage,
        tracer: mockTracer,
      );

      // Tambahkan foto dummy
      final dummyFile = File(path.join(Directory.systemTemp.path, 'rumah.jpg'));
      dummyFile.writeAsBytesSync(Uint8List.fromList([0, 1, 2, 3]));
      controller.fotoFiles.add(dummyFile);

      // Buat context palsu
      final scaffoldKey = GlobalKey<ScaffoldState>();
      fakeContext = scaffoldKey.currentContext ?? FakeBuildContext();
    });

    test('Tambah Data - Koordinat, Foto, Data Umum', () async {
      // Arrange - Setup semua mock dan input
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('user123');

      // Mock user data
      when(mockFirestore.collection('user')).thenReturn(userCollection);
      when(userCollection.doc('user123')).thenReturn(mockDocument);
      when(mockDocument.get()).thenAnswer((_) async => mockSnapshot);
      when(
        mockSnapshot.data(),
      ).thenReturn({'peran': 'admin', 'nama': 'Admin F'});

      // Mock Firestore
      when(
        mockFirestore.collection('data_spasial'),
      ).thenReturn(spasialCollection);
      when(spasialCollection.add(any)).thenAnswer((_) async => mockDocument);
      when(mockDocument.id).thenReturn('spasial123');

      when(mockFirestore.collection('data_umum')).thenReturn(umumCollection);
      when(umumCollection.doc()).thenReturn(mockDocument);
      when(mockDocument.set(any)).thenAnswer((_) async => {});
      when(mockDocument.id).thenReturn('umum123');

      // Mock Supabase storage
      when(mockSupabase.storage).thenReturn(mockSupabaseStorage);
      when(mockSupabaseStorage.from('images')).thenReturn(mockStorage);
      when(
        mockStorage.uploadBinary(
          any,
          any,
          fileOptions: anyNamed('fileOptions'),
        ),
      ).thenAnswer((_) async => 'uploaded_file_url');
      when(
        mockStorage.getPublicUrl(any),
      ).thenReturn('https://example.com/rumah.jpg');

      // Act - Jalankan simpanData
      await controller.simpanData(fakeContext);

      // Assert - Verifikasi
      verify(
        mockStorage.uploadBinary(
          any,
          any,
          fileOptions: anyNamed('fileOptions'),
        ),
      ).called(1);
      verify(mockStorage.getPublicUrl(any)).called(1);
      verify(spasialCollection.add(any)).called(1);
      verify(umumCollection.doc()).called(1);
      verify(mockDocument.set(any)).called(1);
      verifyNever(mockFirestore.collection('log_konfirmasi'));
    });
  });
}

// Dummy BuildContext untuk testing non-UI
class FakeBuildContext implements BuildContext {
  @override
  bool get mounted => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
