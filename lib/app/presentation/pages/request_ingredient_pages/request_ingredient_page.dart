import 'package:flutter/material.dart';

class RequestIngredientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Ingredient'),
      ),
      body: Center(
        child: Text(
          'Request Ingredient Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
