import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heapp/games/soldiers_in_formation/soldiers_in_formation_game_ending_record_view.dart';
import 'package:heapp/globals/gobals.dart';
import 'package:heapp/services/crud/models/users_and_records.dart';
import 'package:heapp/services/crud/services/crud_service.dart';

class SIFGameOverView extends StatefulWidget {
  const SIFGameOverView({
    super.key,
  });

  @override
  State<SIFGameOverView> createState() => _SIFGameOverViewState();
}

class _SIFGameOverViewState extends State<SIFGameOverView> {
  late final Services _services;

  @override
  void initState() {
    _services = Services();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('遊戲紀錄',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                )),
        backgroundColor: Color(0xFF2E609C),
        toolbarHeight: 60.h,
      ),
      extendBodyBehindAppBar: false,
      body: StreamBuilder<List<DatabaseRecord>>(
        stream: _services.allRecords,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final latestRecord = snapshot.data!.last;
            return SIFEndingRecordView(record: latestRecord);
          } else {
            // Handle the case where there's no data
            return const Center(child: Text('No records found.'));
          }
        },
      ),
    );
  }
}
