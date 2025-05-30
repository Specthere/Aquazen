import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/volume_air_controller.dart';

class VolumeAirScreen extends StatelessWidget {
  const VolumeAirScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<VolumeAirController>(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Volume Air',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Status Controlling: ',
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(
                        text: controller.isControllingActive ? 'Aktif' : 'Nonaktif',
                        style: TextStyle(
                          color: controller.isControllingActive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Aktif 15 menit yang lalu',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 13),
                ),
              ],
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
                  color: controller.isNormal ? Colors.greenAccent : Colors.redAccent,
                  width: 8,
                ),
              ),
              child: Center(
                child: Text(
                  '${controller.volume.toInt()} L',
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
              'Status Volume Air: ${controller.isNormal ? "Normal" : "Kurang"}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: controller.isNormal ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
