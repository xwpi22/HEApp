import 'dart:async';
import 'dart:convert';
// import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';
import 'package:http/http.dart' as http;
import 'package:heapp/extensions/filter.dart';
import 'package:heapp/services/auth/auth_service.dart';
import 'package:heapp/services/crud/models/users_and_records.dart';
import 'package:heapp/services/crud/sqlite/crud_exceptions.dart';

class Services {
  static const endpoint = "http://13.236.164.131:8090";
  static const userApi = "$endpoint/patient";
  static const recordApi = "$endpoint/record";

  var httpClient = http.Client();
  User? _user;
  List<DatabaseRecord> _records = [];

  late final StreamController<List<DatabaseRecord>> _recordsStreamController;

  static final Services _shared = Services._sharedInstance();
  factory Services() => _shared;
  Services._sharedInstance() {
    _recordsStreamController = StreamController<List<DatabaseRecord>>.broadcast(
      onListen: () {
        _recordsStreamController.sink.add(_records);
      },
    );
  }

  Stream<List<DatabaseRecord>> get allRecords =>
      _recordsStreamController.stream.filter((record) {
        final currentUser = _user;
        if (currentUser != null) {
          return record.userId == currentUser.id;
        } else {
          throw UserShouldBeSetBeforeReadingAllRecord();
        }
      });

  Future<void> _cacheRecords() async {
    final allRecords = await getAllRecords();
    _records = allRecords.toList();
    _recordsStreamController.add(_records);
  }

  String getAsusSn() {
    if (_user == null || _user!.asusvivowatchsn == null) {
      return '';
    }
    return _user!.asusvivowatchsn!;
  }

