import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heapp/globals/gobals.dart';
import 'package:heapp/services/crud/services/crud_service.dart';
import 'package:heapp/services/crud/models/users_and_records.dart';

class MedicationListView extends StatefulWidget {
  final String userId;
  const MedicationListView({super.key, required this.userId});

  @override
  State<MedicationListView> createState() => _MedicationListViewState();
}

class _MedicationListViewState extends State<MedicationListView> {
  late Future<List<MedicationType>> _medications;
  List<MedicationType> _medicationsList = []; // Store the list of medications

  @override
  void initState() {
    super.initState();
    _fetchMedications();
  }

  // Fetch and store the medications list
  void _fetchMedications() {
    _medications = Services().fetchMedications(widget.userId);
    _medications.then((meds) {
      setState(() {
        _medicationsList = meds;
      });
    });
  }

  // Toggle the medication and send the entire list to the server
  void _toggleMedication(MedicationType medication) {
    setState(() {
      // Find the index of the medication in the list
      int index =
          _medicationsList.indexWhere((med) => med.name == medication.name);
      if (index != -1) {
        // Toggle the isTaken status
        _medicationsList[index].isTaken = !_medicationsList[index].isTaken;

        // Send the entire updated list to the backend
        Services().updateMedications(widget.userId, _medicationsList);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('每日用藥',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                )),
        backgroundColor: Color(0xFF2E609C),
        // iconTheme: IconThemeData(
        //   color: Colors.white, // Set the desired color for the back icon here
        // ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              _fetchMedications(); // Refresh medications
            },
          ),
        ],
      ),
      body: FutureBuilder<List<MedicationType>>(
        future: _medications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!
                  .map((medication) => ListTile(
                        title: Text(
                          medication.name,
                          style: TextStyle(fontSize: 24.sp),
                        ),
                        subtitle: Text(
                          '劑量: ${medication.dosage} 份/顆 次數: 一天${medication.frequency} 次',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        trailing: Checkbox(
                          value: medication.isTaken,
                          onChanged: (bool? value) {
                            _toggleMedication(
                                medication); // Toggle the medication
                          },
                        ),
                      ))
                  .toList(),
            );
          } else {
            return const Center(child: Text('無用藥紀錄'));
          }
        },
      ),
    );
  }
}
