import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ZXApp());
}

class ZXApp extends StatelessWidget {
  const ZXApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZX FF Tour',
      theme: ThemeData(primarySwatch: Colors.red, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZX FF TOUR', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.account_balance_wallet), onPressed: () {})],
      ),
      body: _index == 0 ? const TournamentList() : _index == 1 ? const MyMatches() : const ProfileScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        selectedItemColor: Colors.red,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: 'Tournaments'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'My Matches'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class TournamentList extends StatelessWidget {
  const TournamentList({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tournaments').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        if (snapshot.data!.docs.isEmpty) return _demoList(context);
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, i) {
            var d = snapshot.data!.docs[i].data() as Map<String, dynamic>;
            return _card(context, d['title'] ?? 'FF Tournament', 'Entry: ${d['entryFee'] ?? 50}৳ | Prize: ${d['prize'] ?? 500}৳', d['time'] ?? 'Today 8 PM');
          },
        );
      },
    );
  }
  Widget _demoList(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(12), children: [
      _card(context, 'ZX Solo - Daily Custom', 'Entry: 30৳ | Prize: 300৳ | Per Kill 20৳', 'Today 8:00 PM'),
      _card(context, 'ZX Duo - Evening Blast', 'Entry: 50৳ | Prize: 500৳ | Per Kill 30৳', 'Today 9:30 PM'),
      _card(context, 'ZX Full Map - Weekend Special', 'Entry: 100৳ | Prize: 1000৳ | Per Kill 50৳', 'Saturday 8:00 PM'),
      const Padding(padding: EdgeInsets.all(16), child: Text('Firebase থেকে Tournament আসবে। Admin থেকে add করলে এখানে দেখা যাবে।', textAlign: TextAlign.center)),
    ]);
  }
  Widget _card(BuildContext context, String title, String subtitle, String time) {
    return Card(elevation: 4, margin: const EdgeInsets.only(bottom: 12), child: ListTile(
      leading: CircleAvatar(backgroundColor: Colors.red, child: const Icon(Icons.local_fire_department, color: Colors.white)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('$subtitle\n$time'),
      isThreeLine: true,
      trailing: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Join Request Sent! Admin Approve করবে')));
      }, child: const Text('JOIN')),
    ));
  }
}

class MyMatches extends StatelessWidget {
  const MyMatches({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('তুমি এখনো কোনো ম্যাচে Join করো নাই'));
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const CircleAvatar(radius: 50, backgroundColor: Colors.red, child: Icon(Icons.person, size: 60, color: Colors.white)),
      const SizedBox(height: 16),
      const Text('ZX Player', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const Text('Wallet: 0৳ | Wins: 0'),
      const SizedBox(height: 20),
      ElevatedButton(onPressed: () async { await FirebaseAuth.instance.signInAnonymously(); }, child: const Text('Login / Guest Login')),
    ]));
  }
}
