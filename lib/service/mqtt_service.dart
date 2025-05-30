import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MqttService {
  final _client = MqttServerClient(
    '192.168.105.129',
    'flutter_client',
  );

  final topic = 'esp32/sensor';

  Function(double ph)? onPhReceived;
  Function(double volume)? onVolumeReceived;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> connect() async {
    _client.port = 1883;
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = () => print('Disconnected');
    _client.onConnected = () => print('Connected');
    _client.onSubscribed = (t) => print('Subscribed to $t');
    _client.logging(on: false);

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .startClean();

    _client.connectionMessage = connMessage;

    try {
      await _client.connect();
    } catch (e) {
      print('Connection failed: $e');
      _client.disconnect();
      return;
    }

    _client.subscribe(topic, MqttQos.atMostOnce);

    _client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(
        recMess.payload.message,
      );

      try {
        final data = jsonDecode(payload);

        double? ph;
        double? volume;

        if (data.containsKey('ph')) {
          ph = (data['ph'] as num).toDouble();
          onPhReceived?.call(ph);
        }

        if (data.containsKey('volume')) {
          volume = (data['volume'] as num).toDouble();
          onVolumeReceived?.call(volume);
        }

        if (ph != null && volume != null) {
          _saveDataToHistoryIfMidnight(ph, volume);
        }
      } catch (e) {
        print('Error parsing MQTT message: $e');
      }
    });
  }

  Future<void> _saveDataToHistoryIfMidnight(double ph, double volume) async {
    final now = DateTime.now();

    if (now.hour == 23 && now.minute == 36) {
      final midnight = DateTime(now.year, now.month, now.day);
      final docId = DateFormat('yyyy-MM-dd').format(midnight);

      final docRef = _firestore.collection('history').doc(docId);
      final doc = await docRef.get();

      if (!doc.exists) {
        await docRef.set({
          'ph': ph,
          'volume': volume,
          'timestamp': Timestamp.fromDate(midnight),
        });
        print('Saved history for $docId');
      } else {
        print('History for $docId already exists');
      }
    }
  }
}
