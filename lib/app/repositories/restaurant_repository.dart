import 'dart:async';
import 'dart:convert';
import 'package:fov_fall2024_headchef_tablet_app/app/entities/restaurant_entity.dart';
import 'package:http/http.dart' as http;
import 'package:fov_fall2024_headchef_tablet_app/app/repositories/auth_repository.dart';

class RestaurantRepository {
  final String _baseUrl = 'http://vktrng.ddns.net:8080/api/Restaurant';
  final authRepository = AuthRepository();

  Future<Restaurant> fetchRestaurantName() async {
    String? restaurantId = await authRepository.getRestaurantId();
    final url = Uri.parse('$_baseUrl?RestaurantId=$restaurantId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await authRepository.getToken()}'
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var restaurant = jsonResponse['results'][0];
      return Restaurant.fromJson(restaurant);
    } else {
      throw Exception('Failed to load restaurant data');
    }
  }
}
