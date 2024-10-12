import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heapp/globals/gobals.dart';
import 'package:heapp/services/crud/models/users_and_records.dart';

class RecordsListView extends StatelessWidget {
  // final List<DatabaseRecord> records;
  final Map<int, List<DatabaseRecord>> groupedRecords;

  const RecordsListView({
    Key? key,
    required this.groupedRecords,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var groupedRecordsList = groupedRecords.entries.toList();
    return ListView.builder(
      itemCount: groupedRecordsList.length,
      itemBuilder: (context, index) {
        // Get game ID and records for the current section
        final gameId = groupedRecordsList[index].key;
        final records = groupedRecordsList[index].value;
        final gameName = gameMap[gameId]; // Assuming gameMap is accessible here

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              // child: Text(
              //   gameName, // Fallback if game name is not found
              //   style: TextStyle(
              //     fontSize: 22.sp,
              //     fontWeight: FontWeight.bold,
              //     color: globFontColor,
              //   ),
              // ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('日期',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: globFontColor,
                        )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('遊玩時長',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: globFontColor,
                        )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('遊戲分數',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: globFontColor,
                        )),
                  ),
                ],
              ),
            ),
            ListView.separated(
              physics:
                  const NeverScrollableScrollPhysics(), // To prevent inner list scroll
              shrinkWrap: true, // Needed for ListView inside ListView
              itemCount: records.length,
              itemBuilder: (context, recordIndex) {
                final record = records[recordIndex];
                // final gameDateTimeDate = record.gameDateTime.split(" ").first;
                // final gameDateTimeTime = record.gameDateTime.split(" ").last;
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Expanded(
                      //   flex: 2, // Adjust flex as needed to allocate space
                      //   child: Text("$gameDateTimeDate\n$gameDateTimeTime",
                      //       style: const TextStyle(fontSize: 18)),
                      // ),
                      Expanded(
                        flex: 3, // Adjust flex as needed to allocate space
                        child: Text(record.gameDateTime,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: globFontColor,
                            )),
                      ),
                      Expanded(
                        flex: 2, // Adjust flex as needed
                        child: Text(record.gameTime,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: globFontColor,
                            )),
                      ),
                      Expanded(
                        flex: 2, // Adjust flex as needed
                        child: Text(record.score.toString(),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: globFontColor,
                            )),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ],
        );
      },
    );
  }
}
