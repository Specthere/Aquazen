import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controller/history_controller.dart';
import '../model/history_model.dart';

class HistoriScreen extends StatefulWidget {
  const HistoriScreen({super.key});

  @override
  State<HistoriScreen> createState() => _HistoriScreenState();
}

class _HistoriScreenState extends State<HistoriScreen> {
  final HistoriController controller = HistoriController();
  DateTime selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  late Future<List<HistoriModel>> historyFuture;

  @override
  void initState() {
    super.initState();
    historyFuture = controller.fetchHistory(selectedMonth);
  }

  void updateMonth(DateTime newMonth) {
    setState(() {
      selectedMonth = newMonth;
      historyFuture = controller.fetchHistory(newMonth);
    });
  }

  static Color _getPhColor(int ph) {
    if (ph <= 6) return Colors.orange;
    if (ph == 7) return Colors.green;
    if (ph >= 8 && ph <= 13) return Colors.purple;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<List<HistoriModel>>(
          future: historyFuture,
          builder: (context, snapshot) {
            final dataTabel = snapshot.data ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Histori',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text('Filter bulan: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      DropdownButton<DateTime>(
                        value: selectedMonth,
                        items: List.generate(12, (index) {
                          final now = DateTime.now();
                          final month = DateTime(now.year, index + 1);
                          return DropdownMenuItem(
                            value: month,
                            child: Text(DateFormat('MMMM yyyy').format(month)),
                          );
                        }),
                        onChanged: (value) {
                          if (value != null) updateMonth(value);
                        },
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: dataTabel.isNotEmpty
                            ? () => controller.exportToPdf(dataTabel, selectedMonth)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.black),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Export PDF', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  snapshot.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator())
                      : dataTabel.isEmpty
                          ? const Center(child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text('Belum ada data histori.'),
                            ))
                          : DataTable(
                              columns: const [
                                DataColumn(label: Text('Kadar pH')),
                                DataColumn(label: Text('Volume Air')),
                                DataColumn(label: Text('Tanggal')),
                              ],
                              rows: dataTabel.map((data) {
                                final phVal = int.tryParse(data.ph) ?? 0;
                                return DataRow(cells: [
                                  DataCell(Text(data.ph, style: TextStyle(color: _getPhColor(phVal)))),
                                  DataCell(Text(data.volume, style: const TextStyle(color: Colors.green))),
                                  DataCell(Text(data.tanggal)),
                                ]);
                              }).toList(),
                            ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
