import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrescriptionPage extends StatelessWidget {
  const PrescriptionPage({Key? key}) : super(key: key);

  final List<Map<String, String>> prescriptions = const [
    {"Medicine": "Aspirin", "Dosage": "75 mg (Once a day)", "Timing": "After Lunch (AL)"},
    {"Medicine": "Dolo 650", "Dosage": "650 mg (Twice a day)", "Timing": "After Breakfast & Dinner (AB, AD)"},
    {"Medicine": "Cetirizine", "Dosage": "10 mg (Once a day)", "Timing": "Before Sleep (BS)"},
    {"Medicine": "Paracetamol", "Dosage": "500 mg (Three times a day)", "Timing": "After Meals"},
    {"Medicine": "Ibuprofen", "Dosage": "400 mg (Twice a day)", "Timing": "After Breakfast & Dinner"},
    {"Medicine": "Amoxicillin", "Dosage": "250 mg (Three times a day)", "Timing": "After Meals"},
    {"Medicine": "Pantoprazole", "Dosage": "40 mg (Once a day)", "Timing": "Before Breakfast"},
    {"Medicine": "Vitamin D3", "Dosage": "60000 IU (Once a week)", "Timing": "After Lunch"},
    {"Medicine": "Azithromycin", "Dosage": "500 mg (Once a day)", "Timing": "After Lunch"},
    {"Medicine": "Levocetirizine", "Dosage": "5 mg (Once a day)", "Timing": "Before Sleep"},
    {"Medicine": "Metformin", "Dosage": "500 mg (Twice a day)", "Timing": "After Breakfast & Dinner"},
    {"Medicine": "Atorvastatin", "Dosage": "10 mg (Once a day)", "Timing": "Before Sleep"},
    {"Medicine": "Losartan", "Dosage": "50 mg (Once a day)", "Timing": "After Breakfast"},
    {"Medicine": "Omeprazole", "Dosage": "20 mg (Once a day)", "Timing": "Before Breakfast"},
    {"Medicine": "Ciprofloxacin", "Dosage": "500 mg (Twice a day)", "Timing": "After Meals"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B355A),
        title: const Text('Medi-Connect'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Text(
              'Prescriptions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B355A),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 30,
                    headingRowColor: MaterialStateColor.resolveWith(
                          (states) => const Color(0xFF1B355A),
                    ),
                    headingTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    dataTextStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                    columns: const [
                      DataColumn(label: Text('Medicine')),
                      DataColumn(label: Text('Dosage & Frequency')),
                      DataColumn(label: Text('Timing')),
                    ],
                    rows: prescriptions.map((prescription) {
                      return DataRow(cells: [
                        DataCell(Text(prescription["Medicine"]!)),
                        DataCell(Text(prescription["Dosage"]!)),
                        DataCell(Text(prescription["Timing"]!)),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await generateAndDownloadPdf();
                },
                child: const Text(
                  'Download PDF',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> generateAndDownloadPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'Prescription List',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Medicine', 'Dosage & Frequency', 'Timing'],
                data: prescriptions.map((item) => [
                  item['Medicine'],
                  item['Dosage'],
                  item['Timing'],
                ]).toList(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellAlignment: pw.Alignment.centerLeft,
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
    );
  }
}
