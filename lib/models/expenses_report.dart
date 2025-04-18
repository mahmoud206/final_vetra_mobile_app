class Expense {
  final String type;
  final double amount;
  final DateTime date;
  
  Expense({
    required this.type,
    required this.amount,
    required this.date,
  });
}

class ExpensesReport {
  final List<Expense> expenses;
  final double totalExpenses;
  
  ExpensesReport({
    required this.expenses,
    required this.totalExpenses,
  });
  
  factory ExpensesReport.fromData(List<Map<String, dynamic>> data) {
    final List<Expense> expenses = [];
    double totalExpenses = 0;
    
    for (final expense in data) {
      if (expense['isOutgoing'] == true) {
        final type = expense['type'] as String? ?? 'مصروف غير محدد';
        final amount = (expense['amount'] as num?)?.toDouble() ?? 0;
        final date = expense['createdAt'] as DateTime? ?? DateTime.now();
        
        expenses.add(Expense(
          type: type,
          amount: amount,
          date: date,
        ));
        
        totalExpenses += amount;
      }
    }
    
    // Sort by date (descending)
    expenses.sort((a, b) => b.date.compareTo(a.date));
    
    return ExpensesReport(
      expenses: expenses,
      totalExpenses: totalExpenses,
    );
  }
}