import 'package:flutter/material.dart';
import 'package:fov_fall2024_headchef_tablet_app/app/presentation/pages/request_ingredient_pages/request_ingredient_page.dart';
import './home_page.component.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //Sample list data of 10
          Padding(
            padding: const EdgeInsets.only(top: 80.0, left: 16.0, right: 16.0),
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ItemCard(
                  orderNo: 'Order #${index + 1}',
                  dateTime: DateTime.now(),
                  tableNo: 'Table 0${index + 1}',
                  priority: index % 2 == 0 ? 'High' : 'Low',
                  orderedItem: 'Cà ri chay',
                );
              },
            ),
          ),
          //Request ingredient button
          Positioned(
            top: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RequestIngredientPage()),
                );
              },
              icon: Icon(Icons.add_box),
              label: Text('Request Ingredient'),
            ),
          )
        ],
      ),
    );
  }
}
