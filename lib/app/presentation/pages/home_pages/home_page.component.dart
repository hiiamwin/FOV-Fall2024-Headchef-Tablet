import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fov_fall2024_headchef_tablet_app/app/repositories/order_repository.dart'; // Import your repository

class ItemCard extends StatelessWidget {
  final String orderId;
  final String orderDetailsId;
  final DateTime dateTime;
  final String orderedItem;

  ItemCard({
    required this.orderId,
    required this.orderDetailsId,
    required this.dateTime,
    required this.orderedItem,
  });

  // Create an instance of the OrderRepository to access confirmOrder method
  final orderRepository = OrderRepository();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order number', style: TextStyle(fontSize: 24)),
                    Text(
                      orderDetailsId,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date and time', style: TextStyle(fontSize: 24)),
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(dateTime),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                  ],
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Ordered item: ',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  orderedItem,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                ),
                onPressed: () async {
                  // Call confirmOrder when the button is pressed
                  try {
                    final result = await orderRepository.confirmOrder(
                        orderId, orderDetailsId);
                    // Handle the result (e.g., show a success message)
                    print("Order confirmed: $result");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Order confirmed successfully')),
                    );
                  } catch (e) {
                    // Handle error
                    print("Error confirming order: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to confirm order.')),
                    );
                  }
                },
                child: Text(
                  'Served',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color cardColorByPriority(String priority) {
  switch (priority) {
    case 'Low':
      return Color.fromARGB(255, 181, 214, 167);
    case 'Medium':
      return Color.fromARGB(255, 253, 152, 0);
    case 'High':
      return Color.fromARGB(255, 245, 93, 30);
    default:
      return Colors.white;
  }
}
