import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../model/history_model.dart';

class HistoriController {
  final CollectionReference historyCollection =
      FirebaseFirestore.instance.collection('history');

  Future<List<HistoriModel>> fetchHistory(DateTime selectedMonth) async {
    final startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final endOfMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 1);

    final snapshot = await historyCollection
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('timestamp', isLessThan: Timestamp.fromDate(endOfMonth))
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return HistoriModel.fromMap({
        'ph': data['ph'],
        'volume': data['volume'],
        'tanggal': DateFormat('dd-MM-yyyy').format((data['timestamp'] as Timestamp).toDate()),
      });
    }).toList();
  }

  Future<void> exportToPdf(List<HistoriModel> dataTabel, DateTime bulan) async {
    final pdf = pw.Document();
    final bulanStr = DateFormat('MMMM yyyy').format(bulan);

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Laporan Histori Bulan $bulanStr',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: ['Tanggal', 'pH Air', 'Volume'],
              data: dataTabel.map((row) {
                return [row.tanggal, row.ph, row.volume];
              }).toList(),
              cellAlignment: pw.Alignment.center,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              border: pw.TableBorder.all(),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
