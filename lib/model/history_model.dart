class HistoriModel {
  final String ph;
  final String volume;
  final String tanggal;

  HistoriModel({
    required this.ph,
    required this.volume,
    required this.tanggal,
  });

  factory HistoriModel.fromMap(Map<String, dynamic> data) {
    return HistoriModel(
      ph: data['ph'].toString(),
      volume: '${data['volume']} L',
      tanggal: data['tanggal'],
    );
  }
}
