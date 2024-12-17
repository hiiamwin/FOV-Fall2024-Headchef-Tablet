import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fov_fall2024_headchef_tablet_app/app/entities/OrderEntity.dart';
import 'package:fov_fall2024_headchef_tablet_app/app/services/signalr_service.dart';
import 'package:fov_fall2024_headchef_tablet_app/app/repositories/order_repository.dart';
import './home_page.component.dart';

class HomePage extends StatefulWidget {
  final SignalRService signalRService;

  HomePage({required this.signalRService});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final orderRepository = OrderRepository();
  late Future<OrderEntityResponse> ordersFuture;
  bool isReconnecting = false;

  @override
  void initState() {
    super.initState();
    ordersFuture = orderRepository.fetchOrders();

    widget.signalRService.orderStream.listen((headChefId) {
      _reloadOrders();
    });

    widget.signalRService.reconnectingStream.listen((isReconnecting) {
      setState(() {
        this.isReconnecting = isReconnecting;
      });
    });
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
        ],
      ),
    );
  }
}
