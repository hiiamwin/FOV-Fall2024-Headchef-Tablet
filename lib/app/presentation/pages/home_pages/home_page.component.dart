import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemCard extends StatelessWidget {
  final String orderNo;
  final DateTime dateTime;
  final String tableNo;
  final String priority;
  final String orderedItem;

  ItemCard({
    required this.orderNo,
    required this.dateTime,
    required this.tableNo,
    required this.priority,
    required this.orderedItem,
  });

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
                    Text('Order number'),
                    Text(
                      orderNo,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date and time'),
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(dateTime),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Table number'),
                    Text(
                      tableNo,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Priority'),
                    Text(
                      priority,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: cardColorByPriority(priority)),
                    ),
                  ],
                ),
              ],
            ),
            Divider(),
            // Second row
            Text(
              'Ordered item: $orderedItem',
              style: TextStyle(fontSize: 16),
            ),
            // Third row
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.green)),
                onPressed: () {
                  // Accept action here
                  print("Accepted $orderNo");
                },
                child: Text(
                  'Accept',
                  style: TextStyle(color: Colors.white),
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
