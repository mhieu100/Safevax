class BookingResponse {
  final int paymentId;
  final int referenceId;
  final String method;
  final String? paymentURL;
  final double? amount;

  BookingResponse({
    required this.paymentId,
    required this.referenceId,
    required this.method,
    this.paymentURL,
    this.amount,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      paymentId: json['paymentId'] ?? 0,
      referenceId: json['referenceId'] ?? 0,
      method: json['method'] ?? '',
      paymentURL: json['paymentURL'],
      amount:
          json['amount'] != null ? (json['amount'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'referenceId': referenceId,
      'method': method,
      'paymentURL': paymentURL,
      'amount': amount,
    };
  }
}
