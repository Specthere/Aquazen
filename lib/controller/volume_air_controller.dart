import 'package:flutter/material.dart';
import '../model/volume_air_model.dart';
import '../service/mqtt_service.dart';
import '../service/notification_service.dart';


class VolumeAirController extends ChangeNotifier {
  final VolumeAirModel _model = VolumeAirModel();
  final MqttService _mqttService = MqttService();

  VolumeAirController() {
    _mqttService.onVolumeReceived = (double newVolume) {
      setVolume(newVolume);
    };

    _mqttService.connect();
  }

  double get volume => _model.volume;
  bool get isNormal => _model.isNormal;
  bool get isControllingActive => _model.isControllingActive;
  bool checkVolumeStatus(double volume) {
  return volume >= 10 && volume <= 100; // bisa kamu sesuaikan sendiri ambang batasnya
}


  void toggleControllingStatus() {
    _model.isControllingActive = !_model.isControllingActive;
    notifyListeners();

    // Tampilkan notif saat status controlling berubah
    NotificationService.showNotification(
      'Status Controlling',
      _model.isControllingActive ? 'Controlling Aktif' : 'Controlling Tidak Aktif',
    );
  }

  void setVolume(double newVolume) {
    _model.volume = newVolume;
    _model.isControllingActive = true;
    notifyListeners();
  }
}
