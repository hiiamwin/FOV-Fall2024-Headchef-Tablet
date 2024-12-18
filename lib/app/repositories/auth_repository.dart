import 'dart:convert';
import 'package:fov_fall2024_headchef_tablet_app/app/services/signalr_service.dart';
import 'package:fov_fall2024_headchef_tablet_app/app/services/storage_service.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String _baseUrl = 'http://vktrng.ddns.net:8080/api/v1/Auth';
  final StorageService _storageService = StorageService();
  final String _tokenKey = 'auth_token';
  final String _restaurantId = 'restaurantId';
  final String _employeeId = 'employeeId';
  final String _role = 'role';
  final signalRService = SignalRService();

  ///API related section
  // Login
  Future<Map<String, dynamic>> login(String code, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    print(url);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'code': code, 'password': password});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['reasonStatusCode'] == 'Success') {
          await storeUserInfo(responseData['metadata']);
          await signalRService.connect(
              responseData['metadata']['id'], responseData['metadata']['role']);
          return {'success': true, 'data': responseData};
        }
        return {'success': false, 'error': 'Invalid token received'};
      } else {
        return {
          'success': false,
          'error': 'Failed to login',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

  // Change password
  Future<Map<String, dynamic>> changePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    final url = Uri.parse('$_baseUrl/change-password');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}'
    };
    final body = jsonEncode({
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': 'Failed to change password',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

  // View (current) profile detail
  Future<Map<String, dynamic>> profileDetail() async {
    final url = Uri.parse('$_baseUrl/me');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}'
    };
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': 'Failed to fetch profile details',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

  // Edit profile
  Future<Map<String, dynamic>> editProfile(
      String address, String lastName, String firstName) async {
    final url = Uri.parse('$_baseUrl/edit-profile');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}'
    };
    final body = jsonEncode({
      'address': address,
      'lastName': lastName,
      'firstName': firstName,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': 'Failed to edit profile',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

  /// Flutter secure storage relate section

  //Store user info
  Future<void> storeUserInfo(Map<String, dynamic> metadata) async {
    await _storageService.write(_tokenKey, metadata['accessToken']);
    await _storageService.write(_restaurantId, metadata['restaurantId']);
    await _storageService.write(_employeeId, metadata['id']);
    await _storageService.write(_role, metadata['role']);
  }

  // Get token
  Future<String?> getToken() async {
    return await _storageService.read(_tokenKey);
  }

  Future<String?> getEmployeeId() async {
    return await _storageService.read(_employeeId);
  }

  Future<String?> getRole() async {
    return await _storageService.read(_role);
  }

  Future<String?> getRestaurantId() async {
    return await _storageService.read(_restaurantId);
  }

  // Delete token
  Future<void> deleteToken() async {
    await _storageService.delete(_tokenKey);
  }

  // Delete all token (unused, since no case required ?)
  Future<void> deleteAllToken() async {
    await _storageService.deleteAll();
  }
}
