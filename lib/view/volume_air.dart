import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/volume_air_controller.dart';
import '../service/mqtt_service.dart';
import '../service/notification_service.dart';

class VolumeAirScreen extends StatefulWidget {
  const VolumeAirScreen({super.key});

  @override
  State<VolumeAirScreen> createState() => _VolumeAirScreenState();
}

class _VolumeAirScreenState extends State<VolumeAirScreen> {
  String statusRelay = 'Tidak Aktif';
  late final MqttService service;
  late final VolumeAirController controller;

  @override
  void initState() {
    super.initState();

    final service = MqttService();
    final controller = Provider.of<VolumeAirController>(context, listen: false);

    // update volume setiap terima data sensor
    service.onVolumeReceived = (volume) {
      controller.setVolume(volume);
    };

    // ubah statusRelay dan tampilkan notif controlling
    service.onStatusReceived = (status) {
      final newStatus = status.toLowerCase().contains('relay') ? 'Aktif' : 'Tidak Aktif';

      setState(() {
        statusRelay = newStatus;
      });

      // Tampilkan notifikasi status controlling
      NotificationService.showNotification(
        'AquaZen',
        'Status controlling volume air: $newStatus',
      );
    };

    service.connect();
  }


  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<VolumeAirController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Volume Air')),
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
                        color:
                            statusRelay == 'Aktif' ? Colors.green : Colors.red,
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
                    color:
                        controller.isNormal
                            ? Colors.greenAccent
                            : Colors.redAccent,
                    width: 8,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${controller.volume.toInt()} CM³',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: controller.isNormal ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'Status Volume Air: ${controller.isNormal ? "Normal" : "Tidak Normal"}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: controller.isNormal ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
