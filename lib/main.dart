import 'package:flutter/material.dart';
import 'package:geoportal_mobile/screens/beranda_screen.dart';
import 'package:geoportal_mobile/screens/onboarding_screen.dart';
import 'package:geoportal_mobile/screens/auth/login_screen.dart';
import 'package:geoportal_mobile/screens/auth/register_screen.dart';
import 'package:geoportal_mobile/screens/peta/detail_konfirmasi_data_screen.dart';
import 'package:geoportal_mobile/screens/peta/peta_screen.dart';
import 'package:geoportal_mobile/screens/profil/profil_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geoportal_mobile/config/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Inisialisasi format tanggal untuk bahasa Indonesia
  await initializeDateFormatting('id', '');
  runApp(const MyApp());
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
        useMaterial3: true,
      ),
      // home: const OnBoardingPage(), 
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      // Daftar Routes 
      routes: {
        '/': (context) => const OnBoardingPage(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/detail-konfirmasi': (context) => const DetailKonfirmasiDataScreen(),
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

  final List<Widget> _pages = [
    const BerandaScreen(),
    const PetaScreen(),
    const ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex], 
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: const Color(0xFF358666),
        height: 60,
        index: _pageIndex,
        items: const [
          Icon(Icons.home, color: Colors.white, size: 30),
          Icon(Icons.location_on, color: Colors.white, size: 30),
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
