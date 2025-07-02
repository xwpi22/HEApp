import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heapp/globals/gobals.dart';
import 'package:heapp/services/crud/models/users_and_records.dart';
import 'package:heapp/services/crud/services/crud_service.dart';
import 'package:heapp/views/records_view/records_list_view.dart';

class RecordsView extends StatefulWidget {
  const RecordsView({super.key});

  @override
  State<RecordsView> createState() => _RecordsViewState();
}

class _RecordsViewState extends State<RecordsView> {
  late final Services _services;
  int selectedGameId = 0; // default from 0

  @override
  void initState() {
    _services = Services();
    super.initState();
  }

  Map<int, List<DatabaseRecord>> groupRecordsByGameId(
      List<DatabaseRecord> records) {
    return records.fold<Map<int, List<DatabaseRecord>>>({}, (map, record) {
      if (!map.containsKey(record.gameId)) {
        map[record.gameId] = [];
      }
      map[record.gameId]!.add(record);
      return map;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('遊戲紀錄',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                )),
        backgroundColor: Color(0xFF2E609C),
        toolbarHeight: 60.h,
      ),
      extendBodyBehindAppBar: false,
      body: Column(
        children: [
          DropdownButtonOfGameList(
            selectedGameId: selectedGameId, // Pass the current selectedGameId
            onChanged: (newGameId) {
              setState(() {
                selectedGameId =
                    newGameId; // Update selectedGameId when dropdown changes
              });
            },
          ),
          Expanded(
              child: FutureBuilder<Iterable<DatabaseRecord>>(
            future: _services.getAllRecords(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('沒有遊戲紀錄'));

                // return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final allRecords = snapshot.data as List<DatabaseRecord>;
                final filteredRecords = allRecords
                    .reversed // Reverse the list of records so that the new record is at the front
                    .where((record) => record.gameId == selectedGameId)
                    .toList();
                final groupedRecords = groupRecordsByGameId(filteredRecords);
                return RecordsListView(groupedRecords: groupedRecords);
              } else {
                return const Center(child: Text('沒有遊戲紀錄'));
              }
            },
          ))
        ],
      ),
    );
  }
}

class DropdownButtonOfGameList extends StatefulWidget {
  final int selectedGameId; // Accept the selectedGameId as an index (int)
  final ValueChanged<int>
      onChanged; // Callback to notify when selected item changes

  const DropdownButtonOfGameList({
    Key? key,
    required this.selectedGameId,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<DropdownButtonOfGameList> createState() =>
      _DropdownButtonOfGameListState();
}

class _DropdownButtonOfGameListState extends State<DropdownButtonOfGameList> {
  late int dropdownIndex; // Use index (int) to manage the selection

  @override
  void initState() {
    super.initState();
    // Initialize dropdownIndex to selectedGameId (index) or 0 if null
    dropdownIndex = widget.selectedGameId;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.end, // Align the dropdown to the right
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: dropdownIndex, // dropdownIndex as int
            icon: const Icon(Icons.expand_more),
            elevation: 16,
            style: const TextStyle(color: Colors.black87),
            onChanged: (int? value) {
              if (value != null) {
                setState(() {
                  dropdownIndex = value; // Update dropdownIndex (index)
                });
                widget.onChanged(value); // Call the callback when index changes
              }
            },
            items: List.generate(gameMap.length, (index) {
              return DropdownMenuItem<int>(
                value: index, // The index of the game in the list
                child: Text(
                  gameMap.entries
                      .elementAt(index)
                      .value, // Display the game name
                  style: TextStyle(
                    fontSize: 32.sp,
                    color: dropdownIndex == index
                        ? Colors.black87
                        : Colors.grey, // Black for selected, grey for others
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
