class Restaurant {
  final String restaurantName;

  Restaurant({required this.restaurantName});

  // Factory method to create a Restaurant from JSON
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      restaurantName: json['restaurantName'],
    );
  }
}
