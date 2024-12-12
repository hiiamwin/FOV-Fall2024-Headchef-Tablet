import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fov_fall2024_headchef_tablet_app/app/entities/OrderEntity.dart';
import 'package:fov_fall2024_headchef_tablet_app/app/repositories/auth_repository.dart';

class OrderRepository {
  final String _baseUrl = 'http://vktrng.ddns.net:8080/api/Order';
  final AuthRepository authRepository = AuthRepository();

  final _ordersController = StreamController<OrderEntityResponse>.broadcast();

  Stream<OrderEntityResponse> get orderStream => _ordersController.stream;

  Future<OrderEntityResponse> fetchOrders() async {
    String? restaurantId = await authRepository.getRestaurantId();
    final url = Uri.parse(
      '$_baseUrl/$restaurantId/suggest-dishes?PageSize=10000&SortType=2&ColName=createdDate',
    );
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await authRepository.getToken()}'
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final orders = OrderEntityResponse.fromJson(jsonResponse);
        _ordersController.add(orders);
        return orders;
      } else {
        throw Exception(
            'Failed to load suggested dishes: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching suggested dishes: $e");
      _ordersController.addError('Error fetching suggested dishes: $e');
      rethrow;
    }
  }

  // Confirm order cooked and transfer to waiter
  Future<String> confirmOrder(String orderId, String orderDetailsId) async {
    final url =
        Uri.parse('$_baseUrl/$orderId/cooked?OrderDetailsId=$orderDetailsId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await authRepository.getToken()}'
    };

    try {
      final response = await http.patch(url, headers: headers);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.statusCode.toString();
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  // Close the StreamController when no longer needed
  void dispose() {
    _ordersController.close();
  }
}
