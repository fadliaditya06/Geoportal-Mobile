import 'package:flutter/material.dart';
import 'package:geoportal_mobile/controllers/detail_peta_controller.dart';
import 'package:geoportal_mobile/screens/beranda_screen.dart';
import 'package:geoportal_mobile/screens/onboarding_screen.dart';
import 'package:geoportal_mobile/screens/auth/login_screen.dart';
import 'package:geoportal_mobile/screens/auth/register_screen.dart';
import 'package:geoportal_mobile/screens/peta/detail_konfirmasi_data_screen.dart';
import 'package:geoportal_mobile/screens/peta/peta_screen.dart';
import 'package:geoportal_mobile/screens/peta/tambah_data_screen.dart';
import 'package:geoportal_mobile/screens/profil/profil_screen.dart';
import 'package:geoportal_mobile/screens/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geoportal_mobile/config/firebase_options.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:geoportal_mobile/controllers/unduh_data_controller.dart';
import 'package:geoportal_mobile/screens/dev/load_test_tambah_page.dart';
import 'package:geoportal_mobile/screens/dev/load_test_ubah_page.dart';
import 'package:geoportal_mobile/screens/dev/load_test_hapus_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Aktifkan Firebase Performance Monitoring
  await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://noeywxxoxuyicxtcsier.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5vZXl3eHhveHV5aWN4dGNzaWVyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc1MzAwNTksImV4cCI6MjA2MzEwNjA1OX0.q-ktPox08DqxLUpotH74SeYwUdAwr93rKUsMmTi8GuY',
  );

  // Inisialisasi format tanggal untuk bahasa Indonesia
  await initializeDateFormatting('id', '');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UnduhDataController()),
        ChangeNotifierProvider(create: (_) => DetailPetaController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geoportal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF358666)),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: Color(0xFF358666)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id'),
        Locale('en'),
      ],

      // Daftar Routes
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnBoardingPage(),
        '/main': (context) => const MainPage(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/detail-konfirmasi': (context) => const DetailKonfirmasiDataScreen(),
        '/tambah-data': (context) => const TambahDataScreen(),
        '/load-test-tambah': (context) => const LoadTestTambahPage(), 
        '/load-test-ubah': (context) => const LoadTestUbahPage(),
        '/load-test-hapus': (context) => const LoadTestHapusPage(),
      },
    );
  }
}

// Navbar
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _pageIndex = 0;
  String? uid;
  String? role;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uid = user.uid;

      // Ambil peran user
      FirebaseFirestore.instance.collection('user').doc(uid).get().then((doc) {
        if (doc.exists) {
          setState(() {
            role = doc.data()?['peran'] ?? 'Pengguna';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (uid == null || role == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List<Widget> pages = [
      BerandaScreen(uid: uid!),
      PetaScreen(role: role),
      const ProfilScreen(),
    ];

    return Scaffold(
      body: pages[_pageIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: const Color(0xFF358666),
        height: 60,
        index: _pageIndex,
        items: const [
          Icon(Icons.home, color: Colors.white, size: 30),
          Icon(Icons.location_on, key: Key('navPeta'), color: Colors.white, size: 30),
          Icon(Icons.person, color: Colors.white, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }
}
