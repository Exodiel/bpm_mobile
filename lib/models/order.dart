class Order {
  int id;
  String sequential;
  String date;
  double discount;
  double subtotal;
  double tax;
  double total;
  String description;
  String type;
  String payment;
  String state;
  String address;
  String origin;
  String createdAt;
  String updatedAt;

  Order({
    required this.id,
    required this.sequential,
    required this.date,
    required this.discount,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.description,
    required this.type,
    required this.payment,
    required this.state,
    required this.address,
    required this.origin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        sequential: json['sequential'],
        date: json['date'],
        discount: double.parse(json['discount']),
        subtotal: double.parse(json['subtotal']),
        tax: double.parse(json['tax']),
        total: double.parse(json['total']),
        description: json['description'],
        type: json['type'],
        payment: json['payment'],
        state: json['state'],
        address: json['address'],
        origin: json['origin'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sequential'] = sequential;
    data['date'] = date;
    data['discount'] = discount;
    data['subtotal'] = subtotal;
    data['tax'] = tax;
    data['total'] = total;
    data['description'] = description;
    data['type'] = type;
    data['payment'] = payment;
    data['state'] = state;
    data['address'] = address;
    data['origin'] = origin;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