  Future<List<DatabaseRecord>> getAllRecords() async {
    var currentUser = _user;
    if (currentUser == null) {
      throw UserNotLoggedInException();
    }
    String url = '$recordApi/${currentUser.id}';
    print('Fetching records from: $url');
    final response = await httpClient.get(
      Uri.parse('$recordApi/${currentUser.id}'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return List<DatabaseRecord>.from(
          jsonDecode(response.body).map((x) => DatabaseRecord.fromJson(x)));
    } else {
      throw Exception(
          'Failed to get records. Status code: ${response.statusCode}');
    }
  }

  Future<DatabaseRecord> getLatestDatabaseRecord() async {
    if (_records.isNotEmpty) {
      return _records.last;
    } else {
      throw Exception('No records available.');
    }
  }

  Future<DatabaseRecord> createDatabaseRecord({
    required String userId,
    required int gameId,
    required String gameTime,
    required int score,
  }) async {
    final response = await httpClient.post(
      Uri.parse(recordApi),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'userId': userId,
        'gameId': gameId,
        'gameTime': gameTime,
        'score': score,
      }),
    );
    if (response.statusCode == 201) {
      var res = jsonDecode(response.body);
      // Add this line
      final record = DatabaseRecord.fromJson(res);
      _records.add(record);
      _recordsStreamController.add(_records);
      return record;
    } else {
      throw Exception('Failed to create Database Record.');
    }
  }

  ////////////////////////////////////////////
  ///
  ///               User
  ///
  ///////////////////////////////////////////

  // Fetch all messages for a specific user
  Future<List<Message>> fetchMessages(String userId) async {
    final response = await httpClient.get(
      Uri.parse('$userApi/$userId/messages'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    if (response.statusCode == 200) {
      var messagesJson = json.decode(response.body) as List<dynamic>;
      return messagesJson.isNotEmpty
          ? messagesJson
              .map((m) => Message.fromJson(m))
              .toList()
              .reversed
              .toList()
          : [];
    } else {
      throw Exception('Failed to load messages: ${response.body}');
    }
  }

  // Create a new message for a specific user
  Future<void> createMessage(String userId, String messageText) async {
    print(messageText);
    final response = await httpClient.post(
      Uri.parse('$userApi/$userId/message'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'message': messageText}),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to create message: ${response.body}');
    }
  }

  // Fetch medications for a specific user
  Future<List<MedicationType>> fetchMedications(String userId) async {
    final response = await httpClient.get(
      Uri.parse('$userApi/$userId/medication'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    if (response.statusCode == 200) {
      List<dynamic> meds = json.decode(response.body);
      return meds.isNotEmpty
          ? meds.map((m) => MedicationType.fromJson(m)).toList()
          : [];
    } else {
      throw Exception('Failed to load medications: ${response.body}');
    }
  }

  // Update the list of medications for a specific user
  Future<void> updateMedications(
      String userId, List<MedicationType> medications) async {
    final response = await httpClient.patch(
      Uri.parse('$userApi/$userId/medication'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(
          {'medication': medications.map((m) => m.toJson()).toList()}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update medications: ${response.body}');
    }
  }

  Future<void> deleteDatabaseUser(String userId, String email) async {
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    // 1. 刪除主使用者資料
    final userDeleteResponse = await http.delete(
      Uri.parse('$userApi/$userId'),
      headers: headers,
    );

    if (userDeleteResponse.statusCode != 204) {
      print('刪主帳號');
      print(userDeleteResponse.statusCode);
      print(userDeleteResponse.reasonPhrase);
      throw CouldNotDeleteUser(); // 主帳號沒刪成功就中止
    } else {
      print(userId);
    }

    // final recordDeleteResponse = await http.delete(
    //   Uri.parse('$recordApi/$userId'),
    //   headers: headers,
    // );

    // if (recordDeleteResponse.statusCode != 200) {
    //   print('刪record $userDeleteResponse');
    //   throw CouldNotDeleteUser(); // 主帳號沒刪成功就中止
    // }

    // 不需強制檢查每個子資料都刪除成功，容忍 204/404 是常見做法

    // If the server did return a 200 OK response,
    // then parse the JSON. After deleting,
    // you'll get an empty JSON `{}` response.
    // Don't return `null`, otherwise `snapshot.hasData`
    // will always return false on `FutureBuilder`.
    return;
  }

  Future<String> previewUserDeletionData(String? userId, String? email) async {
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final buffer = StringBuffer();

    // 1. 撈使用者主資料
    final Uri uri;
    buffer.writeln(userId);
    // if (email != null) {
    //   uri = Uri.parse('$userApi?email=${Uri.encodeComponent(email)}');
    //   // uri = Uri.parse('$userApi/$userId');
    // } else {
    //   throw Exception('No valid identifier provided');
    // }

    uri = Uri.parse('$userApi/$userId');

    final userResponse = await http.get(
      uri,
      headers: headers,
    );

    final id;
    if (userResponse.statusCode == 200) {
      final user = jsonDecode(userResponse.body);

      id = user['_id'];

      buffer.writeln('🧑 使用者資料:');
      buffer.writeln('_id: ${user['_id']}');
      buffer.writeln('姓名: ${user['name']}');
      buffer.writeln('Email: ${user['email']}');
      buffer.writeln('');
    } else {
      buffer.writeln('❌ 無法取得使用者資料 ${userResponse.statusCode.toString()}');
    }

    // // 2. 撈留言
    // final messageResponse = await http.get(
    //   Uri.parse('$userApi/$userId/messages'),
    //   headers: headers,
    // );

    // if (messageResponse.statusCode == 200) {
    //   final messages = jsonDecode(messageResponse.body) as List<dynamic>;
    //   buffer.writeln('💬 留言 (${messages.length} 筆):');
    //   for (final msg in messages.take(3)) {
    //     buffer.writeln('- ${msg['message']}');
    //   }
    //   if (messages.length > 3) {
    //     buffer.writeln('...（還有 ${messages.length - 3} 筆）');
    //   }
    //   buffer.writeln('');
    // } else {
    //   buffer.writeln('❌ 無法取得留言');
    // }

    // // 3. 撈藥物資料
    // final medResponse = await http.get(
    //   Uri.parse('$userApi/$userId/medication'),
    //   headers: headers,
    // );

    // if (medResponse.statusCode == 200) {
    //   final meds = jsonDecode(medResponse.body) as List<dynamic>;
    //   buffer.writeln('💊 藥物資料 (${meds.length} 筆):');
    //   for (final med in meds.take(3)) {
    //     buffer.writeln('- ${med['name']}');
    //   }
    //   if (meds.length > 3) buffer.writeln('...（還有 ${meds.length - 3} 筆）');
    //   buffer.writeln('');
    // } else {
    //   buffer.writeln('❌ 無法取得藥物資料');
    // }

    // // 4. 撈健康紀錄
    // final recordResponse = await http.get(
    //   Uri.parse('$recordApi/$userId'),
    //   headers: headers,
    // );

    // if (recordResponse.statusCode == 200) {
    //   buffer.writeln('📈 健康／遊戲紀錄 (${records.length} 筆):');
    //   if (records.isNotEmpty) {
    //     for (var rec in records.take(3)) {
    //       buffer.writeln(
    //           '- 遊戲ID: ${rec['gameId']}, 分數: ${rec['score']}, 時間: ${rec['gameTime']}');
    //     }
    //     if (records.length > 3) {
    //       buffer.writeln('...（還有 ${records.length - 3} 筆）');
    //     }
    //   }
    //   buffer.writeln('');
    // } else {
    //   buffer.writeln('❌ 無法取得紀錄資料 (GET /records/$userId)');
    // }

    return buffer.toString();
  }

  Future<void> logOut() async {
    await AuthService.firebase().logOut();
    _user!.messages ?? _user!.messages.clear();
    _user!.medications ?? _user!.medications.clear();
    _user = null;
    // _records.clear(); // Clear any cached records
    // _recordsStreamController.add([]); // Update listeners with an empty list
  }

  Future<User> getDatabaseUser(
      {String? id, String? email, String? phone}) async {
    if (_user != null) return _user!;
    final Uri uri;
    if (id != null) {
      uri = Uri.parse('$userApi/$id');
    } else if (email != null) {
      uri = Uri.parse('$userApi?email=${Uri.encodeComponent(email)}');
    } else if (phone != null) {
      uri = Uri.parse('$userApi?phone=${Uri.encodeComponent(phone)}');
    } else {
      throw Exception('No valid identifier provided');
    }
    final response = await http.get(
      uri, // Updated to fetch by ID
      headers: {
        'Content-Type':
            'application/json; charset=UTF-8', // Ensure headers are properly set
      },
    );

    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      _user = User.fromJson(res);
      print("get successs");
      // await _cacheRecords();
      return _user!;
    } else if (response.statusCode == 404) {
      throw DBCouldNotFindUser();
    } else {
      throw Exception(
          'Failed to fetch user. Status code: ${response.statusCode}');
    }
  }

  Future<User> createDatabaseUser({
    required String name,
    required String email,
    required String phone,
    required String birthday,
    required String gender,
    // required String asusvivowatchsn, <- I think SN should be set by Doctor on HEWeb
  }) async {
    final response = await http.post(
      Uri.parse(userApi),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'name': name,
          'email': email,
          'phone': phone,
          'birthday': birthday,
          'gender': gender,
        },
      ),
    );

    switch (response.statusCode) {
      case 201:
        // Successfully created
        var res = jsonDecode(response.body);
        return User.fromJson(res);
      case 409:
        // Conflict, email already exists
        throw DBUserAlreadyExists();
      case 400:
        // Bad Request, maybe invalid input format
        throw DBCouldNotCreateUser();
      default:
        // Other errors
        throw Exception(
            'Failed to create user. Status code: ${response.statusCode}');
    }
  }
}
