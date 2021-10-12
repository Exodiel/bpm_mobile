class ReportByMonth {
  String total;
  int month;
  String count;

  ReportByMonth({
    required this.total,
    required this.month,
    required this.count,
  });

  factory ReportByMonth.fromJson(Map<String, dynamic> json) => ReportByMonth(
    total: json['total'],
    month: json['month'],
    count: json['count'],
  );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['total'] = total;
    data['month'] = month;
    data['count'] = count;
    return data;
  }
}
