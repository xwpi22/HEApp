import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:heapp/extensions/filter.dart';
import 'package:heapp/services/auth/auth_service.dart';
import 'package:heapp/services/crud/models/users_and_records.dart';
import 'package:heapp/services/crud/sqlite/crud_exceptions.dart';

class Services {
  static const endpoint = "XXXX";
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

  Future<User> deleteDatabaseUser(int userId, String userName) async {
    final response = await http.delete(
      Uri.parse(userApi),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8', // Added header
      },
      body: jsonEncode(
        <String, int>{
          'id': userId,
        },
      ),
    );
    // If the server did return a 200 OK response,
    // then parse the JSON. After deleting,
    // you'll get an empty JSON `{}` response.
    // Don't return `null`, otherwise `snapshot.hasData`
    // will always return false on `FutureBuilder`.
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw CouldNotDeleteUser();
    }
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
