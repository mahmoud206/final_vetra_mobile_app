class PaymentReport {
  final double incomingAmount;
  final double outgoingAmount;
  final double totalAmount;
  
  final double cashIncoming;
  final double cashOutgoing;
  final double cashTotal;
  
  final double networkIncoming;
  final double networkOutgoing;
  final double networkTotal;
  
  PaymentReport({
    required this.incomingAmount,
    required this.outgoingAmount,
    required this.totalAmount,
    required this.cashIncoming,
    required this.cashOutgoing,
    required this.cashTotal,
    required this.networkIncoming,
    required this.networkOutgoing,
    required this.networkTotal,
  });
  
  factory PaymentReport.fromData(List<Map<String, dynamic>> data) {
    double incomingAmount = 0;
    double outgoingAmount = 0;
    
    double cashIncoming = 0;
    double cashOutgoing = 0;
    
    double networkIncoming = 0;
    double networkOutgoing = 0;
    
    for (final payment in data) {
      final amount = payment['amount'] as num? ?? 0;
      final isOutgoing = payment['isOutgoing'] as bool? ?? false;
      final method = payment['method'] as String? ?? 'كاش';
      
      if (isOutgoing) {
        outgoingAmount += amount.toDouble();
        
        if (method == 'كاش') {
          cashOutgoing += amount.toDouble();
        } else if (method == 'شبكة') {
          networkOutgoing += amount.toDouble();
        }
      } else {
        incomingAmount += amount.toDouble();
        
        if (method == 'كاش') {
          cashIncoming += amount.toDouble();
        } else if (method == 'شبكة') {
          networkIncoming += amount.toDouble();
        }
      }
    }
    
    return PaymentReport(
      incomingAmount: incomingAmount,
      outgoingAmount: outgoingAmount,
      totalAmount: incomingAmount - outgoingAmount,
      cashIncoming: cashIncoming,
      cashOutgoing: cashOutgoing,
      cashTotal: cashIncoming - cashOutgoing,
      networkIncoming: networkIncoming,
      networkOutgoing: networkOutgoing,
      networkTotal: networkIncoming - networkOutgoing,
    );
  }
}