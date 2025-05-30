import '../model/ph_model.dart';
import '../service/mqtt_service.dart';
import 'package:flutter/material.dart';

class PhController extends ChangeNotifier {
  final PhModel model;
  final MqttService mqttService;

  VoidCallback? onUpdate;

  PhController(this.model, this.mqttService) {
    mqttService.onPhReceived = (ph) {
      model.ph = ph;
      onUpdate?.call();
      notifyListeners(); // ini buat Provider
    };
  }

  void connectMQTT() {
    mqttService.connect();
  }
}
