class ClinicService {
  final String name;
  final int quantity;
  final double price;
  final double amount;
  
  ClinicService({
    required this.name,
    required this.quantity,
    required this.price,
    required this.amount,
  });
}

class ClinicReport {
  final List<ClinicService> regularServices;
  final List<ClinicService> largeServices;
  final double regularServicesTotal;
  final double largeServicesTotal;
  final double totalServicesAmount;
  
  ClinicReport({
    required this.regularServices,
    required this.largeServices,
    required this.regularServicesTotal,
    required this.largeServicesTotal,
    required this.totalServicesAmount,
  });
  
  factory ClinicReport.fromData(List<Map<String, dynamic>> data) {
    final Map<String, ClinicService> regularServiceMap = {};
    final Map<String, ClinicService> largeServiceMap = {};
    
    for (final sale in data) {
      final services = sale['services'] as List<dynamic>? ?? [];
      
      for (final service in services) {
        final name = service['name'] as String? ?? 'خدمة غير معروفة';
        final quantity = service['quantity'] as int? ?? 1;
        final price = (service['price'] as num?)?.toDouble() ?? 0;
        final amount = price * quantity;
        
        final isLarge = name.contains('لارج');
        final serviceMap = isLarge ? largeServiceMap : regularServiceMap;
        
        if (serviceMap.containsKey(name)) {
          final existingService = serviceMap[name]!;
          serviceMap[name] = ClinicService(
            name: name,
            quantity: existingService.quantity + quantity,
            price: price, // Use the latest price
            amount: existingService.amount + amount,
          );
        } else {
          serviceMap[name] = ClinicService(
            name: name,
            quantity: quantity,
            price: price,
            amount: amount,
          );
        }
      }
    }
    
    final regularServices = regularServiceMap.values.toList();
    final largeServices = largeServiceMap.values.toList();
    
    // Sort by amount (descending)
    regularServices.sort((a, b) => b.amount.compareTo(a.amount));
    largeServices.sort((a, b) => b.amount.compareTo(a.amount));
    
    final regularServicesTotal = regularServices.fold<double>(
      0, (sum, service) => sum + service.amount);
    
    final largeServicesTotal = largeServices.fold<double>(
      0, (sum, service) => sum + service.amount);
    
    return ClinicReport(
      regularServices: regularServices,
      largeServices: largeServices,
      regularServicesTotal: regularServicesTotal,
      largeServicesTotal: largeServicesTotal,
      totalServicesAmount: regularServicesTotal + largeServicesTotal,
    );
  }
}