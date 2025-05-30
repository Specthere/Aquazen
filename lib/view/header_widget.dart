import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:provider/provider.dart';
import '../service/auth_service.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  bool isMenuOpen = false;

  Future<void> showLogoutMenu(BuildContext context, Offset offset) async {
    final BuildContext localContext = context; // ✅ simpan sebelum await
    final RenderBox overlay =
        Overlay.of(localContext).context.findRenderObject() as RenderBox;

    setState(() {
      isMenuOpen = true;
    });

    final selected = await showMenu<String>(
      context: localContext,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(offset.dx, offset.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      items: [
        const PopupMenuItem<String>(
          value: 'profile',
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            title: Text('Imam'),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Text('Logout', style: TextStyle(color: Colors.red)),
        ),
      ],
    );

    if (!mounted) return;

    setState(() {
      isMenuOpen = false;
    });

    
    if (selected == 'logout') {
      if (!mounted) return;

      showDialog(
        context: localContext,
        builder: (dialogContext) => AlertDialog(
          title: const Text("Logout"),
          content: const Text("Apakah Anda yakin ingin logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Tidak"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // tutup dialog
                await Provider.of<AuthService>(dialogContext, listen: false)
                    .logout();
                Navigator.pushReplacement(
                  dialogContext,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Ya"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      color: const Color(0xFF35B9C7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Hello,\nBapak Imam!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTapDown: (TapDownDetails details) {
              showLogoutMenu(context, details.globalPosition);
            },
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                const SizedBox(width: 5),
                Icon(
                  isMenuOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
