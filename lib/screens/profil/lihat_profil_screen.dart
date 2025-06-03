import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LihatProfilScreen extends StatefulWidget {
  const LihatProfilScreen({super.key});

  @override
  State<LihatProfilScreen> createState() => _LihatProfilScreenState();
}

class _LihatProfilScreenState extends State<LihatProfilScreen> {
  late Future<Map<String, dynamic>?> userDataFuture;

  @override
  void initState() {
    super.initState();
    userDataFuture = getUserData();
  }

  // Fungsi untuk mengambil data user berdasarkan uid yang sedang login
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        DocumentSnapshot doc =
            await FirebaseFirestore.instance.collection('user').doc(uid).get();
        if (doc.exists) {
          return doc.data() as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error ambil data user: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Lihat Profil",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        backgroundColor: const Color(0xFFB0E1C6),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          // Gradien Background
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3, 0.6, 1.0],
            colors: [
              const Color(0xFFB0E1C6),
              const Color(0xFF72B396).withOpacity(0.31),
              const Color(0xFF358666).withOpacity(0.60),
              const Color(0xFFFFFFFF).withOpacity(0.98),
            ],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<Map<String, dynamic>?>(
            future: userDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('Data user tidak ditemukan'));
              } else {
                final data = snapshot.data!;
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 40, bottom: 40),
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: const Color(0xFF358666),
                        backgroundImage: data['foto_profil'] != null &&
                                data['foto_profil'].toString().isNotEmpty
                            ? NetworkImage(data['foto_profil'])
                            : null,
                        child: data['foto_profil'] == null ||
                                data['foto_profil'].toString().isEmpty
                            ? const Icon(Icons.person,
                                size: 100, color: Colors.white)
                            : null,
                      ),
                    ),
                    // Box Container Profil
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        width: double.infinity,
                        padding:
                            const EdgeInsets.only(top: 40, left: 20, right: 20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30)),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ProfilItem(
                                label: "Email",
                                value: data['email'] ?? 'Tidak ada email',
                                icon: Icons.email_outlined,
                              ),
                              _ProfilItem(
                                label: "Nama Lengkap",
                                value: data['nama'] ?? 'Tidak ada nama',
                                icon: Icons.person_outlined,
                              ),
                              _ProfilItem(
                                label: "Alamat",
                                value: data['alamat'] ?? 'Tidak ada alamat',
                                icon: Icons.home_outlined,
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

// Widget untuk menampilkan konten profil
class _ProfilItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProfilItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFB0E1C6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 20,
              ),
              leading: Icon(icon, color: Colors.black),
              title: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
