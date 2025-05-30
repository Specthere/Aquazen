import 'package:flutter/material.dart';

class BottomNavBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/ph.png',
            width: 24,
            height: 24,
            color: currentIndex == 1 ? Colors.teal : Colors.grey,
          ),
          label: 'pH Air',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/volume.png',
            width: 24,
            height: 24,
            color: currentIndex == 2 ? Colors.teal : Colors.grey,
          ),
          label: 'Volume Air',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/histori.png',
            width: 24,
            height: 24,
            color: currentIndex == 3 ? Colors.teal : Colors.grey,
          ),
          label: 'Histori',
        ),
      ],
    );
  }
}
