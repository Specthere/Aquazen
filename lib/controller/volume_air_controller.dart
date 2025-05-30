import 'package:flutter/material.dart';
import '../model/volume_air_model.dart';
import '../service/mqtt_service.dart';

class VolumeAirController extends ChangeNotifier {
  final VolumeAirModel _model = VolumeAirModel();
  final MqttService _mqttService = MqttService();

  VolumeAirController() {
    _mqttService.onVolumeReceived = (double newVolume) {
      _model.volume = newVolume;
      notifyListeners();
    };

    _mqttService.connect();
  }

  double get volume => _model.volume;
  bool get isNormal => _model.isNormal;
  bool get isControllingActive => _model.isControllingActive;

  void toggleControllingStatus() {
    _model.isControllingActive = !_model.isControllingActive;
    notifyListeners();
  }
}
