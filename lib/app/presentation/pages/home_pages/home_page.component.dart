import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fov_fall2024_headchef_tablet_app/app/repositories/order_repository.dart';

class ItemCard extends StatefulWidget {
  final String orderId;
  final String orderDetailsId;
  final int tableNumber;
  final DateTime dateTime;
  final String orderedItem;
  final String? note;
  final String? image;

  ItemCard({
    required this.orderId,
    required this.orderDetailsId,
    required this.tableNumber,
    required this.dateTime,
    required this.orderedItem,
    required this.note,
    required this.image,
  });

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final orderRepository = OrderRepository();
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Table ${widget.tableNumber}',
                        style: TextStyle(fontSize: 24)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${DateFormat('dd/MM/yyyy HH:mm').format(widget.dateTime.add(Duration(hours: 7)))}',
                        style: TextStyle(fontSize: 24)),
                  ],
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.network(
                    widget.image.toString(),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.orderedItem,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        if (widget.note != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Note: ${widget.note}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          EdgeInsets.only(
                                              bottom: 10,
                                              top: 10,
                                              left: 40,
                                              right: 40)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    isButtonPressed
                                        ? Colors.grey
                                        : Colors.green,
                                  ),
                                ),
                                onPressed: isButtonPressed
                                    ? null
                                    : () async {
                                        setState(() {
                                          isButtonPressed = true;
                                        });

                                        try {
                                          final result = await orderRepository
                                              .confirmOrder(
                                            widget.orderId,
                                            widget.orderDetailsId,
                                          );
                                          print("Order confirmed: $result");
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Order confirmed successfully'),
                                            ),
                                          );
                                        } catch (e) {
                                          print("Error confirming order: $e");
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Failed to confirm order.')),
                                          );
                                        }
                                      },
                                child: Text(
                                  'Served',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Align(
            //   alignment: Alignment.bottomRight,
            //   child: ElevatedButton(
            //     style: ButtonStyle(
            //       backgroundColor: MaterialStateProperty.all<Color>(
            //         isButtonPressed ? Colors.grey : Colors.green,
            //       ),
            //     ),
            //     onPressed: isButtonPressed
            //         ? null
            //         : () async {
            //             setState(() {
            //               isButtonPressed = true;
            //             });

            //             try {
            //               final result = await orderRepository.confirmOrder(
            //                 widget.orderId,
            //                 widget.orderDetailsId,
            //               );
            //               print("Order confirmed: $result");
            //               ScaffoldMessenger.of(context).showSnackBar(
            //                 SnackBar(
            //                     content: Text('Order confirmed successfully')),
            //               );
            //             } catch (e) {
            //               print("Error confirming order: $e");
            //               ScaffoldMessenger.of(context).showSnackBar(
            //                 SnackBar(content: Text('Failed to confirm order.')),
            //               );
            //             }
            //           },
            //     child: Text(
            //       'Served',
            //       style: TextStyle(fontSize: 30, color: Colors.white),
            //     ),
            //   ),
            // ),
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
