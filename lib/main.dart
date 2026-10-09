import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constrants/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yuss App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeContent(),
    SettingsContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yuss App'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // HEADER
          const Expanded(
            flex: 1,
            child: LayoutBox(name: 'Header', color: AppColors.header),
          ),
          const SizedBox(height: 8),

          // BODY (split kiri - kanan)
          Expanded(
            flex: 4,
            child: Row(
              children: const [
                // Kiri (menu link)
                Expanded(
                  flex: 1,
                  child: SidebarMenu(),
                ),
                SizedBox(width: 8),

                // Kanan (fitur kirim pesan)
                Expanded(
                  flex: 2,
                  child: ChatBox(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // FOOTER
          const Expanded(
            flex: 1,
            child: LayoutBox(name: 'Footer', color: AppColors.footer),
          ),
        ],
      ),
    );
  }
}

class LayoutBox extends StatelessWidget {
  final String name;
  final Color color;

  const LayoutBox({
    super.key,
    required this.name,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        name,
        style: const TextStyle(
          color: AppColors.textOnDark,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// SIDEBAR: tombol buka link (url_launcher)
// ---------------------------------------------------------------
class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  // Fungsi untuk membuka link
  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final success = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak bisa membuka link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.sidebar,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Sidebar',
              style: TextStyle(
                color: AppColors.textOnDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _MenuButton(
              icon: Icons.public,
              label: 'Website',
              onTap: () => _openUrl(context, 'https://flutter.dev'),
            ),
            const SizedBox(height: 8),
            _MenuButton(
              icon: Icons.code, // ikon GitHub tidak ada bawaan, pakai code
              label: 'GitHub',
              onTap: () => _openUrl(
                context,
                'https://github.com/niuswicaksono-max',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white24,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Icon(icon, color: AppColors.textOnDark),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textOnDark,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBox extends StatefulWidget {
  const ChatBox({super.key});

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return; // jangan kirim kalau kosong

    setState(() {
      _messages.add(text);
    });
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.chatBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.chatBorder, width: 2),
      ),
      child: Column(
        children: [
          // DAFTAR PESAN
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text('Belum ada pesan'))
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.chatBubble,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _messages[index],
                            style: const TextStyle(
                              color: AppColors.textOnDark,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // INPUT + TOMBOL KIRIM
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onSubmitted: (_) => _sendMessage(), // tekan Enter = kirim
                  decoration: const InputDecoration(
                    hintText: 'Tulis pesan...',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings'),
    );
  }
}