import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heapp/globals/gobals.dart';
import 'package:heapp/services/crud/models/users_and_records.dart';
import 'package:heapp/services/crud/services/crud_service.dart';

class MessageBoardView extends StatefulWidget {
  final String userId;
  const MessageBoardView({super.key, required this.userId});

  @override
  State<MessageBoardView> createState() => _MessageBoardViewState();
}

class _MessageBoardViewState extends State<MessageBoardView> {
  late Future<List<Message>> _messages;

  @override
  void initState() {
    super.initState();
    _messages = Services().fetchMessages(widget.userId);
  }

  void _refreshMessages() {
    setState(() {
      _messages = Services().fetchMessages(widget.userId);
    });
  }

  Future<void> _showAddMessageDialog() async {
    TextEditingController messageController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            '新增一筆留言',
          ),
          content: TextField(
            controller: messageController,
            decoration: const InputDecoration(hintText: "請輸入訊息 (限50字)"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('送出'),
              onPressed: () async {
                if (messageController.text.isNotEmpty) {
                  await Services()
                      .createMessage(widget.userId, messageController.text);
                  Navigator.of(context).pop();
                  _refreshMessages();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2E609C),
        title: Text(
          "留言板",
        ),
        toolbarHeight: 60.h,
        iconTheme: IconThemeData(
          color: Colors.white, // Set the desired color for the back icon here
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddMessageDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<Message>>(
        future: _messages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('目前沒有留言喔！'));
          } else if (snapshot.hasData) {
            return snapshot.data!.isEmpty
                ? const Center(child: Text("目前沒有留言喔！"))
                : ListView(
                    // reverse: true,
                    children: snapshot.data!
                        .map((message) => ListTile(
                              title: Text(
                                message.message,
                                style: TextStyle(fontSize: 20.sp),
                              ),
                              subtitle: Text(
                                message.date,
                                style: TextStyle(fontSize: 10.sp),
                              ),
                            ))
                        .toList(),
                  );
          } else {
            return const Center(child: Text("目前沒有留言喔！"));
          }
        },
      ),
    );
  }
}
