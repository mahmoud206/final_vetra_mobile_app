import '../utils/constants.dart';

class DailySalesProfit {
  final DateTime date;
  final double revenue;
  final double profit;
  
  DailySalesProfit({
    required this.date,
    required this.revenue,
    required this.profit,
  });
}

class SalesProfitReport {
  final double totalRevenue;
  final double totalProfit;
  final double profitMargin;
  final List<DailySalesProfit> dailyData;
  
  SalesProfitReport({
    required this.totalRevenue,
    required this.totalProfit,
    required this.profitMargin,
    required this.dailyData,
  });
  
  factory SalesProfitReport.fromData(List<Map<String, dynamic>> data) {
    double totalRevenue = 0;
    double totalProfit = 0;
    final Map<String, DailySalesProfit> dailyDataMap = {};
    
    for (final sale in data) {
      final contactName = sale['contactName'] as String? ?? '';
      
      // Skip excluded contacts
      if (Constants.excludedContacts.contains(contactName)) {
        continue;
      }
      
      final createdAt = sale['createdAt'] as DateTime? ?? DateTime.now();
      final dateKey = '${createdAt.year}-${createdAt.month}-${createdAt.day}';
      
      final salePrice = (sale['salePrice'] as num?)?.toDouble() ?? 0;
      final cost = (sale['cost'] as num?)?.toDouble() ?? 0;
      final profit = salePrice - cost;
      
      totalRevenue += salePrice;
      totalProfit += profit;
      
      if (dailyDataMap.containsKey(dateKey)) {
        final existingData = dailyDataMap[dateKey]!;
        dailyDataMap[dateKey] = DailySalesProfit(
          date: createdAt,
          revenue: existingData.revenue + salePrice,
          profit: existingData.profit + profit,
        );
      } else {
        dailyDataMap[dateKey] = DailySalesProfit(
          date: createdAt,
          revenue: salePrice,
          profit: profit,
        );
      }
    }
    
    final dailyData = dailyDataMap.values.toList();
    
    // Sort by date (ascending)
    dailyData.sort((a, b) => a.date.compareTo(b.date));
    
    final profitMargin = totalRevenue > 0 ? totalProfit / totalRevenue : 0;
    
    return SalesProfitReport(
      totalRevenue: totalRevenue,
      totalProfit: totalProfit,
      profitMargin: profitMargin,
      dailyData: dailyData,
    );
  }
}