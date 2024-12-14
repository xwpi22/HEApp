import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:heapp/services/asus/model/asus_vivowatch_data.dart';

class ASUSVivowatchService {
  static const endpoint = "XXXX";
  static const getData = "$endpoint/getASUSLatestData.php";
  var httpClient = http.Client();

  Future<ASUSVivowatchData> fetchData(String deviceId) async {
    if (deviceId.isEmpty) {
      throw Exception("No ASUS VivoWatch device ID provided");
    }
    var response = await http.get(
      Uri.parse('$getData?deviceid=$deviceId'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      return ASUSVivowatchData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
