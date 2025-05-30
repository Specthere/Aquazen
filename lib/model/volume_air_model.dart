class VolumeAirModel {
  double volume;
  bool isControllingActive;

  VolumeAirModel({this.volume = 0.0, this.isControllingActive = false});

  bool get isNormal => volume >= 150;
}
