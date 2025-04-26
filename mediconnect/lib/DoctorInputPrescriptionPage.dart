import 'package:flutter/material.dart';

class DoctorPrescriptionInputPage extends StatefulWidget {
  const DoctorPrescriptionInputPage({Key? key}) : super(key: key);

  @override
  _DoctorPrescriptionInputPageState createState() => _DoctorPrescriptionInputPageState();
}

class _DoctorPrescriptionInputPageState extends State<DoctorPrescriptionInputPage> {
  List<Map<String, TextEditingController>> prescriptions = [];

  @override
  void initState() {
    super.initState();
    // Start with one empty prescription row
    addPrescriptionRow();
  }

  void addPrescriptionRow() {
    prescriptions.add({
      "Medicine": TextEditingController(),
      "Dosage": TextEditingController(),
      "Timing": TextEditingController(),
    });
    setState(() {});
  }

  void savePrescriptions() {
    // You can modify this function to save to Supabase or your backend
    for (var prescription in prescriptions) {
      print("Medicine: ${prescription['Medicine']!.text}");
      print("Dosage: ${prescription['Dosage']!.text}");
      print("Timing: ${prescription['Timing']!.text}");
      print('---');
    }
    // Show a simple success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Prescriptions saved successfully!')),
    );
  }

  @override
  void dispose() {
    for (var prescription in prescriptions) {
      prescription.values.forEach((controller) => controller.dispose());
    }
    super.dispose();
  }

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
              'Write Prescription',
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
                        DataCell(TextField(
                          controller: prescription["Medicine"],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter medicine',
                          ),
                        )),
                        DataCell(TextField(
                          controller: prescription["Dosage"],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter dosage',
                          ),
                        )),
                        DataCell(TextField(
                          controller: prescription["Timing"],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter timing',
                          ),
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: addPrescriptionRow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Add Medicine'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: savePrescriptions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Save Prescription'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
