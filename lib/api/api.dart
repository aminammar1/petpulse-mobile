import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:petpulse/config/config.dart';

class Api {
  static var client = http.Client();
  static const String apiurl = URL.baseUrl;

  static Future<Map<String, dynamic>?> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    var body = jsonEncode({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    });

    var response = await client.post(
      Uri.parse('$apiurl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    var body = jsonEncode({'email': email, 'password': password});
    var response = await client.post(
      Uri.parse('$apiurl/login'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var accessToken = data['accessToken'];
      var user = data['user'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);
      await prefs.setString('userId', user['userId']);
      await prefs.setString('firstName', user['firstName']);
      await prefs.setString('lastName', user['lastName']);
      await prefs.setString('email', user['email']);
      return data;
    } else {
      throw Exception('Failed to login with status: ${response.statusCode}');
    }
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      throw Exception('No access token stored');
    }

    var response = await client.post(
      Uri.parse('$apiurl/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      await prefs.remove('accessToken');
    } else {
      throw Exception('Failed to logout with status: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>?> forgotPassword(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('resetEmail', email);

    var body = jsonEncode({
      'email': email,
    });

    var response = await client.post(
      Uri.parse('$apiurl/forgotPassword'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else if (response.statusCode == 400) {
      return {'message': 'Invalid email provided'};
    } else if (response.statusCode == 404) {
      return {'message': 'User not found with the provided email'};
    } else {
      return {'message': 'Unexpected error occurred'};
    }
  }

  static Future<Map<String, dynamic>?> verifyResetCode(String code) async {
    var body = jsonEncode({
      'code': code,
    });

    var response = await client.post(
      Uri.parse('$apiurl/verifyResetCode'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else if (response.statusCode == 400) {
      return {'message': 'Invalid reset code'};
    } else if (response.statusCode == 404) {
      return {'message': 'No user found with the provided code'};
    } else {
      return {'message': 'Unexpected error occurred'};
    }
  }

  static Future<bool> resetPassword(
      String newPassword, String confirmPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('resetEmail');

    if (email == null) {
      return false;
    }

    if (newPassword != confirmPassword) {
      return false;
    }

    var body = jsonEncode({
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    });

    var response = await client.post(
      Uri.parse('$apiurl/resetPassword'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> addPetType(String petType) async {
    try {
      var body = jsonEncode({'petType': petType});

      var response = await client.post(
        Uri.parse('$apiurl/addPetType'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('petType', petType);
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> addPetInfo(
      String gender, String breed, String weight) async {
    var body = jsonEncode({
      'gender': gender,
      'breed': breed,
      'weight': weight,
    });

    var response = await client.post(
      Uri.parse('$apiurl/addPetInfo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<http.Response> addPetDetails({
    required String petName,
    required String birthday,
    required String description,
    required File petImage,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var petsData = prefs.getString('petsData') ?? '[]';
    List<dynamic> pets = json.decode(petsData);
    var imagePath = petImage.path;
    pets.add({
      'imagePath': imagePath,
      'petName': petName,
    });
    prefs.setString('petsData', json.encode(pets));

    var uri = Uri.parse('$apiurl/addPetDetails');
    var request = http.MultipartRequest('POST', uri)
      ..fields['petName'] = petName
      ..fields['birthday'] = birthday
      ..fields['description'] = description
      ..files.add(await http.MultipartFile.fromPath('petImage', petImage.path));

    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  static Future<Map<String, dynamic>?> addDeviceType(String deviceType) async {
    try {
      var body = jsonEncode({'deviceType': deviceType});

      var response = await client.post(
        Uri.parse('$apiurl/deviceSelect'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> foodActivity(
      String food, String time, String calorie) async {
    var body = jsonEncode({
      'food': food,
      'time': time,
      'calorie': calorie,
    });

    var response = await client.post(
      Uri.parse('$apiurl/foodActivity'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> playActivity(
      String game, String time) async {
    var body = jsonEncode({
      'game': game,
      'time': time,
    });

    var response = await client.post(
      Uri.parse('$apiurl/playActivity'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> sleepActivity(
      String qualitySleep, String timeSleep, String timeWakeUp) async {
    var body = jsonEncode({
      'qualitySleep': qualitySleep,
      'timeSleep': timeSleep,
      'timeWakeUp': timeWakeUp,
    });

    var response = await client.post(
      Uri.parse('$apiurl/sleepActivity'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchAverageHeartRate() async {
    var response = await client.get(
      Uri.parse('$apiurl/averageHeartRate'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['averageHeartRate'];
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchAverageTemperature() async {
    var response = await client.get(
      Uri.parse('$apiurl/averageTemperature'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['averageTemperature'];
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchAverageSleep() async {
    var response = await client.get(
      Uri.parse('$apiurl/averageSleep'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['averageSleep'];
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchAverageWalkActivity() async {
    var response = await client.get(
      Uri.parse('$apiurl/averageWalkActivity'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['averageWalkActivity'];
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> updateUser(
    String userId,
    Map<String, String> updatedFields,
  ) async {
    var body = jsonEncode(updatedFields);

    var response = await client.put(
      Uri.parse('$apiurl/updateuser/$userId'), // Correct route
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> deleteUser(String userId) async {
    var response = await client.delete(
      Uri.parse('$apiurl/removeUser/$userId'), // Correct route
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
   static Future<Map<String, dynamic>?> deletePetProfile(String petName) async {
    var body = jsonEncode({'petName': petName});

    var response = await client.delete(
      Uri.parse('$apiurl/deletePetProfile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
