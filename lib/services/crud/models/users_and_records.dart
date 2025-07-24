import 'dart:convert';

List<User> databaseUsersFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String databaseUsersToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  String id;
  String name;
  String email;
  String phone;
  String birthday;
  String gender;
  String? asusvivowatchsn;
  String? photosticker;
  List<Message> messages;
  List<MedicationType> medications;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.birthday,
    required this.gender,
    this.asusvivowatchsn,
    this.photosticker,
    List<Message>? messages,
    List<MedicationType>? medications,
  })  : messages = messages ?? [], // Initialize with empty list if null
        medications = medications ?? []; // Initialize with empty list if null

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"] ?? json["ID"], // Handling potential case differences
        name: json["name"] ?? 'Default name',
        email: json["email"] ?? 'Default email',
        phone: json["phone"] ?? 'Default phone',
        birthday: json["birthday"] ?? 'Default birthday',
        gender: json["gender"] ?? 'Default gender',
        asusvivowatchsn: json["asusvivowatchsn"],
        photosticker: json["photosticker"],
        messages: (json["messages"] as List<dynamic>?)
                ?.map((x) => Message.fromJson(x))
                .toList() ??
            [],
        medications: (json["medications"] as List<dynamic>?)
                ?.map((e) => MedicationType.fromJson(e))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "birthday": birthday,
        "gender": gender,
        "asusvivowatchsn": asusvivowatchsn,
        "photosticker": photosticker,
        "messages": messages.map((x) => x.toJson()).toList(),
        "medications": medications.map((x) => x.toJson()).toList(),
      };
}

class Message {
  String message;
  String date;

  Message({required this.message, required this.date});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'date': date,
    };
  }
}

class MedicationType {
  String name;
  double dosage; // Number of pills
  int frequency; // Times per day
  bool isTaken;

  MedicationType(
      {required this.name,
      required this.dosage,
      required this.frequency,
      required this.isTaken});

  factory MedicationType.fromJson(Map<String, dynamic> json) {
    return MedicationType(
      name: json['name'],
      dosage: (json['dosage'] is int)
          ? (json['dosage'] as int).toDouble()
          : json['dosage'],
      frequency: json['frequency'],
      isTaken: json['istaken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'istaken': isTaken,
    };
  }
}

List<DatabaseRecord> databaseRecordsFromJson(List<dynamic> recordsJson) {
  return recordsJson.map((x) => DatabaseRecord.fromJson(x)).toList();
}

String databaseRecordsToJson(List<DatabaseRecord> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DatabaseRecord {
  String recordId;
  String userId;
  int gameId; // number 0: number connection, number 1: color vs word, ...
  String gameDateTime;
  String gameTime;
  int score;

  DatabaseRecord({
    required this.recordId,
    required this.userId,
    required this.gameId,
    required this.gameDateTime,
    required this.gameTime,
    required this.score,
  });

  factory DatabaseRecord.fromJson(Map<String, dynamic> json) {
    return DatabaseRecord(
      recordId: json['id'],
      userId: json['userId'],
      gameId: json['gameId'],
      gameDateTime: json['gameDateTime'],
      gameTime: json['gameTime'],
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': recordId,
      'user_id': userId,
      'game_id': gameId,
      'game_date_time': gameDateTime,
      'game_time': gameTime,
      'score': score,
    };
  }
}
