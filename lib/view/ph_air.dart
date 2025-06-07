import 'package:flutter/material.dart';
import '../controller/ph_controller.dart';
import '../model/ph_model.dart';
import '../service/mqtt_service.dart';
import '../service/notification_service.dart'; // ✅ Import notifikasi

class PhAirScreen extends StatefulWidget {
  const PhAirScreen({super.key});

  @override
  State<PhAirScreen> createState() => _PhAirScreenState();
}

class _PhAirScreenState extends State<PhAirScreen> {
  final model = PhModel();
  late final PhController controller;
  String statusRelay = 'Tidak Aktif';
  DateTime? lastNotifiedTime;

  @override
  void initState() {
    super.initState();
    final service = MqttService();
    controller = PhController(model, service);
    controller.onUpdate = () => setState(() {}); // update UI pH

    controller.connectMQTT();

    service.onStatusReceived = (status) {
      final newStatus = status.toLowerCase().contains('relay') ? 'Aktif' : 'Tidak Aktif';

      setState(() {
        statusRelay = newStatus;
      });

      // Tampilkan notifikasi status controlling, dengan debounce 30 detik
      final now = DateTime.now();
      if (lastNotifiedTime == null || now.difference(lastNotifiedTime!) > const Duration(seconds: 30)) {
        NotificationService.showNotification(
          "AquaZen",
          "Status controlling pH air: $newStatus",
        );
        lastNotifiedTime = now;
      }
    };
  }



  @override
  Widget build(BuildContext context) {
    final isNormal = model.ph >= 6.5 && model.ph <= 8.5;

    return Scaffold(
      appBar: AppBar(title: const Text('pH Air')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                text: TextSpan(
                  text: 'Status Controlling: ',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(
                      text: statusRelay,
                      style: TextStyle(
                        color: statusRelay == 'Aktif' ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isNormal ? Colors.green : Colors.red,
                    width: 8,
                  ),
                ),
                child: Center(
                  child: Text(
                    model.ph.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: isNormal ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'Status pH Air: ${isNormal ? "Normal" : "Tidak Normal"}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isNormal ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
