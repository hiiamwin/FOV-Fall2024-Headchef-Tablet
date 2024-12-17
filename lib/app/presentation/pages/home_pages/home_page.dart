import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fov_fall2024_headchef_tablet_app/app/entities/OrderEntity.dart';
import 'package:fov_fall2024_headchef_tablet_app/app/entities/restaurant_entity.dart';
import 'package:fov_fall2024_headchef_tablet_app/app/services/signalr_service.dart';
import 'package:fov_fall2024_headchef_tablet_app/app/repositories/order_repository.dart';
import 'package:fov_fall2024_headchef_tablet_app/app/repositories/restaurant_repository.dart';
import './home_page.component.dart';

class HomePage extends StatefulWidget {
  final SignalRService signalRService;

  HomePage({required this.signalRService});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final orderRepository = OrderRepository();
  final restaurantRepository = RestaurantRepository();

  late Future<OrderEntityResponse> ordersFuture;
  late Future<Restaurant> restaurantFuture;

  bool isReconnecting = false;
  late String currentTime;

  @override
  void initState() {
    super.initState();
    ordersFuture = orderRepository.fetchOrders();
    restaurantFuture = restaurantRepository.fetchRestaurantName();

    widget.signalRService.orderStream.listen((headChefId) {
      _reloadOrders();
    });

    widget.signalRService.reconnectingStream.listen((isReconnecting) {
      setState(() {
        this.isReconnecting = isReconnecting;
      });
    });

    // Start a timer to update the clock every second
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = _getCurrentTime();
      });
    });

    currentTime = _getCurrentTime(); // Initialize current time
  }

  // Function to get the current time formatted as HH:mm:ss
  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  void _reloadOrders() {
    setState(() {
      ordersFuture = orderRepository.fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80.0, left: 16.0, right: 16.0),
            child: FutureBuilder<OrderEntityResponse>(
              future: ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData ||
                    snapshot.data!.results.isEmpty) {
                  return Center(child: Text('No orders available.'));
                } else {
                  List<OrderEntity> orderItems = snapshot.data!.results;
                  return ListView.builder(
                    itemCount: orderItems.length,
                    itemBuilder: (context, index) {
                      final order = orderItems[index];
                      return ItemCard(
                        orderId: order.orderId,
                        orderDetailsId: order.id,
                        tableNumber: order.tableNumber,
                        dateTime: order.createdDate,
                        note: order.note,
                        image: order.image,
                        orderedItem:
                            (order.dishName ?? order.comboName).toString(),
                      );
                    },
                  );
                }
              },
            ),
          ),
          if (isReconnecting)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.yellow,
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Reconnecting...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          // Restaurant Name and Digital Clock at the Top
          FutureBuilder<Restaurant>(
            future: restaurantFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Positioned(
                  top: 40, // Adjust the top position as needed
                  left: 0,
                  right: 0,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Positioned(
                  top: 40,
                  left: 0,
                  right: 0,
                  child: Center(child: Text('Error: ${snapshot.error}')),
                );
              } else if (snapshot.hasData) {
                return Positioned(
                  top: 40, // Adjust the top position as needed
                  left: 16.0,
                  right: 16.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Restaurant Name
                      Text(
                        snapshot.data!.restaurantName,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      // Digital Clock
                      Text(
                        currentTime,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox.shrink(); // No data, so show nothing
              }
            },
          ),
        ],
      ),
    );
  }
}
