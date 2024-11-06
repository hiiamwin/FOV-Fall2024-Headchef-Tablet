class OrderEntityResponse {
  final int pageNumber;
  final int pageSize;
  final int totalNumberOfPages;
  final int totalNumberOfRecords;
  final List<OrderEntity> results;

  OrderEntityResponse({
    required this.pageNumber,
    required this.pageSize,
    required this.totalNumberOfPages,
    required this.totalNumberOfRecords,
    required this.results,
  });

  factory OrderEntityResponse.fromJson(Map<String, dynamic> json) {
    var resultsJson = json['results'] as List;
    List<OrderEntity> resultsList =
        resultsJson.map((item) => OrderEntity.fromJson(item)).toList();

    return OrderEntityResponse(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalNumberOfPages: json['totalNumberOfPages'],
      totalNumberOfRecords: json['totalNumberOfRecords'],
      results: resultsList,
    );
  }
}

class OrderEntity {
  final String orderId;
  final String id;
  final String? dishName;
  final String? comboName;
  final String note;
  final DateTime createdDate;

  OrderEntity({
    required this.orderId,
    required this.id,
    this.dishName,
    this.comboName,
    required this.note,
    required this.createdDate,
  });

  // Factory method to create SuggestedDish from JSON
  factory OrderEntity.fromJson(Map<String, dynamic> json) {
    return OrderEntity(
      orderId: json['orderId'],
      id: json['id'],
      dishName: json['dishName'],
      comboName: json['comboName'],
      note: json['note'],
      createdDate: DateTime.parse(json['createdDate']),
    );
  }
}