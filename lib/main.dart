import 'package:flutter/material.dart';

void main() {
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
      ),
      body: _index == 0 ? const TournamentList() : _index == 1 ? const Center(child: Text('তুমি এখনো কোনো ম্যাচে Join করো নাই')) : const Center(child: Text('ZX Player\nWallet: 0b | Wins: 0')),
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
    return ListView(padding: const EdgeInsets.all(12), children: [
      _card(context, 'ZX Solo - Daily Custom', 'Entry: 30b | Prize: 300b | Per Kill 20b', 'Today 8:00 PM'),
      _card(context, 'ZX Duo - Evening Blast', 'Entry: 50b | Prize: 500b | Per Kill 30b', 'Today 9:30 PM'),
      _card(context, 'ZX Full Map - Weekend Special', 'Entry: 100b | Prize: 1000b | Per Kill 50b', 'Saturday 9:00 PM'),
    ]);
  }
  Widget _card(BuildContext context, String title, String subtitle, String time) {
    return Card(elevation: 4, margin: const EdgeInsets.only(bottom: 12), child: ListTile(
      leading: const CircleAvatar(backgroundColor: Colors.red, child: Icon(Icons.local_fire_department, color: Colors.white)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('$subtitle\n$time'),
      isThreeLine: true,
      trailing: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Join Request Sent!'))); }, child: const Text('JOIN')),
    ));
  }
}
