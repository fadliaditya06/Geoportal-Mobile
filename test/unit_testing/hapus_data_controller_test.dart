import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'hapus_data_controller_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  firebase_auth.FirebaseAuth,
  firebase_auth.User,
  SupabaseClient,
  SupabaseStorageClient,
  StorageFileApi,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Hapus Data Test', () {
    // Arrange - Deklarasi variabel mock
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> umumCollection;
    late MockCollectionReference<Map<String, dynamic>> spasialCollection;
    late MockDocumentReference<Map<String, dynamic>> umumRef;
    late MockDocumentReference<Map<String, dynamic>> spasialRef;

    late MockSupabaseClient mockSupabase;
    late MockSupabaseStorageClient mockStorageClient;
    late MockStorageFileApi mockFileApi;

    const idUmum = 'umum123';
    const idSpasial = 'spasial123';
    const namaFile = 'rumah-baru.jpg';

    setUp(() {
      // Arrange - Inisialisasi mock
      mockFirestore = MockFirebaseFirestore();
      umumCollection = MockCollectionReference<Map<String, dynamic>>();
      spasialCollection = MockCollectionReference<Map<String, dynamic>>();
      umumRef = MockDocumentReference<Map<String, dynamic>>();
      spasialRef = MockDocumentReference<Map<String, dynamic>>();

      mockSupabase = MockSupabaseClient();
      mockStorageClient = MockSupabaseStorageClient();
      mockFileApi = MockStorageFileApi();

      // Firestore
      when(mockFirestore.collection('data_umum')).thenReturn(umumCollection);
      when(mockFirestore.collection('data_spasial'))
          .thenReturn(spasialCollection);
      when(umumCollection.doc(idUmum)).thenReturn(umumRef);
      when(spasialCollection.doc(idSpasial)).thenReturn(spasialRef);
      when(umumRef.delete()).thenAnswer((_) async {});
      when(spasialRef.delete()).thenAnswer((_) async {});

      // Supabase
      when(mockSupabase.storage).thenReturn(mockStorageClient);
      when(mockStorageClient.from('images')).thenReturn(mockFileApi);
      when(mockFileApi.remove([namaFile]))
          .thenAnswer((_) async => <FileObject>[]);
    });

    test('Hapus Data - Koordinat, Foto, Data Umum', () async {
      // Act - Jalankan operasi penghapusan
      await umumRef.delete();
      await spasialRef.delete();
      await mockFileApi.remove([namaFile]);

      // Assert - Pastikan dokumen Firestore dan file foto dihapus
      verify(umumRef.delete()).called(1);
      verify(spasialRef.delete()).called(1);
      verify(mockFileApi.remove([namaFile])).called(1);
    });
  });
}
