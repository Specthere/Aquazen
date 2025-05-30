import 'package:flutter/material.dart';
import '../controller/ph_controller.dart';
import '../model/ph_model.dart';
import '../service/mqtt_service.dart';

class PhAirScreen extends StatefulWidget {
  const PhAirScreen({super.key});

  @override
  State<PhAirScreen> createState() => _PhAirScreenState();
}

class _PhAirScreenState extends State<PhAirScreen> {
  final model = PhModel();
  late final PhController controller;

  @override
  void initState() {
    super.initState();
    controller = PhController(model, MqttService());
    controller.onUpdate = () => setState(() {});
    controller.connectMQTT();
  }

  @override
  Widget build(BuildContext context) {
    final isNormal = model.ph >= 6.5 && model.ph <= 8.5;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'pH Air',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                text: TextSpan(
                  text: 'Status Controlling : ',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(
                      text: isNormal ? 'Aktif' : 'Nonaktif',
                      style: TextStyle(
                        color: isNormal ? Colors.green : Colors.red,
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
