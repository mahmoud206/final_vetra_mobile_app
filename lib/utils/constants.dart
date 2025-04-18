class Constants {
  // Database connection
  static const String mongoUri = 'mongodb+srv://vetinternational1968:mahmoud123456@ivc-cluster.2nmzm9h.mongodb.net/';
  
  // Database names
  static const List<String> databases = [
    'Elanam-KhamisMushit',
    'Elanam-Baish',
    'Elanam-Zapia',
  ];
  
  // Collection names
  static const String paymentCollection = 'Payment';
  static const String saleCollection = 'Sale';
  
  // Excluded contacts
  static const List<String> excludedContacts = [
    'د/ محمد صيدلية بيش',
    'عيادة الأنعام - الإدارة',
    'مؤسسة علي محمد غروي البيطرية',
    'صيدليه علي محمد غروي',
    'عيادة الانعام الظبية',
  ];
  
  // Payment methods
  static const String cashMethod = 'كاش';
  static const String networkMethod = 'شبكة';
  
  // Arabic text strings
  static const String appTitle = 'تقارير الإنعام';
  static const String selectDatabase = 'اختر قاعدة البيانات';
  static const String selectDateRange = 'اختر نطاق التاريخ';
  static const String startDate = 'تاريخ البدء';
  static const String endDate = 'تاريخ الانتهاء';
  static const String generateReport = 'إنشاء التقرير';
  static const String shareReport = 'مشاركة التقرير';
  static const String loading = 'جاري التحميل...';
  static const String reportGenerated = 'تم إنشاء التقرير بنجاح';
  static const String reportGenerationError = 'حدث خطأ أثناء إنشاء التقرير';
  static const String noDataFound = 'لا توجد بيانات للفترة المحددة';
  
  // Report sections
  static const String paymentReport = 'تقرير المدفوعات';
  static const String clinicReport = 'تقرير العيادة';
  static const String salesProfitReport = 'تقرير المبيعات والأرباح';
  static const String expensesReport = 'تقرير المصروفات';
  
  // Payment report columns
  static const String incoming = 'وارد';
  static const String outgoing = 'صادر';
  static const String total = 'الإجمالي';
  static const String cashPayments = 'المدفوعات النقدية';
  static const String networkPayments = 'المدفوعات بالشبكة';
  
  // Clinic report columns
  static const String service = 'الخدمة';
  static const String quantity = 'الكمية';
  static const String price = 'السعر';
  static const String amount = 'المبلغ';
  static const String largeServices = 'خدمات لارج';
  static const String regularServices = 'خدمات عادية';
  
  // Sales & profit report columns
  static const String revenue = 'الإيرادات';
  static const String profit = 'الأرباح';
  static const String date = 'التاريخ';
  static const String customer = 'العميل';
  
  // Expenses report columns
  static const String expenseType = 'نوع المصروف';
  static const String expenseAmount = 'مبلغ المصروف';
}