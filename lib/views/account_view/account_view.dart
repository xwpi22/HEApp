// import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:flutter/material.dart';
import 'package:heapp/services/auth/auth_exceptions.dart';
import 'package:heapp/utilities/dialogs/error_dialog.dart';
import 'package:heapp/views/records_view/records_list_view.dart';
import 'package:heapp/views/records_view/records_view.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:heapp/constants/routes.dart';
import 'package:heapp/globals/gobals.dart';
import 'package:heapp/services/auth/auth_service.dart';
import 'package:heapp/services/crud/models/users_and_records.dart';
import 'package:heapp/services/crud/services/crud_service.dart';
import 'package:heapp/utilities/dialogs/logout_dialog.dart';
import 'package:heapp/views/account_view/asus_view/asus_vivowatch_data_view.dart';
import 'package:heapp/views/account_view/medication_record_view/medication_record_list_view.dart';
import 'package:heapp/views/account_view/messages_board_view/message_board_view.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  late Future<User> _userFuture;
  late String _userEmail;
  late Services _services;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    _services = Services();
    _userEmail = AuthService.firebase().currentUser!.email;
    _userFuture = Future(() => _services.getDatabaseUser(email: _userEmail));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 30.h,
      maxWidth: 30.h,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      // Load the image with the `image` package
      final imageBytes = File(pickedFile.path).readAsBytesSync();
      img.Image? image = img.decodeImage(imageBytes);
      if (image != null) {
        // Re-encode to reduce color space issues
        final convertedBytes = img.encodeJpg(image, quality: 85);

        // Save the converted image to a new file
        final convertedFile = File('${pickedFile.path}_sRGB.jpg');
        await convertedFile.writeAsBytes(convertedBytes);

        setState(() {
          _imageFile = convertedFile;
          // _imageFile = File(pickedFile.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final futureBuilderKey = ValueKey(_userEmail);
    return Scaffold(
        appBar: AppBar(
          title: Text('會員專區',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                  )),
          // iconTheme: IconThemeData(
          //   color: Colors.white, // Set the desired color for the back icon here
          // ),
          actions: <Widget>[
            IconButton.outlined(
              onPressed: () async {
                final shouldLogOut = await showLogOutDialog(context);
                // Check the user's decision
                if (shouldLogOut) {
                  await _services.logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (_) => false,
                  );
                }
              },
              icon: Icon(
                Icons.logout,
                size: 20.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: FutureBuilder<User>(
          key: futureBuilderKey,
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Handle error state
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final user = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: const CircleAvatar(
                              radius: 70,
                              backgroundImage: AssetImage(
                                  'assets/images/nonHeadShotDefault.jpg'),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          const SizedBox(
                              width: 20), // Space between image and text fields
                          Expanded(
                            child: Column(
                              children: [
                                TextFormField(
                                  enableInteractiveSelection: false,
                                  initialValue: user.name,
                                  decoration: const InputDecoration(
                                    labelText: '姓名',
                                    // labelStyle: TextStyle(
                                    //   fontSize: 25, // Set your desired size
                                    // ),
                                  ),
                                  readOnly: true,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color:
                                        globFontColor, // Adjust the font size as needed
                                  ),
                                ),
                                TextFormField(
                                  enableInteractiveSelection: false,
                                  initialValue: user.gender,
                                  decoration: const InputDecoration(
                                    labelText: '性別',
                                    // labelStyle: TextStyle(
                                    //   fontSize: 25, // Set your desired size
                                    // ),
                                  ),
                                  readOnly: true,
                                  style: TextStyle(
                                    fontSize: 20.sp,

                                    color:
                                        globFontColor, // Adjust the font size as needed
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h), // Space between rows
                      TextFormField(
                        enableInteractiveSelection: false,
                        initialValue: user.email,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          // labelStyle: TextStyle(
                          //   fontSize: 25, // Set your desired size
                          // ),
                        ),
                        readOnly: true,
                        style: TextStyle(
                          fontSize: 20.sp,

                          color:
                              globFontColor, // Adjust the font size as needed
                        ),
                      ),

                      TextFormField(
                        initialValue: user.birthday,
                        enableInteractiveSelection: false,
                        decoration: const InputDecoration(
                          labelText: '生日',
                          // labelStyle: TextStyle(
                          //   fontSize: 25, // Set your desired size
                          // ),
                        ),
                        readOnly: true,
                        style: TextStyle(
                          fontSize: 20.sp,

                          color:
                              globFontColor, // Adjust the font size as needed
                        ),
                      ),
                      TextFormField(
                        initialValue: user.phone,
                        enableInteractiveSelection: false,
                        decoration: const InputDecoration(
                          labelText: '手機號碼',
                          // labelStyle: TextStyle(
                          //   fontSize: 25, // Set your desired size
                          // ),
                        ),
                        readOnly: true,
                        style: TextStyle(
                          fontSize: 20.sp,

                          color:
                              globFontColor, // Adjust the font size as needed
                        ),
                      ),
                      TextFormField(
                        initialValue: user.asusvivowatchsn ?? "未設定",
                        enableInteractiveSelection: false,
                        decoration: const InputDecoration(
                          labelText: '手錶序號',
                        ),
                        readOnly: true,
                        style: TextStyle(
                          fontSize: 20.sp,

                          color:
                              globFontColor, // Adjust the font size as needed
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              maximumSize: Size(120.w, 120.h),
                              minimumSize: Size(100.w, 80.h),
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                side: BorderSide(
                                  // color: Colors.black,
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RecordsView()));
                            },
                            child: Text(
                              '遊戲\n紀錄',
                              style: TextStyle(
                                fontSize: 27.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E609C),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0.w),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              maximumSize: Size(120.w, 120.h),
                              minimumSize: Size(100.w, 80.h),
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                side: BorderSide(
                                  // color: Colors.black,
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      MessageBoardView(userId: user.id)));
                            },
                            child: Text(
                              '留言\n紀錄',
                              style: TextStyle(
                                fontSize: 27.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E609C),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0.w),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              maximumSize: Size(120.w, 120.h),
                              minimumSize: Size(100.w, 80.h),
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                side: BorderSide(
                                  // color: Colors.black,
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const ASUSVivoWatchDataView()));
                            },
                            child: Text(
                              '手錶\n資料',
                              style: TextStyle(
                                fontSize: 27.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E609C),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () async {
                              final TextEditingController passwordController =
                                  TextEditingController();
                              bool confirmPressed = false;

                              final shouldDelete = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        title: const Text('確認刪除帳號'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text('刪除帳號將無法復原，請輸入密碼以確認操作'),
                                            const SizedBox(height: 16),
                                            TextField(
                                              controller: passwordController,
                                              obscureText: true,
                                              onChanged: (_) => setState(
                                                  () {}), // 每次輸入觸發 rebuild
                                              decoration: const InputDecoration(
                                                labelText: '密碼',
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text('取消'),
                                          ),
                                          TextButton(
                                            onPressed: passwordController
                                                    .text.isNotEmpty
                                                ? () {
                                                    confirmPressed = true;
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  }
                                                : null,
                                            child: const Text(
                                              '確認刪除',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );

                              if (shouldDelete != true) return;

                              final password = passwordController.text.trim();
                              if (password.isEmpty) {
                                await showErrorDialog(
                                    context, '密碼錯誤', '請輸入密碼以確認刪除');
                                return;
                              }

                              final userId = user.id;
                              final email = user.email;

                              try {
                                // ✅ 重新驗證身份
                                await AuthService.firebase().reauthenticate(
                                  email: email,
                                  password: password,
                                );

                                // ✅ 刪除 Firebase 帳號
                                await AuthService.firebase().deleteUser();

                                // ✅ 刪除資料庫中的使用者資料
                                await Services()
                                    .deleteDatabaseUser(userId, email);

                                // ✅ 跳轉回登入頁
                                if (context.mounted) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    loginRoute,
                                    (route) => false,
                                  );
                                }
                              } on WrongPasswordOrUserNotFoundAuthException {
                                await showErrorDialog(
                                    context, '密碼錯誤', '請確認密碼正確後重試');
                              } on RequiresRecentLoginAuthException {
                                await showErrorDialog(
                                    context, '登入過期', '請重新登入後再刪除帳號');
                              } catch (e) {
                                await showErrorDialog(
                                    context, '刪除失敗', e.toString());
                              }
                            },
                            child: const Text(
                              '刪除帳號',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            } else {
              // Handle the case where snapshot.data is null
              return const Center(child: Text('No user data available.'));
            }
          },
        ));
  }
}
